import itertools
import re
import subprocess
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
minisat = root / "third_party/minisat/build/release/bin/minisat"


class Formula:
    def __init__(self):
        self.variables = {}
        self.clauses = []

    def var(self, name):
        if name not in self.variables:
            self.variables[name] = len(self.variables) + 1
        return self.variables[name]

    def equal(self, a, b):
        self.clauses += [[-a, b], [a, -b]]

    def solve(self, extra=[]):
        clauses = self.clauses + extra
        with tempfile.TemporaryDirectory() as tmp:
            cnf = Path(tmp) / "input.cnf"
            result = Path(tmp) / "result"
            lines = [f"p cnf {len(self.variables)} {len(clauses)}"]
            lines += [" ".join(map(str, clause)) + " 0" for clause in clauses]
            cnf.write_text("\n".join(lines) + "\n")
            subprocess.run(
                [minisat, "-verb=0", cnf, result],
                stdout=subprocess.DEVNULL,
            )
            words = result.read_text().split()
        if words[0] == "UNSAT":
            return None
        return {abs(int(x)): int(x) > 0 for x in words[1:] if x != "0"}


def pin_value(pin, pins):
    value = pins[pin]
    return not value if pin.endswith("_N") else value


def gate_value(cell, pins):
    values = [pin_value(pin, pins) for pin in pins]
    if cell == "buf":
        return values[0]
    if cell == "inv":
        return not values[0]
    if cell == "mux2":
        return pin_value("A1", pins) if pin_value("S", pins) else pin_value("A0", pins)
    if cell == "xor2":
        return values[0] != values[1]
    if cell == "xnor2":
        return values[0] == values[1]
    if cell.startswith("nand"):
        return not all(values)
    if cell.startswith("and"):
        return all(values)
    if cell.startswith("nor"):
        return not any(values)
    if cell.startswith("or"):
        return any(values)

    groups = {}
    for pin in pins:
        groups.setdefault(pin[0], []).append(pin_value(pin, pins))
    value = (any(all(x) for x in groups.values()) if cell.startswith("a")
             else all(any(x) for x in groups.values()))
    return not value if cell.endswith("i") else value


class Model:
    def __init__(self, output_bytes):
        text = (root / "output/step2_netlist.v").read_text()
        rows = re.findall(
            r"^\s*sky130_fd_sc_hd__(\w+)\s+(u\d+)\s+\((.*)\);", text, re.M
        )
        pin = re.compile(r"\.(\w+)\(([^)]+)\)")
        instances = [(cell, name, dict(pin.findall(pins))) for cell, name, pins in rows]
        self.ffs = [x for x in instances if x[0].startswith("df")]
        self.gates = [x for x in instances if not x[0].startswith("df")]
        self.formula = Formula()
        self.zero = self.formula.var("0")
        self.one = self.formula.var("1")
        self.formula.clauses += [[-self.zero], [self.one]]

        state = {name: self.formula.var(f"{name}@initial") for _, name, _ in self.ffs}
        for cell, name, _ in self.ffs:
            if cell == "dfrtp":
                self.formula.clauses.append([-state[name]])
            elif cell == "dfstp":
                self.formula.clauses.append([state[name]])

        for cycle in range(2):
            nets = self.frame(state, f"reset{cycle}", self.zero, self.zero)
            state = self.advance(nets, f"reset{cycle + 1}", True)

        self.inputs = []
        for cycle in range(121):
            bit = self.formula.var(f"I@{cycle}")
            self.inputs.append(bit)
            nets = self.frame(state, cycle, bit, self.one)
            state = self.advance(nets, cycle + 1)

        nets = self.frame(state, "message", self.zero, self.one)
        state = self.advance(nets, "message")
        self.outputs = []
        for index in range(output_bytes):
            nets = self.frame(state, f"char{index}", self.zero, self.one)
            self.outputs.append([nets[f"out[{bit}]"] for bit in range(8)])
            state = self.advance(nets, f"char{index}")

    def frame(self, state, cycle, I, enable):
        nets = {"1'b0": self.zero, "1'b1": self.one, "I": I, "enable": enable}
        for _, name, pins in self.ffs:
            nets[pins["Q"]] = state[name]
        for _, _, pins in self.gates:
            out = "X" if "X" in pins else "Y"
            nets[pins[out]] = self.formula.var(f"{pins[out]}@{cycle}")
        for cell, _, pins in self.gates:
            self.constrain_gate(cell, pins, nets)
        return nets

    def constrain_gate(self, cell, pins, nets):
        out = "X" if "X" in pins else "Y"
        inputs = {pin: net for pin, net in pins.items() if pin != out}
        input_nets = list(dict.fromkeys(inputs.values()))
        for bits in itertools.product((False, True), repeat=len(input_nets)):
            values = dict(zip(input_nets, bits))
            pin_values = {pin: values[net] for pin, net in inputs.items()}
            clause = [-nets[net] if value else nets[net] for net, value in values.items()]
            expected = gate_value(cell, pin_values)
            clause.append(nets[pins[out]] if expected else -nets[pins[out]])
            self.formula.clauses.append(clause)

    def advance(self, nets, cycle, reset=False):
        state = {name: self.formula.var(f"{name}@{cycle}") for _, name, _ in self.ffs}
        for cell, name, pins in self.ffs:
            if reset and cell == "dfrtp":
                self.formula.clauses.append([-state[name]])
            elif reset and cell == "dfstp":
                self.formula.clauses.append([state[name]])
            else:
                self.formula.equal(state[name], nets[pins["D"]])
        return state

    def sequence(self, solution):
        return "".join("1" if solution[x] else "0" for x in self.inputs)

    def byte(self, solution, byte):
        return sum(solution[x] << bit for bit, x in enumerate(byte))

    def is_byte(self, byte, value):
        return [[x if value >> bit & 1 else -x] for bit, x in enumerate(byte)]

    def differs(self, outputs, values):
        return [[
            -x if value >> bit & 1 else x
            for byte, value in zip(outputs, values)
            for bit, x in enumerate(byte)
        ]]


def replay(sequences):
    tools = Path.home() / "miniconda3/envs/gds-reverse/bin"
    messages = []
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        netlist = (root / "output/step2_netlist.v").read_text()
        used = sorted(set(re.findall(r"sky130_fd_sc_hd__(\w+)", netlist)))
        library = root / "third_party/skywater-pdk-libs-sky130_fd_sc_hd/cells"
        cells = [
            library / cell / f"sky130_fd_sc_hd__{cell}.{'functional' if cell.startswith('df') else 'behavioral'}.v"
            for cell in used
        ]
        subprocess.run([
            tools / "iverilog", "-g2012", "-grelative-include", "-s", "step9_tb",
            "-o", tmp / "sim", *cells,
            root / "output/step2_netlist.v", root / "input/step9_tb.v",
        ], cwd=root)
        for sequence in sequences:
            (tmp / "input").write_text(sequence + "\n")
            subprocess.run([
                tools / "vvp", tmp / "sim",
                f"+PATTERN={tmp / 'input'}", f"+MESSAGE={tmp / 'output'}",
            ], cwd=root, stdout=subprocess.DEVNULL)
            messages.append(bytes(int(x, 16) for x in (tmp / "output").read_text().split()))
    return messages


def show(message):
    return "".join(chr(x) if 32 <= x < 127 else f"\\x{x:02x}" for x in message)
