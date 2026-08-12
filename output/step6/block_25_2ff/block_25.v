module block_25 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0095,
  output wire u0120
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0109, n0237;
  wire n0238, n0279, n0280, n0375, n0528, n0529, n0530;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0095 = n0237;
  assign u0120 = n0279;
  sky130_fd_sc_hd__or4b u0039 (.C(n0042), .B(n0043), .A(n0046), .X(n0109), .D_N(n0045));  // x=115.460 y=270.640
  sky130_fd_sc_hd__inv u0539 (.Y(n0528), .A(n0237));  // x=115.230 y=281.520
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand2 u0580 (.Y(n0530), .B(n0025), .A(I));  // x=117.530 y=267.920
  sky130_fd_sc_hd__or4 u0331 (.C(n0109), .B(n0528), .A(n0279), .X(n0529), .D(n0530));  // x=112.470 y=273.360
  sky130_fd_sc_hd__nor2 u0667 (.A(n0109), .Y(n0375), .B(n0530));  // x=115.230 y=267.920
  sky130_fd_sc_hd__o21a u0512 (.X(n0238), .B1(n0529), .A2(n0375), .A1(n0237));  // x=118.910 y=270.640
  sky130_fd_sc_hd__a21o u0174 (.X(n0280), .B1(n0279), .A1(n0237), .A2(n0375));  // x=111.550 y=276.080
  sky130_fd_sc_hd__dfrtp ff_u0095 (.RESET_B(rst_n), .Q(n0237), .CLK(clk), .D(n0238));  // x=120.750 y=281.520
  sky130_fd_sc_hd__dfrtp ff_u0120 (.RESET_B(rst_n), .Q(n0279), .CLK(clk), .D(n0280));  // x=118.450 y=276.080
endmodule
