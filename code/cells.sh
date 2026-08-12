library=third_party/skywater-pdk-libs-sky130_fd_sc_hd
mapfile -t used < <(grep -o 'sky130_fd_sc_hd__[a-z0-9_]*' output/step2_netlist.v |
  sed 's/sky130_fd_sc_hd__//' | sort -u)

cells=()
for cell in "${used[@]}"; do
  model=behavioral
  [[ $cell == df* ]] && model=functional
  cells+=("$library/cells/$cell/sky130_fd_sc_hd__$cell.$model.v")
done
