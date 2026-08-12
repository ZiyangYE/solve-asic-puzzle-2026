`timescale 1ns/1ps

module step9_tb;
  reg clk = 0;
  reg rst_n = 0;
  reg enable = 0;
  reg I = 0;
  wire success;
  wire [7:0] out;
  reg [120:0] bits [0:0];
  reg [1023:0] pattern_file;
  reg [1023:0] message_file;
  integer message;
  integer cycle;
  integer unused;

  puzzle dut (clk, rst_n, enable, I, success, out);
  always #5 clk = ~clk;

  initial begin
    unused = $value$plusargs("PATTERN=%s", pattern_file);
    unused = $value$plusargs("MESSAGE=%s", message_file);
    $readmemb(pattern_file, bits);
    message = $fopen(message_file, "w");

    repeat (2) @(posedge clk);
    @(negedge clk) rst_n = 1;

    for (cycle = 0; cycle < 121; cycle = cycle + 1) begin
      enable = 1;
      I = bits[0][120-cycle];
      @(posedge clk);
      @(negedge clk);
    end

    I = 0;
    for (cycle = 0; cycle < 64; cycle = cycle + 1) begin
      @(posedge clk);
      @(negedge clk);
      $fdisplay(message, "%02x", out);
      if (out == 0) begin
        $fclose(message);
        $finish;
      end
    end
    $fclose(message);
    $finish;
  end
endmodule
