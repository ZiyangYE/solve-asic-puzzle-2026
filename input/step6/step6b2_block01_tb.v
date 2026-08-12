`timescale 1ns/1ps

module block_01_tb;
  reg clk = 0;
  reg rst_n = 0;
  reg I = 1;
  wire enable = 1;
  wire u0077_low = 0;
  wire u0077_high = 1;

  wire low_u0085, low_u0086, low_u0102, low_u0115;
  wire low_u0116, low_u0127, low_u0128, low_u0293;
  wire high_u0085, high_u0086, high_u0102, high_u0115;
  wire high_u0116, high_u0127, high_u0128, high_u0293;

  block_01 dut_low (
    .clk(clk), .rst_n(rst_n), .I(I), .enable(enable), .u0077(u0077_low),
    .u0085(low_u0085), .u0086(low_u0086), .u0102(low_u0102),
    .u0115(low_u0115), .u0116(low_u0116), .u0127(low_u0127),
    .u0128(low_u0128), .u0293(low_u0293)
  );

  block_01 dut_high (
    .clk(clk), .rst_n(rst_n), .I(I), .enable(enable), .u0077(u0077_high),
    .u0085(high_u0085), .u0086(high_u0086), .u0102(high_u0102),
    .u0115(high_u0115), .u0116(high_u0116), .u0127(high_u0127),
    .u0128(high_u0128), .u0293(high_u0293)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("output/step6/block_01_8ff/block_01.vcd");
    $dumpvars(1, block_01_tb);

    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1;

    repeat (25) begin
      repeat (10) @(posedge clk);
      @(negedge clk) I = 0;
      repeat (10) @(posedge clk);
      @(negedge clk) I = 1;
    end

    $finish;
  end
endmodule
