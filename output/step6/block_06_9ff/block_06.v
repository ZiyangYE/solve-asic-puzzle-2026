module block_06 (
  input wire clk,
  input wire rst_n,
  input wire enable,
  output wire u0077,
  output wire u0079,
  output wire u0081,
  output wire u0089,
  output wire u0118,
  output wire u0129,
  output wire u0141,
  output wire u0157,
  output wire u0158
);
  wire n0025, n0034, n0035, n0036, n0037, n0042, n0043, n0045;
  wire n0046, n0047, n0204, n0207, n0208, n0211, n0212, n0227;
  wire n0276, n0296, n0297, n0298, n0336, n0337, n0338, n0339;
  wire n0347, n0348, n0349, n0350, n0376, n0494, n0591, n0596;
  wire n0628, n0636;
  assign u0077 = n0047;
  assign u0079 = n0207;
  assign u0081 = n0211;
  assign u0089 = n0043;
  assign u0118 = n0042;
  assign u0129 = n0045;
  assign u0141 = n0046;
  assign u0157 = n0336;
  assign u0158 = n0338;
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand3b u0207 (.A_N(n0336), .C(n0207), .B(n0338), .Y(n0347));  // x=31.970 y=102.000
  sky130_fd_sc_hd__nor2 u0660 (.A(n0211), .Y(n0596), .B(n0347));  // x=31.050 y=93.840
  sky130_fd_sc_hd__and4bb u0200 (.X(n0037), .C(n0045), .D(n0046), .B_N(n0042), .A_N(n0043));  // x=25.760 y=153.680
  sky130_fd_sc_hd__a31o u0395 (.X(n0204), .A3(n0025), .A2(n0596), .A1(n0037), .B1(n0047));  // x=32.430 y=205.360
  sky130_fd_sc_hd__and4 u0206 (.B(n0025), .C(n0207), .D(n0211), .X(n0376), .A(n0037));  // x=28.060 y=102.000
  sky130_fd_sc_hd__inv u0533 (.Y(n0628), .A(n0376));  // x=34.270 y=107.440
  sky130_fd_sc_hd__a31o u0390 (.X(n0591), .A3(n0211), .A2(n0025), .A1(n0037), .B1(n0207));  // x=27.370 y=99.280
  sky130_fd_sc_hd__nand2 u0584 (.Y(n0348), .B(n0025), .A(n0037));  // x=39.790 y=99.280
  sky130_fd_sc_hd__o211a u0435 (.C1(n0628), .B1(n0591), .A2(n0348), .A1(n0347), .X(n0208));  // x=38.180 y=102.000
  sky130_fd_sc_hd__and3 u0453 (.A(n0037), .B(n0025), .C(n0347), .X(n0636));  // x=29.440 y=96.560
  sky130_fd_sc_hd__mux2 u0487 (.X(n0212), .A1(n0348), .A0(n0636), .S(n0211));  // x=38.410 y=96.560
  sky130_fd_sc_hd__xnor2 u0298 (.Y(n0494), .B(n0025), .A(n0043));  // x=31.050 y=153.680
  sky130_fd_sc_hd__nor2 u0638 (.A(n0037), .Y(n0227), .B(n0494));  // x=26.910 y=156.400
  sky130_fd_sc_hd__and3 u0442 (.A(n0046), .B(n0043), .C(n0025), .X(n0035));  // x=25.760 y=148.240
  sky130_fd_sc_hd__xor2 u0377 (.A(n0042), .B(n0035), .X(n0276));  // x=31.970 y=142.800
  sky130_fd_sc_hd__a41oi u0201 (.Y(n0297), .A4(n0025), .B1(n0045), .A1(n0046), .A2(n0043), .A3(n0042));  // x=31.050 y=156.400
  sky130_fd_sc_hd__and4 u0212 (.B(n0043), .C(n0042), .D(n0025), .X(n0298), .A(n0046));  // x=28.980 y=148.240
  sky130_fd_sc_hd__a221oi u0130 (.C1(n0297), .Y(n0296), .B2(n0045), .B1(n0298), .A2(n0037), .A1(n0025));  // x=31.740 y=161.840
  sky130_fd_sc_hd__a21oi u0422 (.A1(n0043), .Y(n0036), .A2(n0025), .B1(n0046));  // x=37.950 y=150.960
  sky130_fd_sc_hd__a211oi u0015 (.Y(n0034), .C1(n0035), .B1(n0036), .A1(n0025), .A2(n0037));  // x=36.340 y=153.680
  sky130_fd_sc_hd__xor2 u0378 (.A(n0336), .B(n0376), .X(n0337));  // x=30.130 y=104.720
  sky130_fd_sc_hd__nand3 u0176 (.Y(n0349), .A(n0336), .B(n0338), .C(n0376));  // x=31.740 y=107.440
  sky130_fd_sc_hd__a21o u0175 (.X(n0350), .B1(n0338), .A1(n0336), .A2(n0376));  // x=28.290 y=107.440
  sky130_fd_sc_hd__o311a u0162 (.X(n0339), .A1(n0211), .A2(n0347), .A3(n0348), .B1(n0349), .C1(n0350));  // x=32.890 y=96.560
  sky130_fd_sc_hd__dfrtp ff_u0077 (.RESET_B(rst_n), .Q(n0047), .CLK(clk), .D(n0204));  // x=34.730 y=202.640
  sky130_fd_sc_hd__dfrtp ff_u0079 (.RESET_B(rst_n), .Q(n0207), .CLK(clk), .D(n0208));  // x=37.950 y=104.720
  sky130_fd_sc_hd__dfrtp ff_u0081 (.RESET_B(rst_n), .Q(n0211), .CLK(clk), .D(n0212));  // x=37.030 y=93.840
  sky130_fd_sc_hd__dfrtp ff_u0089 (.RESET_B(rst_n), .Q(n0043), .CLK(clk), .D(n0227));  // x=31.050 y=150.960
  sky130_fd_sc_hd__dfrtp ff_u0118 (.RESET_B(rst_n), .Q(n0042), .CLK(clk), .D(n0276));  // x=31.050 y=145.520
  sky130_fd_sc_hd__dfrtp ff_u0129 (.RESET_B(rst_n), .Q(n0045), .CLK(clk), .D(n0296));  // x=33.810 y=159.120
  sky130_fd_sc_hd__dfrtp ff_u0141 (.RESET_B(rst_n), .Q(n0046), .CLK(clk), .D(n0034));  // x=35.650 y=148.240
  sky130_fd_sc_hd__dfrtp ff_u0157 (.RESET_B(rst_n), .Q(n0336), .CLK(clk), .D(n0337));  // x=33.810 y=110.160
  sky130_fd_sc_hd__dfrtp ff_u0158 (.RESET_B(rst_n), .Q(n0338), .CLK(clk), .D(n0339));  // x=33.810 y=99.280
endmodule
