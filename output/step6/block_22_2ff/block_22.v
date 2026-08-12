module block_22 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0076,
  output wire u0108
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0143, n0144;
  wire n0145, n0203, n0258, n0259, n0588;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0076 = n0144;
  assign u0108 = n0258;
  sky130_fd_sc_hd__and4bb u0196 (.X(n0143), .C(n0042), .D(n0046), .B_N(n0045), .A_N(n0043));  // x=122.820 y=254.320
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__a31o u0387 (.X(n0588), .A3(n0143), .A2(n0025), .A1(I), .B1(n0144));  // x=123.970 y=251.600
  sky130_fd_sc_hd__nand4 u0054 (.D(n0143), .C(n0144), .B(n0025), .A(I), .Y(n0145));  // x=118.220 y=254.320
  sky130_fd_sc_hd__o21a u0517 (.X(n0203), .B1(n0588), .A2(n0145), .A1(n0258));  // x=126.270 y=248.880
  sky130_fd_sc_hd__nand2b u0221 (.B(n0145), .Y(n0259), .A_N(n0258));  // x=114.770 y=246.160
  sky130_fd_sc_hd__dfrtp ff_u0076 (.RESET_B(rst_n), .Q(n0144), .CLK(clk), .D(n0203));  // x=121.210 y=246.160
  sky130_fd_sc_hd__dfrtp ff_u0108 (.RESET_B(rst_n), .Q(n0258), .CLK(clk), .D(n0259));  // x=118.910 y=243.440
endmodule
