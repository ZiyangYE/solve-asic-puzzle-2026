import json
import math
import re
import shutil
from pathlib import Path

graph_source = Path("output/step4_dependency_graph.json")
netlist_source = Path("output/step4_netlist.v")
output = Path("output/step5")

graph = json.loads(graph_source.read_text())
ff_nodes = [node["id"] for node in graph["nodes"] if node["type"] == "ff"]
ff_set = set(ff_nodes)
points = {
    node["id"]: (node["x"], node["y"])
    for node in graph["nodes"]
    if node["type"] == "ff"
}


def strongly_connected_components():
    adjacent = {node: [] for node in ff_nodes}
    for edge in graph["edges"]:
        if edge["source"] in ff_set and edge["target"] in ff_set:
            adjacent[edge["source"]].append(edge["target"])

    index = 0
    indices = {}
    low = {}
    stack = []
    on_stack = set()
    components = []

    def visit(node):
        nonlocal index
        indices[node] = low[node] = index
        index += 1
        stack.append(node)
        on_stack.add(node)

        for target in adjacent[node]:
            if target not in indices:
                visit(target)
                low[node] = min(low[node], low[target])
            elif target in on_stack:
                low[node] = min(low[node], indices[target])

        if low[node] == indices[node]:
            component = []
            while True:
                member = stack.pop()
                on_stack.remove(member)
                component.append(member)
                if member == node:
                    break
            components.append(sorted(component))

    for node in ff_nodes:
        if node not in indices:
            visit(node)
    return components


components = strongly_connected_components()
component_of = {
    node: number
    for number, component in enumerate(components)
    for node in component
}

component_links = set()
for edge in graph["edges"]:
    if edge["source"] not in ff_set or edge["target"] not in ff_set:
        continue
    left = component_of[edge["source"]]
    right = component_of[edge["target"]]
    if left != right:
        component_links.add((min(left, right), max(left, right)))


def component_distance(left, right):
    return min(
        math.dist(points[a], points[b])
        for a in components[left]
        for b in components[right]
    )


singletons = {
    number for number, component in enumerate(components) if len(component) == 1
}
singleton_edges = sorted(
    (component_distance(left, right), left, right)
    for left, right in component_links
    if left in singletons and right in singletons
)

gap_low, gap_high = max(
    zip(singleton_edges, singleton_edges[1:]),
    key=lambda pair: pair[1][0] / pair[0][0],
)
distance_cutoff = math.sqrt(gap_low[0] * gap_high[0])

singleton_graph = {number: [] for number in singletons}
for distance, left, right in singleton_edges:
    if distance <= distance_cutoff:
        singleton_graph[left].append(right)
        singleton_graph[right].append(left)

singleton_groups = []
seen = set()
for start in singletons:
    if start in seen:
        continue
    group = set()
    stack = [start]
    seen.add(start)
    while stack:
        node = stack.pop()
        group.add(node)
        for neighbor in singleton_graph[node]:
            if neighbor not in seen:
                seen.add(neighbor)
                stack.append(neighbor)
    singleton_groups.append(group)

core_groups = {
    number: {number}
    for number, component in enumerate(components)
    if len(component) > 1
}
groups = []
for group in singleton_groups:
    if len(group) > 1:
        groups.append(group)
        continue

    singleton = next(iter(group))
    candidates = [
        core
        for core in core_groups
        if (min(singleton, core), max(singleton, core)) in component_links
    ]
    if candidates:
        closest = min(candidates, key=lambda core: component_distance(singleton, core))
        if component_distance(singleton, closest) <= distance_cutoff:
            core_groups[closest].add(singleton)
            continue
    groups.append(group)

groups += core_groups.values()
member_groups = [
    sorted(node for component in group for node in components[component])
    for group in groups
]
member_groups.sort(
    key=lambda members: (
        min(points[node][1] for node in members),
        min(points[node][0] for node in members),
    )
)

text = netlist_source.read_text()
gate_pattern = (
    r"^\s*(sky130_fd_sc_hd__(\w+))\s+(\w+)\s+\((.*)\);"
    r"\s*// x=([-\d.]+) y=([-\d.]+)$"
)
pin_pattern = r"\.(\w+)\(([^)]+)\)"
output_pins = {"X", "Y", "Q"}

instances = {}
for _cell, family, name, connections, x, y in re.findall(gate_pattern, text, re.M):
    instances[name] = {
        "family": family,
        "pins": dict(re.findall(pin_pattern, connections)),
        "point": (float(x), float(y)),
    }

drivers = {
    net: name
    for name, instance in instances.items()
    for pin, net in instance["pins"].items()
    if pin in output_pins
}
ff_names = {node.removeprefix("ff:") for node in ff_nodes}


def signal(net):
    return drivers.get(net) or net


def logic_cone(nets):
    gates = []
    seen = set()

    def visit(net):
        driver = drivers.get(net)
        if driver is not None and driver not in ff_names and driver not in seen:
            seen.add(driver)
            for pin, input_net in instances[driver]["pins"].items():
                if pin not in output_pins:
                    visit(input_net)
            gates.append(driver)

    for net in nets:
        visit(net)
    return gates


def gate_equation(name):
    instance = instances[name]
    arguments = ", ".join(
        f"{pin}={signal(net)}"
        for pin, net in instance["pins"].items()
        if pin not in output_pins
    )
    return f"{name} = {instance['family']}({arguments})"


def interfaces(members):
    local = set(members)
    incoming = sorted({
        edge["source"]
        for edge in graph["edges"]
        if edge["target"] in local and edge["source"] not in local
    })
    outgoing = sorted({
        edge["source"]
        for edge in graph["edges"]
        if edge["source"] in local and edge["target"] not in local
    })
    return incoming, outgoing


def interface_value(node):
    return node.split(":", 1)[1]


def block_report(members):
    names = [node.removeprefix("ff:") for node in members]
    incoming, outgoing = interfaces(members)
    target_nets = [instances[name]["pins"]["D"] for name in names]
    gates = logic_cone(target_nets)

    inputs = ", ".join(map(interface_value, incoming)) or "(none)"
    outputs = ", ".join(map(interface_value, outgoing)) or "(none)"
    lines = [f"input: {inputs}", f"output: {outputs}", "", "equation:"]
    lines += [f"  {gate_equation(name)}" for name in gates]
    for name in names:
        lines.append(f"  {name} <= {signal(instances[name]['pins']['D'])}")
    lines += ["", "ff:"]
    lines += [
        f"  {name} ({points[f'ff:{name}'][0]:.3f}, {points[f'ff:{name}'][1]:.3f})"
        for name in names
    ]

    return lines


if output.exists():
    shutil.rmtree(output)
output.mkdir()

for number, members in enumerate(member_groups, 1):
    path = output / f"block_{number:02d}_{len(members)}ff_expressions.txt"
    path.write_text("\n".join(block_report(members)) + "\n")

dots = []
for number, members in enumerate(member_groups, 1):
    for node in members:
        dots.append((*points[node], number))

x0 = min(x for x, _y, _block in dots)
y0 = min(y for _x, y, _block in dots)
x1 = max(x for x, _y, _block in dots)
y1 = max(y for _x, y, _block in dots)
svg = [
    f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{x0 - 2} {y0 - 2} {x1 - x0 + 4} {y1 - y0 + 4}">'
]
for x, y, block in dots:
    color = f"hsl({block * 137.5 % 360:.1f} 70% 48%)"
    svg.append(f'<circle cx="{x}" cy="{y0 + y1 - y}" r="0.7" fill="{color}"/>')
svg.append("</svg>")
(output / "blocks.svg").write_text("\n".join(svg) + "\n")
