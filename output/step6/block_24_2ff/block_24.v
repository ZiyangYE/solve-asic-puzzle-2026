module block_24 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0150,
  output wire u0154
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0117, n0118;
  wire n0119, n0326, n0331, n0332, n0595;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0150 = n0118;
  assign u0154 = n0331;
  sky130_fd_sc_hd__and4bb u0190 (.X(n0117), .C(n0045), .D(n0043), .B_N(n0042), .A_N(n0046));  // x=113.620 y=284.240
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__a31o u0394 (.X(n0595), .A3(n0117), .A2(n0025), .A1(I), .B1(n0118));  // x=127.190 y=281.520
  sky130_fd_sc_hd__nand4 u0045 (.D(n0117), .C(n0118), .B(n0025), .A(I), .Y(n0119));  // x=114.080 y=278.800
  sky130_fd_sc_hd__o21a u0514 (.X(n0326), .B1(n0595), .A2(n0119), .A1(n0331));  // x=111.550 y=281.520
  sky130_fd_sc_hd__nand2b u0218 (.B(n0119), .Y(n0332), .A_N(n0331));  // x=110.170 y=278.800
  sky130_fd_sc_hd__dfrtp ff_u0150 (.RESET_B(rst_n), .Q(n0118), .CLK(clk), .D(n0326));  // x=121.210 y=278.800
  sky130_fd_sc_hd__dfrtp ff_u0154 (.RESET_B(rst_n), .Q(n0331), .CLK(clk), .D(n0332));  // x=118.910 y=273.360
endmodule
