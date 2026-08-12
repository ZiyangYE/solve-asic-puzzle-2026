module block_13 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0101
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0169, n0170;
  wire n0171, n0172, n0173, n0209, n0210, n0213, n0214, n0225;
  wire n0226, n0239, n0240, n0248, n0249, n0253, n0254, n0261;
  wire n0262, n0263, n0264, n0265, n0266, n0310, n0311, n0312;
  wire n0313, n0314, n0315, n0446, n0447;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0101 = n0248;
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__mux2 u0483 (.X(n0210), .A1(I), .A0(n0209), .S(n0025));  // x=89.930 y=156.400
  sky130_fd_sc_hd__mux2 u0470 (.X(n0214), .A1(n0265), .A0(n0213), .S(n0025));  // x=79.810 y=137.360
  sky130_fd_sc_hd__mux2 u0482 (.X(n0226), .A1(n0261), .A0(n0225), .S(n0025));  // x=72.450 y=145.520
  sky130_fd_sc_hd__mux2 u0491 (.X(n0240), .A1(n0263), .A0(n0239), .S(n0025));  // x=77.970 y=153.680
  sky130_fd_sc_hd__or4 u0332 (.C(n0042), .B(n0046), .A(n0043), .X(n0447), .D(n0045));  // x=80.270 y=107.440
  sky130_fd_sc_hd__buf u0478 (.X(n0446), .A(n0447));  // x=86.020 y=102.000
  sky130_fd_sc_hd__a22o u0247 (.B2(n0312), .B1(n0446), .A1(n0447), .A2(n0209), .X(n0169));  // x=85.100 y=161.840
  sky130_fd_sc_hd__or4bb u0257 (.X(n0171), .C_N(n0045), .D_N(n0046), .A(n0043), .B(n0042));  // x=83.260 y=104.720
  sky130_fd_sc_hd__a221o u0066 (.C1(n0169), .B2(n0170), .B1(1'b1), .A1(n0171), .A2(n0172), .X(n0173));  // x=70.610 y=150.960
  sky130_fd_sc_hd__a31o u0398 (.X(n0249), .A3(n0173), .A2(n0025), .A1(I), .B1(n0248));  // x=72.450 y=156.400
  sky130_fd_sc_hd__mux2 u0490 (.X(n0254), .A1(n0209), .A0(n0253), .S(n0025));  // x=79.810 y=159.120
  sky130_fd_sc_hd__mux2 u0475 (.X(n0262), .A1(n0239), .A0(n0261), .S(n0025));  // x=71.530 y=148.240
  sky130_fd_sc_hd__mux2 u0484 (.X(n0264), .A1(n0314), .A0(n0263), .S(n0025));  // x=77.050 y=161.840
  sky130_fd_sc_hd__mux2 u0476 (.X(n0266), .A1(n0225), .A0(n0265), .S(n0025));  // x=72.450 y=142.800
  sky130_fd_sc_hd__mux2 u0471 (.X(n0310), .A1(n0213), .A0(n0172), .S(n0025));  // x=80.730 y=142.800
  sky130_fd_sc_hd__mux2 u0479 (.X(n0311), .A1(n0172), .A0(n0170), .S(n0025));  // x=89.930 y=145.520
  sky130_fd_sc_hd__mux2 u0474 (.X(n0313), .A1(n0170), .A0(n0312), .S(n0025));  // x=82.110 y=153.680
  sky130_fd_sc_hd__mux2 u0480 (.X(n0315), .A1(n0253), .A0(n0314), .S(n0025));  // x=81.190 y=161.840
  sky130_fd_sc_hd__dfrtp ff_u0080 (.RESET_B(rst_n), .Q(n0209), .CLK(clk), .D(n0210));  // x=86.710 y=159.120
  sky130_fd_sc_hd__dfrtp ff_u0082 (.RESET_B(rst_n), .Q(n0213), .CLK(clk), .D(n0214));  // x=86.710 y=137.360
  sky130_fd_sc_hd__dfrtp ff_u0088 (.RESET_B(rst_n), .Q(n0225), .CLK(clk), .D(n0226));  // x=80.270 y=148.240
  sky130_fd_sc_hd__dfrtp ff_u0096 (.RESET_B(rst_n), .Q(n0239), .CLK(clk), .D(n0240));  // x=79.810 y=145.520
  sky130_fd_sc_hd__dfrtp ff_u0101 (.RESET_B(rst_n), .Q(n0248), .CLK(clk), .D(n0249));  // x=92.690 y=150.960
  sky130_fd_sc_hd__dfrtp ff_u0104 (.RESET_B(rst_n), .Q(n0253), .CLK(clk), .D(n0254));  // x=82.570 y=156.400
  sky130_fd_sc_hd__dfrtp ff_u0110 (.RESET_B(rst_n), .Q(n0261), .CLK(clk), .D(n0262));  // x=81.650 y=140.080
  sky130_fd_sc_hd__dfrtp ff_u0111 (.RESET_B(rst_n), .Q(n0263), .CLK(clk), .D(n0264));  // x=82.570 y=150.960
  sky130_fd_sc_hd__dfrtp ff_u0112 (.RESET_B(rst_n), .Q(n0265), .CLK(clk), .D(n0266));  // x=82.570 y=134.640
  sky130_fd_sc_hd__dfrtp ff_u0138 (.RESET_B(rst_n), .Q(n0172), .CLK(clk), .D(n0310));  // x=87.630 y=142.800
  sky130_fd_sc_hd__dfrtp ff_u0139 (.RESET_B(rst_n), .Q(n0170), .CLK(clk), .D(n0311));  // x=89.930 y=148.240
  sky130_fd_sc_hd__dfrtp ff_u0140 (.RESET_B(rst_n), .Q(n0312), .CLK(clk), .D(n0313));  // x=89.010 y=153.680
  sky130_fd_sc_hd__dfrtp ff_u0142 (.RESET_B(rst_n), .Q(n0314), .CLK(clk), .D(n0315));  // x=81.650 y=164.560
endmodule
