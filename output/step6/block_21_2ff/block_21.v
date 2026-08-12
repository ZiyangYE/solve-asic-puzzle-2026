module block_21 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0113,
  output wire u0146
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0114, n0115;
  wire n0116, n0267, n0268, n0320, n0597;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0113 = n0267;
  assign u0146 = n0115;
  sky130_fd_sc_hd__and4bb u0204 (.X(n0114), .C(n0042), .D(n0043), .B_N(n0045), .A_N(n0046));  // x=119.140 y=235.280
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand4 u0044 (.D(n0114), .C(n0115), .B(n0025), .A(I), .Y(n0116));  // x=114.540 y=235.280
  sky130_fd_sc_hd__nand2b u0232 (.B(n0116), .Y(n0268), .A_N(n0267));  // x=110.630 y=235.280
  sky130_fd_sc_hd__a31o u0397 (.X(n0597), .A3(n0114), .A2(n0025), .A1(I), .B1(n0115));  // x=124.890 y=238.000
  sky130_fd_sc_hd__o21a u0497 (.X(n0320), .B1(n0597), .A2(n0116), .A1(n0267));  // x=114.310 y=240.720
  sky130_fd_sc_hd__dfrtp ff_u0113 (.RESET_B(rst_n), .Q(n0267), .CLK(clk), .D(n0268));  // x=118.450 y=238.000
  sky130_fd_sc_hd__dfrtp ff_u0146 (.RESET_B(rst_n), .Q(n0115), .CLK(clk), .D(n0320));  // x=120.750 y=240.720
endmodule
