import json
import re
from collections import deque
from pathlib import Path

graph_source = Path("output/step3_dependency_graph.json")
netlist_source = Path("output/step2_netlist.v")
graph_output = Path("output/step4_dependency_graph.json")
netlist_output = Path("output/step4_netlist.v")

graph = json.loads(graph_source.read_text())

incoming = {}
for edge in graph["edges"]:
    incoming.setdefault(edge["target"], []).append(edge)

queue = deque(["output:success"])
node_ids = {"output:success"}
edges = []

while queue:
    target = queue.popleft()
    for edge in incoming.get(target, []):
        edges.append(edge)
        if edge["source"] not in node_ids:
            node_ids.add(edge["source"])
            queue.append(edge["source"])

nodes = [node for node in graph["nodes"] if node["id"] in node_ids]
coordinate_names = {
    node["name"] for node in nodes if node["type"] == "ff"
}
coordinate_names.update(gate for edge in edges for gate in edge["via"])
coordinates = {
    name: point
    for name, point in graph["coordinates"].items()
    if name in coordinate_names
}
graph_output.write_text(json.dumps({
    "nodes": nodes,
    "edges": edges,
    "coordinates": coordinates,
}, indent=2) + "\n")

text = netlist_source.read_text()
gate_pattern = (
    r"^\s*(sky130_fd_sc_hd__\w+)\s+(\w+)\s+\((.*)\);"
    r"\s*// x=([-\d.]+) y=([-\d.]+)$"
)
pin_pattern = r"\.(\w+)\(([^)]+)\)"
output_pins = {"X", "Y", "Q"}

instances = {}
order = []
for cell, name, connections, x, y in re.findall(gate_pattern, text, re.M):
    instances[name] = {
        "cell": cell,
        "connections": connections,
        "pins": dict(re.findall(pin_pattern, connections)),
        "x": x,
        "y": y,
    }
    order.append(name)

drivers = {
    net: name
    for name, instance in instances.items()
    for pin, net in instance["pins"].items()
    if pin in output_pins
}

all_flip_flops = {
    node["name"] for node in graph["nodes"] if node["type"] == "ff"
}
selected = {node["name"] for node in nodes if node["type"] == "ff"}
selected.update(gate for edge in edges for gate in edge["via"])

queue = deque(selected)
while queue:
    name = queue.popleft()
    for pin, net in instances[name]["pins"].items():
        driver = drivers.get(net)
        if pin not in output_pins and driver and driver not in selected and driver not in all_flip_flops:
            selected.add(driver)
            queue.append(driver)

inputs = ["clk", "rst_n"]
inputs += [node["name"] for node in nodes if node["type"] == "input"]
ports = [f"  input wire {name}" for name in inputs]
ports.append("  output wire success")

wires = sorted({
    net
    for name in selected
    for net in instances[name]["pins"].values()
    if re.fullmatch(r"n\d+", net)
})

verilog = ["module puzzle ("]
verilog += [line + ("," if i < len(ports) - 1 else "") for i, line in enumerate(ports)]
verilog.append(");")

for i in range(0, len(wires), 8):
    verilog.append("  wire " + ", ".join(wires[i:i + 8]) + ";")

for name in order:
    if name in selected:
        instance = instances[name]
        verilog.append(
            f"  {instance['cell']} {name} ({instance['connections']});"
            f"  // x={instance['x']} y={instance['y']}"
        )

verilog.append("endmodule")
netlist_output.write_text("\n".join(verilog) + "\n")
