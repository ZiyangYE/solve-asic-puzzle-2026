cd "$(dirname "$0")/../.."
PATH="$HOME/miniconda3/envs/gds-reverse/bin:$PATH"
mkdir -p output/step6
source code/cells.sh

iverilog -g2012 -grelative-include -s block_06_tb -o /tmp/step6b1.vvp \
  "${cells[@]}" \
  output/step6/block_06_9ff/block_06.v \
  input/step6/step6b1_block06_tb.v

vvp /tmp/step6b1.vvp
