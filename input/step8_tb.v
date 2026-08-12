`timescale 1ns/1ps

module step8_tb;
  wire clk, rst_n, enable, I, success;
  wire [7:0] out;

  step8_inputs inputs (clk, rst_n, enable, I);
  puzzle dut (clk, rst_n, enable, I, success, out);

  initial begin
    $dumpfile("output/step8.vcd");
    $dumpvars(1, step8_tb);
  end
endmodule

module step8_inputs (
  output reg clk,
  output reg rst_n,
  output reg enable,
  output reg I
);
  reg [120:0] bits [0:0];
  integer cycle;

  always #5 clk = ~clk;

  initial begin
    $readmemb("output/step7.txt", bits);
    clk = 0;
    rst_n = 0;
    enable = 0;
    I = 0;

    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1;

    for (cycle = 0; cycle < 121; cycle = cycle + 1) begin
      enable = 1;
      I = bits[0][120-cycle];
      @(posedge clk);
      @(negedge clk);
    end

    enable = 0;
    I = 0;
    repeat (32) @(posedge clk);
    @(negedge clk) $finish;
  end
endmodule
