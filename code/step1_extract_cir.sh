mkdir -p output
klayout -b -r third_party/sky130_klayout_pdk/tech/sky130/lvs/sky130.lvs \
  -rd input=asic-puzzle-2026/puzzle.gds \
  -rd target_netlist=../output/step1_extracted.cir \
  -rd report=/tmp/puzzle.lvsdb >/dev/null 2>&1 || true

# Reload the CIR so the LVS database keeps each extracted instance transform.
klayout -b -r third_party/sky130_klayout_pdk/tech/sky130/lvs/sky130.lvs \
  -rd input=asic-puzzle-2026/puzzle.gds \
  -rd schematic=../output/step1_extracted.cir \
  -rd target_netlist=/tmp/puzzle.cir \
  -rd report=../output/step1_layout.lvsdb >/dev/null 2>&1 || true
