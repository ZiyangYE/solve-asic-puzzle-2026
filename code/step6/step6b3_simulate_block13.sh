cd "$(dirname "$0")/../.."
PATH="$HOME/miniconda3/envs/gds-reverse/bin:$PATH"
source code/cells.sh

iverilog -g2012 -grelative-include -s block_13_tb -o /tmp/step6b3.vvp \
  "${cells[@]}" \
  output/step6/block_06_9ff/block_06.v \
  output/step6/block_13_13ff/block_13.v \
  input/step6/step6b3_block13_tb.v

vvp /tmp/step6b3.vvp
