`timescale 1ns/1ps

module block_13_tb;
  reg clk = 0;
  reg rst_n = 0;
  wire enable = 1;
  wire I_low = 0;
  wire I_high = 1;

  wire b6_u0077, b6_u0089, b6_u0118, b6_u0129, b6_u0141;

  wire low_u0080, low_u0082, low_u0088, low_u0096, low_u0101;
  wire low_u0104, low_u0110, low_u0111, low_u0112;
  wire low_u0138, low_u0139, low_u0140, low_u0142;
  wire high_u0080, high_u0082, high_u0088, high_u0096, high_u0101;
  wire high_u0104, high_u0110, high_u0111, high_u0112;
  wire high_u0138, high_u0139, high_u0140, high_u0142;

  block_06 source (
    .clk(clk), .rst_n(rst_n), .enable(enable),
    .u0077(b6_u0077), .u0089(b6_u0089), .u0118(b6_u0118),
    .u0129(b6_u0129), .u0141(b6_u0141)
  );

  block_13 dut_low (
    .clk(clk), .rst_n(rst_n), .I(I_low), .enable(enable),
    .u0077(b6_u0077), .u0089(b6_u0089), .u0118(b6_u0118),
    .u0129(b6_u0129), .u0141(b6_u0141), .u0101(low_u0101)
  );

  block_13 dut_high (
    .clk(clk), .rst_n(rst_n), .I(I_high), .enable(enable),
    .u0077(b6_u0077), .u0089(b6_u0089), .u0118(b6_u0118),
    .u0129(b6_u0129), .u0141(b6_u0141), .u0101(high_u0101)
  );

  assign low_u0080 = dut_low.ff_u0080.Q;
  assign low_u0082 = dut_low.ff_u0082.Q;
  assign low_u0088 = dut_low.ff_u0088.Q;
  assign low_u0096 = dut_low.ff_u0096.Q;
  assign low_u0104 = dut_low.ff_u0104.Q;
  assign low_u0110 = dut_low.ff_u0110.Q;
  assign low_u0111 = dut_low.ff_u0111.Q;
  assign low_u0112 = dut_low.ff_u0112.Q;
  assign low_u0138 = dut_low.ff_u0138.Q;
  assign low_u0139 = dut_low.ff_u0139.Q;
  assign low_u0140 = dut_low.ff_u0140.Q;
  assign low_u0142 = dut_low.ff_u0142.Q;

  assign high_u0080 = dut_high.ff_u0080.Q;
  assign high_u0082 = dut_high.ff_u0082.Q;
  assign high_u0088 = dut_high.ff_u0088.Q;
  assign high_u0096 = dut_high.ff_u0096.Q;
  assign high_u0104 = dut_high.ff_u0104.Q;
  assign high_u0110 = dut_high.ff_u0110.Q;
  assign high_u0111 = dut_high.ff_u0111.Q;
  assign high_u0112 = dut_high.ff_u0112.Q;
  assign high_u0138 = dut_high.ff_u0138.Q;
  assign high_u0139 = dut_high.ff_u0139.Q;
  assign high_u0140 = dut_high.ff_u0140.Q;
  assign high_u0142 = dut_high.ff_u0142.Q;

  always #5 clk = ~clk;

  initial begin
    $dumpfile("output/step6/block_13_13ff/block_13.vcd");
    $dumpvars(1, block_13_tb);

    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1;
    repeat (200) @(posedge clk);

    @(negedge clk) $finish;
  end
endmodule
