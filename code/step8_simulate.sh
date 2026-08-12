cd "$(dirname "$0")/.."
PATH="$HOME/miniconda3/envs/gds-reverse/bin:$PATH"
source code/cells.sh

iverilog -g2012 -grelative-include -s step8_tb -o /tmp/step8.vvp \
  "${cells[@]}" \
  output/step2_netlist.v \
  input/step8_tb.v

vvp /tmp/step8.vvp
