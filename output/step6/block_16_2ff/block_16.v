module block_16 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0100,
  output wire u0145
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0113, n0148;
  wire n0149, n0246, n0247, n0319, n0609;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0100 = n0246;
  assign u0145 = n0148;
  sky130_fd_sc_hd__nor4 u0043 (.Y(n0113), .A(n0046), .B(n0043), .C(n0045), .D(n0042));  // x=118.220 y=194.480
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand4 u0057 (.D(n0113), .C(n0148), .B(n0025), .A(I), .Y(n0149));  // x=118.220 y=191.760
  sky130_fd_sc_hd__nand2b u0214 (.B(n0149), .Y(n0247), .A_N(n0246));  // x=114.770 y=186.320
  sky130_fd_sc_hd__a31o u0409 (.X(n0609), .A3(n0113), .A2(n0025), .A1(I), .B1(n0148));  // x=122.130 y=191.760
  sky130_fd_sc_hd__o21a u0510 (.X(n0319), .B1(n0609), .A2(n0149), .A1(n0246));  // x=120.750 y=189.040
  sky130_fd_sc_hd__dfrtp ff_u0100 (.RESET_B(rst_n), .Q(n0246), .CLK(clk), .D(n0247));  // x=118.910 y=183.600
  sky130_fd_sc_hd__dfrtp ff_u0145 (.RESET_B(rst_n), .Q(n0148), .CLK(clk), .D(n0319));  // x=121.210 y=186.320
endmodule
