import json
import re
import shutil
from html import escape
from pathlib import Path

source = Path("output/step5")
graph_source = Path("output/step4_dependency_graph.json")
netlist_source = Path("output/step4_netlist.v")
output = Path("output/step6")

blocks = {}
for path in sorted(source.glob("*_expressions.txt")):
    block, count = re.fullmatch(r"(block_\d+)_(\d+)ff_expressions\.txt", path.name).groups()
    lines = path.read_text().splitlines()
    inputs = lines[0].removeprefix("input: ").split(", ")
    outputs = lines[1].removeprefix("output: ").split(", ")
    gates = re.findall(r"  (u\d+) = ", path.read_text())
    registers = re.findall(r"  (u\d+) <= ", path.read_text())
    blocks[block] = {
        "count": int(count),
        "inputs": [] if inputs == ["(none)"] else inputs,
        "outputs": [] if outputs == ["(none)"] else outputs,
        "gates": gates,
        "registers": registers,
    }

owner = {
    register: block
    for block, data in blocks.items()
    for register in data["registers"]
}

instance_pattern = re.compile(
    r"^  (sky130_fd_sc_hd__\w+) (u\d+) \((.*)\);(.*)$", re.M
)
pin_pattern = re.compile(r"\.(\w+)\(([^)]+)\)")
instances = {}
for cell, name, connections, comment in instance_pattern.findall(netlist_source.read_text()):
    instances[name] = {
        "cell": cell,
        "pins": dict(pin_pattern.findall(connections)),
        "connections": connections,
        "comment": comment,
    }


def write_netlist(path, block, data):
    external_registers = [name for name in data["inputs"] if name in owner]
    primary_inputs = [name for name in data["inputs"] if name not in owner]
    ports = [("input", name) for name in ("clk", "rst_n", *primary_inputs)]
    ports += [("input", name) for name in external_registers]
    ports += [("output", name) for name in data["outputs"]]

    lines = [f"module {block} ("]
    lines += [
        f"  {direction} wire {name}{',' if index + 1 < len(ports) else ''}"
        for index, (direction, name) in enumerate(ports)
    ]
    lines.append(");")

    selected = data["gates"] + data["registers"]
    nets = sorted({
        net
        for name in selected
        for net in instances[name]["pins"].values()
        if re.fullmatch(r"[A-Za-z_]\w*", net)
        and net not in {"clk", "rst_n", "I", "enable"}
    })
    for index in range(0, len(nets), 8):
        lines.append("  wire " + ", ".join(nets[index:index + 8]) + ";")

    for name in external_registers:
        lines.append(f"  assign {instances[name]['pins']['Q']} = {name};")
    for name in data["outputs"]:
        lines.append(f"  assign {name} = {instances[name]['pins']['Q']};")

    for name in selected:
        instance = instances[name]
        instance_name = f"ff_{name}" if name in data["registers"] else name
        lines.append(
            f"  {instance['cell']} {instance_name} "
            f"({instance['connections']});{instance['comment']}"
        )
    lines += ["endmodule", ""]
    path.write_text("\n".join(lines))


def svg_header(width, height, title):
    return [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="7" refY="3" orient="auto"><path d="M0,0 L0,6 L8,3 z" fill="#64748b"/></marker></defs>',
        '<rect width="100%" height="100%" fill="white"/>',
        f'<text x="24" y="30" font-family="sans-serif" font-size="18" font-weight="bold">{escape(title)}</text>',
    ]


def box(svg, x, y, name, detail, color):
    svg.append(
        f'<rect x="{x - 82}" y="{y - 24}" width="164" height="48" rx="7" fill="{color}" stroke="#475569"/>'
    )
    svg.append(
        f'<text x="{x}" y="{y - 3}" text-anchor="middle" font-family="monospace" font-size="12">{escape(name)}</text>'
    )
    svg.append(
        f'<text x="{x}" y="{y + 14}" text-anchor="middle" font-family="monospace" font-size="10" fill="#475569">{escape(detail)}</text>'
    )


graph = json.loads(graph_source.read_text())
dependency_edges = [
    (edge["source"].split(":", 1)[1], edge["target"].removeprefix("ff:"))
    for edge in graph["edges"]
    if edge["target"].startswith("ff:")
    and edge["source"].startswith(("ff:", "input:"))
]


def write_inputs(path, block, data):
    local = set(data["registers"])
    edges = [(source, target) for source, target in dependency_edges if target in local]
    external = {source for source, _target in edges if source not in local}
    external_blocks = {}
    primary = []
    for register in external:
        if register in owner:
            external_blocks.setdefault(owner[register], []).append(register)
        else:
            primary.append(register)

    positions = {}
    cursor = 80
    group_boxes = []
    for source_block, registers in sorted(external_blocks.items()):
        registers.sort()
        if len(registers) > 1:
            top = cursor - 25
            cursor += 35
        for register in registers:
            positions[register] = (140, cursor)
            cursor += 68
        if len(registers) > 1:
            group_boxes.append((source_block, top, cursor - 20))
            cursor += 22
        else:
            cursor += 10
    for register in sorted(primary):
        positions[register] = (140, cursor)
        cursor += 68

    local_nodes = sorted(local)
    for index, register in enumerate(local_nodes):
        positions[register] = (650, 75 + index * 68)
    height = max(260, cursor + 30, 100 + 68 * len(local_nodes))

    svg = svg_header(900, height, f"{block} register dependencies")
    for source_block, top, bottom in group_boxes:
        svg.append(
            f'<rect x="20" y="{top}" width="240" height="{bottom - top}" rx="8" fill="none" stroke="#64748b" stroke-dasharray="7 5"/>'
        )
        svg.append(
            f'<text x="32" y="{top + 18}" font-family="monospace" font-size="11" fill="#475569">{escape(source_block)}</text>'
        )

    for source, target in edges:
        x1, y1 = positions[source]
        x2, y2 = positions[target]
        if source == target:
            route = f"M{x1 + 82} {y1} C{x1 + 180} {y1 - 45}, {x1 + 180} {y1 + 45}, {x1 + 78} {y1 + 12}"
        elif source in local:
            route = f"M{x1 + 82} {y1} C820 {y1}, 820 {y2}, {x2 + 82} {y2}"
        else:
            middle = (x1 + x2) / 2
            route = f"M{x1 + 82} {y1} C{middle} {y1}, {middle} {y2}, {x2 - 82} {y2}"
        svg.append(
            f'<path d="{route}" fill="none" stroke="#64748b" stroke-opacity="0.65" marker-end="url(#arrow)"/>'
        )

    for register in sorted(external):
        x, y = positions[register]
        detail = owner.get(register, "primary")
        color = "#fef3c7" if register in owner else "#dcfce7"
        box(svg, x, y, register, detail, color)
    for register in local_nodes:
        box(svg, *positions[register], register, "local", "#dbeafe")

    svg.append("</svg>")
    path.write_text("\n".join(svg) + "\n")


if output.exists():
    shutil.rmtree(output)
output.mkdir()

for block, data in blocks.items():
    block_dir = output / f"{block}_{data['count']}ff"
    block_dir.mkdir()
    write_inputs(block_dir / "inputs.svg", block, data)
    write_netlist(block_dir / f"{block}.v", block, data)
