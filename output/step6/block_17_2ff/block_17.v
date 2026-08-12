module block_17 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0125,
  output wire u0148
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0108, n0289;
  wire n0290, n0323, n0324, n0364, n0540, n0541, n0542;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0125 = n0289;
  assign u0148 = n0323;
  sky130_fd_sc_hd__or4b u0038 (.C(n0042), .B(n0045), .A(n0046), .X(n0108), .D_N(n0043));  // x=115.460 y=199.920
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand2 u0602 (.Y(n0542), .B(n0025), .A(I));  // x=118.450 y=199.920
  sky130_fd_sc_hd__nor2 u0650 (.A(n0108), .Y(n0364), .B(n0542));  // x=112.010 y=199.920
  sky130_fd_sc_hd__a21o u0168 (.X(n0290), .B1(n0289), .A1(n0323), .A2(n0364));  // x=118.910 y=202.640
  sky130_fd_sc_hd__inv u0538 (.Y(n0540), .A(n0323));  // x=109.250 y=210.800
  sky130_fd_sc_hd__or4 u0336 (.C(n0108), .B(n0540), .A(n0289), .X(n0541), .D(n0542));  // x=115.690 y=202.640
  sky130_fd_sc_hd__o21a u0494 (.X(n0324), .B1(n0541), .A2(n0364), .A1(n0323));  // x=111.550 y=202.640
  sky130_fd_sc_hd__dfrtp ff_u0125 (.RESET_B(rst_n), .Q(n0289), .CLK(clk), .D(n0290));  // x=118.450 y=205.360
  sky130_fd_sc_hd__dfrtp ff_u0148 (.RESET_B(rst_n), .Q(n0323), .CLK(clk), .D(n0324));  // x=120.750 y=208.080
endmodule
