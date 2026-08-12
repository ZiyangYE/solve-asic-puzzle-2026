module block_01 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  output wire u0085,
  output wire u0086,
  output wire u0102,
  output wire u0115,
  output wire u0116,
  output wire u0127,
  output wire u0128,
  output wire u0293
);
  wire n0025, n0047, n0218, n0219, n0220, n0221, n0222, n0223;
  wire n0250, n0251, n0270, n0271, n0272, n0273, n0293, n0294;
  wire n0295, n0395, n0396, n0407, n0408, n0409, n0471, n0472;
  wire n0483, n0484, n0488, n0522, n0590, n0616, n0659;
  assign n0047 = u0077;
  assign u0085 = n0218;
  assign u0086 = n0220;
  assign u0102 = n0250;
  assign u0115 = n0270;
  assign u0116 = n0272;
  assign u0127 = n0222;
  assign u0128 = n0294;
  assign u0293 = n0223;
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__and3 u0444 (.A(n0218), .B(I), .C(n0025), .X(n0396));  // x=81.420 y=61.200
  sky130_fd_sc_hd__a21oi u0415 (.A1(I), .Y(n0616), .A2(n0025), .B1(n0218));  // x=79.350 y=55.760
  sky130_fd_sc_hd__nor2 u0669 (.A(n0396), .Y(n0219), .B(n0616));  // x=76.130 y=50.320
  sky130_fd_sc_hd__inv u0549 (.Y(n0488), .A(n0396));  // x=76.130 y=44.880
  sky130_fd_sc_hd__and2b u0272 (.A_N(n0220), .B(n0218), .X(n0471));  // x=85.790 y=53.040
  sky130_fd_sc_hd__a32o u0296 (.X(n0221), .B2(n0220), .A1(I), .A2(n0025), .B1(n0488), .A3(n0471));  // x=89.930 y=47.600
  sky130_fd_sc_hd__and2 u0554 (.A(n0223), .B(n0272), .X(n0407));  // x=69.920 y=44.880
  sky130_fd_sc_hd__and3 u0445 (.A(n0220), .B(n0222), .C(n0294), .X(n0408));  // x=92.920 y=50.320
  sky130_fd_sc_hd__and4 u0208 (.B(n0407), .C(n0396), .D(n0408), .X(n0409), .A(n0250));  // x=76.360 y=53.040
  sky130_fd_sc_hd__a31o u0396 (.X(n0472), .A3(n0408), .A2(n0396), .A1(n0407), .B1(n0250));  // x=72.910 y=53.040
  sky130_fd_sc_hd__and2b u0273 (.A_N(n0409), .B(n0472), .X(n0251));  // x=76.130 y=58.480
  sky130_fd_sc_hd__xor2 u0365 (.A(n0270), .B(n0409), .X(n0271));  // x=81.190 y=53.040
  sky130_fd_sc_hd__a31o u0389 (.X(n0590), .A3(n0408), .A2(n0396), .A1(n0223), .B1(n0272));  // x=72.910 y=50.320
  sky130_fd_sc_hd__nand2 u0607 (.Y(n0522), .B(n0408), .A(n0396));  // x=68.310 y=47.600
  sky130_fd_sc_hd__nand2 u0616 (.Y(n0659), .B(n0272), .A(n0223));  // x=76.130 y=39.440
  sky130_fd_sc_hd__o21a u0507 (.X(n0273), .B1(n0590), .A2(n0522), .A1(n0659));  // x=75.210 y=42.160
  sky130_fd_sc_hd__and3 u0458 (.A(n0220), .B(n0222), .C(n0396), .X(n0483));  // x=70.840 y=47.600
  sky130_fd_sc_hd__a21o u0185 (.X(n0395), .B1(n0222), .A1(n0220), .A2(n0396));  // x=93.610 y=47.600
  sky130_fd_sc_hd__and2b u0292 (.A_N(n0483), .B(n0395), .X(n0293));  // x=83.490 y=34.000
  sky130_fd_sc_hd__o21a u0524 (.X(n0295), .B1(n0522), .A2(n0483), .A1(n0294));  // x=72.910 y=44.880
  sky130_fd_sc_hd__xnor2 u0326 (.Y(n0484), .B(n0522), .A(n0223));  // x=79.810 y=44.880
  sky130_fd_sc_hd__dfrtp ff_u0085 (.RESET_B(rst_n), .Q(n0218), .CLK(clk), .D(n0219));  // x=85.790 y=55.760
  sky130_fd_sc_hd__dfrtp ff_u0086 (.RESET_B(rst_n), .Q(n0220), .CLK(clk), .D(n0221));  // x=85.790 y=39.440
  sky130_fd_sc_hd__dfrtp ff_u0102 (.RESET_B(rst_n), .Q(n0250), .CLK(clk), .D(n0251));  // x=80.730 y=47.600
  sky130_fd_sc_hd__dfrtp ff_u0115 (.RESET_B(rst_n), .Q(n0270), .CLK(clk), .D(n0271));  // x=82.570 y=58.480
  sky130_fd_sc_hd__dfrtp ff_u0116 (.RESET_B(rst_n), .Q(n0272), .CLK(clk), .D(n0273));  // x=81.650 y=42.160
  sky130_fd_sc_hd__dfrtp ff_u0127 (.RESET_B(rst_n), .Q(n0222), .CLK(clk), .D(n0293));  // x=87.630 y=44.880
  sky130_fd_sc_hd__dfrtp ff_u0128 (.RESET_B(rst_n), .Q(n0294), .CLK(clk), .D(n0295));  // x=86.710 y=50.320
  sky130_fd_sc_hd__dfrtp ff_u0293 (.RESET_B(rst_n), .Q(n0223), .CLK(clk), .D(n0484));  // x=82.570 y=36.720
endmodule
