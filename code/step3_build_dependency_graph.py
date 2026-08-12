import json
import re
from pathlib import Path

source = Path("output/step2_netlist.v")
output = Path("output/step3_dependency_graph.json")

ff_cells = {"dfxtp", "dfrtp", "dfstp"}
output_pins = {"X", "Y", "Q"}

text = source.read_text()


def module_ports(direction):
    ports = []
    pattern = rf"^\s*{direction} wire(?: \[(\d+):(\d+)\])? (\w+)[,;]?$"
    for high, low, name in re.findall(pattern, text, re.M):
        if high:
            ports.extend(f"{name}[{i}]" for i in range(int(low), int(high) + 1))
        else:
            ports.append(name)
    return ports


inputs = [name for name in module_ports("input") if name not in {"clk", "rst_n"}]
outputs = module_ports("output")

instances = {}
flip_flops = {}
coordinates = {}
gate_pattern = (
    r"^\s*(sky130_fd_sc_hd__\w+)\s+(\w+)\s+\((.*)\);"
    r"\s*// x=([-\d.]+) y=([-\d.]+)$"
)
pin_pattern = r"\.(\w+)\(([^)]+)\)"

for cell, name, connections, x, y in re.findall(gate_pattern, text, re.M):
    instances[name] = dict(re.findall(pin_pattern, connections))
    coordinates[name] = {"x": float(x), "y": float(y)}
    family = cell.removeprefix("sky130_fd_sc_hd__")
    if family in ff_cells:
        flip_flops[name] = cell

drivers = {
    net: name
    for name, pins in instances.items()
    for pin, net in pins.items()
    if pin in output_pins
}


def dependencies(net):
    if net in inputs:
        return {f"input:{net}": set()}

    name = drivers.get(net)
    if name is None:
        return {}
    if name in flip_flops:
        return {f"ff:{name}": set()}

    result = {}
    for pin, input_net in instances[name].items():
        if pin in output_pins:
            continue
        for source, via in dependencies(input_net).items():
            result.setdefault(source, set()).update(via)
            result[source].add(name)
    return result


nodes = [
    {"id": f"input:{name}", "type": "input", "name": name}
    for name in inputs
]
nodes += [
    {
        "id": f"ff:{name}",
        "type": "ff",
        "name": name,
        "cell": cell,
        **coordinates[name],
    }
    for name, cell in flip_flops.items()
]
nodes += [
    {"id": f"output:{name}", "type": "output", "name": name}
    for name in outputs
]

edges = []
for name in flip_flops:
    for source, via in sorted(dependencies(instances[name]["D"]).items()):
        edges.append({"source": source, "target": f"ff:{name}", "via": sorted(via)})

for name in outputs:
    for source, via in sorted(dependencies(name).items()):
        edges.append({"source": source, "target": f"output:{name}", "via": sorted(via)})

output.write_text(json.dumps({
    "nodes": nodes,
    "edges": edges,
    "coordinates": coordinates,
}, indent=2) + "\n")
