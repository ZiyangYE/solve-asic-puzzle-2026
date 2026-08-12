module block_18 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0075,
  output wire u0094
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0107, n0201;
  wire n0202, n0235, n0236, n0363, n0547, n0548, n0549;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0075 = n0201;
  assign u0094 = n0235;
  sky130_fd_sc_hd__or4b u0037 (.C(n0042), .B(n0045), .A(n0043), .X(n0107), .D_N(n0046));  // x=114.080 y=208.080
  sky130_fd_sc_hd__inv u0535 (.Y(n0547), .A(n0201));  // x=109.710 y=216.240
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand2 u0603 (.Y(n0549), .B(n0025), .A(I));  // x=124.890 y=216.240
  sky130_fd_sc_hd__or4 u0339 (.C(n0107), .B(n0547), .A(n0235), .X(n0548), .D(n0549));  // x=124.430 y=213.520
  sky130_fd_sc_hd__nor2 u0654 (.A(n0107), .Y(n0363), .B(n0549));  // x=114.770 y=210.800
  sky130_fd_sc_hd__o21a u0516 (.X(n0202), .B1(n0548), .A2(n0363), .A1(n0201));  // x=111.550 y=210.800
  sky130_fd_sc_hd__a21o u0167 (.X(n0236), .B1(n0235), .A1(n0201), .A2(n0363));  // x=111.550 y=213.520
  sky130_fd_sc_hd__dfrtp ff_u0075 (.RESET_B(rst_n), .Q(n0201), .CLK(clk), .D(n0202));  // x=117.990 y=213.520
  sky130_fd_sc_hd__dfrtp ff_u0094 (.RESET_B(rst_n), .Q(n0235), .CLK(clk), .D(n0236));  // x=120.750 y=210.800
endmodule
