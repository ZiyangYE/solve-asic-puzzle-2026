cd "$(dirname "$0")/../.."
PATH="$HOME/miniconda3/envs/gds-reverse/bin:$PATH"
source code/cells.sh

iverilog -g2012 -grelative-include -s block_01_tb -o /tmp/step6b2.vvp \
  "${cells[@]}" \
  output/step6/block_01_8ff/block_01.v \
  input/step6/step6b2_block01_tb.v

vvp /tmp/step6b2.vvp
