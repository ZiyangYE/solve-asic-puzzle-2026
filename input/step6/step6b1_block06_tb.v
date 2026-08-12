`timescale 1ns/1ps

module block_06_tb;
  reg clk = 0;
  reg rst_n = 0;
  wire en_low = 0;
  wire en_high = 1;

  wire low_u0077, low_u0079, low_u0081, low_u0089, low_u0118;
  wire low_u0129, low_u0141, low_u0157, low_u0158;
  wire high_u0077, high_u0079, high_u0081, high_u0089, high_u0118;
  wire high_u0129, high_u0141, high_u0157, high_u0158;

  block_06 dut_low (
    .clk(clk), .rst_n(rst_n), .enable(en_low),
    .u0077(low_u0077), .u0079(low_u0079), .u0081(low_u0081),
    .u0089(low_u0089), .u0118(low_u0118), .u0129(low_u0129),
    .u0141(low_u0141), .u0157(low_u0157), .u0158(low_u0158)
  );

  block_06 dut_high (
    .clk(clk), .rst_n(rst_n), .enable(en_high),
    .u0077(high_u0077), .u0079(high_u0079), .u0081(high_u0081),
    .u0089(high_u0089), .u0118(high_u0118), .u0129(high_u0129),
    .u0141(high_u0141), .u0157(high_u0157), .u0158(high_u0158)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("output/step6/block_06_9ff/block_06.vcd");
    $dumpvars(1, block_06_tb);

    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1;

    repeat (249) @(posedge clk);
    @(negedge clk) rst_n = 0;
    @(posedge clk);
    @(negedge clk) rst_n = 1;
    repeat (250) @(posedge clk);

    @(negedge clk) $finish;
  end
endmodule
