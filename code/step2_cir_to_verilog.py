import re
import sys
from pathlib import Path

sys.path.append("/usr/lib/klayout/pymod")
import klayout.db as pya

source = Path("output/step1_extracted.cir")
layout_source = Path("output/step1_layout.lvsdb")
gds_source = Path("asic-puzzle-2026/puzzle.gds")
output = Path("output/step2_netlist.v")

power = {"VPWR", "VGND", "VPB", "VNB", "sky130_gnd"}
top = {"clk", "rst_n", "enable", "I", "success"}
nonlogic = {
    "conb",
    "decap",
    "diode",
    "fill",
    "fillb",
    "tapvpwrvgnd",
}

aliases = {f"O[{i}]": f"out[{i}]" for i in range(8)}
aliases |= {
    "VPWR": "1'b1",
    "VGND": "1'b0",
    "sky130_gnd": "1'b0",
}

records = []
for line in source.read_text().splitlines():
    line = line.strip()
    if line.startswith("+"):
        records[-1] += " " + line[1:].strip()
    elif line and not line.startswith("*"):
        records.append(line)

rows = [line.split() for line in records]
headers = {row[1]: row[2:] for row in rows if row[0] == ".SUBCKT"}
begin = rows.index([".SUBCKT", "puzzle"]) + 1
end = rows.index([".ENDS", "puzzle"])


def family(cell):
    return cell.removeprefix("sky130_fd_sc_hd__").rsplit("_", 1)[0]


def signal_pin(name):
    return next(
        (pin for pin in name.split("|") if pin not in power and not pin.startswith(r"\$")),
        None,
    )


lvs = pya.LayoutVsSchematic()
lvs.read(str(layout_source))
layout = lvs.xref().netlist_a().circuit_by_name("puzzle")

gds = pya.Layout()
gds.read(str(gds_source))
centers = {}
for instance in gds.top_cell().each_inst():
    cell = gds.cell(instance.cell_index).name
    if not cell.startswith("sky130_fd_sc_hd__") or family(cell) in nonlogic:
        continue
    transform = instance.cplx_trans
    box = instance.bbox()
    signature = (
        cell,
        round(transform.disp.x * gds.dbu, 3),
        round(transform.disp.y * gds.dbu, 3),
        round(float(transform.angle), 6),
        bool(transform.is_mirror()),
    )
    centers[signature] = (box.center().x * gds.dbu, box.center().y * gds.dbu)

placed = []
for instance in layout.each_subcircuit():
    cell = instance.circuit_ref().name.lower()
    if family(cell) in nonlogic:
        continue
    transform = instance.trans
    signature = (
        cell,
        round(transform.disp.x, 3),
        round(transform.disp.y, 3),
        round(float(transform.angle), 6),
        bool(transform.is_mirror()),
    )
    placed.append(centers[signature])
placed = iter(placed)

gates = []
buffers = {}
for row in rows[begin:end]:
    cell = row[-1]
    if not row[0].startswith("X") or not cell.startswith("sky130_fd_sc_hd__"):
        continue

    cell_family = family(cell)
    if cell_family in nonlogic:
        continue

    position = next(placed)
    pins, nodes = headers[cell], row[1:-1]
    connections = [
        (pin, node)
        for raw_pin, node in zip(pins, nodes)
        if (pin := signal_pin(raw_pin))
    ]

    if cell_family == "clkbuf":
        pins = dict(connections)
        if "X" in pins:
            buffers[pins["X"]] = pins["A"]
        continue

    gates.append((re.sub(r"_\d+$", "", cell), connections, position))

nets = {}


def net(node):
    while node in buffers:
        node = buffers[node]
    if node in top:
        return node
    if node in aliases:
        return aliases[node]
    return nets.setdefault(node, f"n{len(nets):04d}")


body = []
for i, (cell, connections, position) in enumerate(gates):
    ports = ", ".join(f".{pin}({net(node)})" for pin, node in connections)
    body.append(
        f"  {cell} u{i:04d} ({ports});"
        f"  // x={position[0]:.3f} y={position[1]:.3f}"
    )

lines = [
    "module puzzle (",
    "  input wire clk,",
    "  input wire rst_n,",
    "  input wire enable,",
    "  input wire I,",
    "  output wire success,",
    "  output wire [7:0] out",
    ");",
]
names = list(nets.values())
for i in range(0, len(names), 8):
    lines.append("  wire " + ", ".join(names[i:i + 8]) + ";")

output.write_text("\n".join(lines + [""] + body + ["endmodule", ""]))
