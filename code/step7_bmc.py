import itertools
import re
import subprocess
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
netlist = root / "output/step4_netlist.v"
minisat = root / "third_party/minisat/build/release/bin/minisat"
output = root / "output/step7.txt"
data_cycles = 121

text = netlist.read_text()
instance_pattern = re.compile(
    r"^\s*sky130_fd_sc_hd__(\w+)\s+(u\d+)\s+\((.*)\);", re.M
)
pin_pattern = re.compile(r"\.(\w+)\(([^)]+)\)")
instances = [
    (family, name, dict(pin_pattern.findall(pins)))
    for family, name, pins in instance_pattern.findall(text)
]
flip_flops = [instance for instance in instances if instance[0] == "dfrtp"]
gates = [instance for instance in instances if instance[0] != "dfrtp"]


class Formula:
    def __init__(self):
        self.variables = {}
        self.clauses = []

    def var(self, name):
        if name not in self.variables:
            self.variables[name] = len(self.variables) + 1
        return self.variables[name]

    def equal(self, left, right):
        self.clauses += [[-left, right], [left, -right]]

    def write(self, path, extra=()):
        clauses = self.clauses + list(extra)
        lines = [f"p cnf {len(self.variables)} {len(clauses)}"]
        lines += [" ".join(map(str, clause)) + " 0" for clause in clauses]
        path.write_text("\n".join(lines) + "\n")


def term(pin, pins):
    value = pins[pin]
    return not value if pin.endswith("_N") else value


def gate_value(family, pins):
    values = [term(pin, pins) for pin in pins]

    if family == "buf":
        return values[0]
    if family == "inv":
        return not values[0]
    if family == "mux2":
        return term("A1", pins) if term("S", pins) else term("A0", pins)
    if family == "xor2":
        return values[0] != values[1]
    if family == "xnor2":
        return values[0] == values[1]
    if family.startswith("nand"):
        return not all(values)
    if family.startswith("and"):
        return all(values)
    if family.startswith("nor"):
        return not any(values)
    if family.startswith("or"):
        return any(values)

    groups = {}
    for pin in pins:
        groups.setdefault(pin[0], []).append(term(pin, pins))
    if family.startswith("a"):
        value = any(all(group) for group in groups.values())
    else:
        value = all(any(group) for group in groups.values())
    return not value if family.endswith("i") else value


def constrain_gate(formula, family, pins, nets):
    output_pin = "X" if "X" in pins else "Y"
    output_net = pins[output_pin]
    input_pins = {pin: net for pin, net in pins.items() if pin != output_pin}
    input_nets = list(dict.fromkeys(input_pins.values()))

    for bits in itertools.product((False, True), repeat=len(input_nets)):
        values = dict(zip(input_nets, bits))
        pin_values = {pin: values[net] for pin, net in input_pins.items()}
        expected = gate_value(family, pin_values)
        clause = [
            -nets[net] if value else nets[net]
            for net, value in values.items()
        ]
        clause.append(nets[output_net] if expected else -nets[output_net])
        formula.clauses.append(clause)


def solve(cnf, model_path):
    subprocess.run(
        [minisat, "-verb=0", cnf, model_path],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    words = model_path.read_text().split()
    if words[0] == "UNSAT":
        return None
    return {abs(int(word)): int(word) > 0 for word in words[1:] if word != "0"}


formula = Formula()
zero = formula.var("0")
one = formula.var("1")
formula.clauses += [[-zero], [one]]

states = [{name: formula.var(f"{name}@0") for _family, name, _pins in flip_flops}]
for state in states[0].values():
    formula.clauses.append([-state])

serial = []
for cycle in range(data_cycles + 1):
    I = formula.var(f"I@{cycle}")
    enable = formula.var(f"enable@{cycle}")
    serial.append(I)
    formula.clauses.append([enable if cycle < data_cycles else -enable])
    if cycle == data_cycles:
        formula.clauses.append([-I])

    nets = {"1'b0": zero, "1'b1": one, "I": I, "enable": enable}
    for _family, name, pins in flip_flops:
        nets[pins["Q"]] = states[cycle][name]
    for _family, _name, pins in gates:
        output_pin = "X" if "X" in pins else "Y"
        nets[pins[output_pin]] = formula.var(f"{pins[output_pin]}@{cycle}")
    for family, _name, pins in gates:
        constrain_gate(formula, family, pins, nets)

    next_state = {
        name: formula.var(f"{name}@{cycle + 1}")
        for _family, name, _pins in flip_flops
    }
    for _family, name, pins in flip_flops:
        formula.equal(next_state[name], nets[pins["D"]])
    states.append(next_state)

success = next(name for _family, name, pins in flip_flops if pins["Q"] == "success")
for state in states[1:-1]:
    formula.clauses.append([-state[success]])
formula.clauses.append([states[-1][success]])

with tempfile.TemporaryDirectory() as directory:
    directory = Path(directory)
    cnf = directory / "bmc.cnf"
    formula.write(cnf)
    model = solve(cnf, directory / "model")
    bits = [model[variable] for variable in serial[:data_cycles]]

sequence = "".join("1" if bit else "0" for bit in bits)
output.write_text(sequence + "\n")
print(sequence)
