module block_07 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0143
);
  wire n0025, n0037, n0042, n0043, n0045, n0046, n0047, n0299;
  wire n0300, n0305, n0306, n0316, n0317, n0459, n0460, n0461;
  wire n0599, n0612, n0613, n0614, n0630;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0143 = n0316;
  sky130_fd_sc_hd__and4bb u0200 (.X(n0037), .C(n0045), .D(n0046), .B_N(n0042), .A_N(n0043));  // x=25.760 y=153.680
  sky130_fd_sc_hd__inv u0541 (.Y(n0459), .A(n0037));  // x=79.350 y=96.560
  //sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  //n0025 is true under condition
  
  sky130_fd_sc_hd__or2 u0624 (.X(n0630), .B(I), .A(n0299));  // x=82.110 y=112.880
  sky130_fd_sc_hd__nand2 u0609 (.Y(n0613), .B(I), .A(n0299));  // x=77.510 y=110.160
  
  //sky130_fd_sc_hd__o211a u0437 (.C1(n0025), .B1(n0630), .A2(n0613), .A1(n0305), .X(n0460));  // x=83.720 y=107.440
  sky130_fd_sc_hd__o211a u0437 (.C1(1'b1), .B1(n0630), .A2(n0613), .A1(n0305), .X(n0460));  // x=83.720 y=107.440
  
  //sky130_fd_sc_hd__inv u0546 (.Y(n0461), .A(n0025));  // x=76.590 y=104.720
  //n0461 is false
  
  //sky130_fd_sc_hd__a22o u0256 (.B2(n0459), .B1(n0460), .A1(n0461), .A2(n0299), .X(n0300));  // x=79.120 y=104.720
  sky130_fd_sc_hd__a22o u0256 (.B2(n0459), .B1(n0460), .A1(1'b0), .A2(n0299), .X(n0300));  // x=79.120 y=104.720
  
  sky130_fd_sc_hd__inv u0543 (.Y(n0612), .A(n0305));  // x=88.550 y=102.000
  //sky130_fd_sc_hd__mux2 u0481 (.X(n0614), .A1(n0612), .A0(n0037), .S(n0461));  // x=78.890 y=102.000
  //n0614 = n0037
  
  //sky130_fd_sc_hd__a21oi u0413 (.A1(n0612), .Y(n0306), .A2(n0613), .B1(n0614));  // x=80.270 y=99.280
  sky130_fd_sc_hd__a21oi u0413 (.A1(n0612), .Y(n0306), .A2(n0613), .B1(n0037));  // x=80.270 y=99.280

  sky130_fd_sc_hd__mux2 u0477 (.X(n0599), .A1(n0630), .A0(n0613), .S(n0305));  // x=83.030 y=102.000
  sky130_fd_sc_hd__a31o u0400 (.X(n0317), .A3(n0599), .A2(n0025), .A1(n0037), .B1(n0316));  // x=81.650 y=96.560
  sky130_fd_sc_hd__dfrtp ff_u0132 (.RESET_B(rst_n), .Q(n0299), .CLK(clk), .D(n0300));  // x=83.950 y=110.160
  sky130_fd_sc_hd__dfrtp ff_u0135 (.RESET_B(rst_n), .Q(n0305), .CLK(clk), .D(n0306));  // x=86.710 y=99.280
  sky130_fd_sc_hd__dfrtp ff_u0143 (.RESET_B(rst_n), .Q(n0316), .CLK(clk), .D(n0317));  // x=85.790 y=93.840
endmodule

//simplified

  sky130_fd_sc_hd__and4bb u0200 (.X(n0037), .C(n0045), .D(n0046), .B_N(n0042), .A_N(n0043));  // x=25.760 y=153.680
  //n0037 is true when counter == 6
  sky130_fd_sc_hd__inv u0541 (.Y(n0459), .A(n0037));  // x=79.350 y=96.560

  sky130_fd_sc_hd__or2 u0624 (.X(n0630), .B(I), .A(n0299));  // x=82.110 y=112.880
  // i or n299
  sky130_fd_sc_hd__nand2 u0609 (.Y(n0613), .B(I), .A(n0299));  // x=77.510 y=110.160
  // i nand n299
  
  sky130_fd_sc_hd__a22o u0256 (.B2(n0459), .B1(n0460), .A1(1'b0), .A2(n0299), .X(n0300));  // x=79.120 y=104.720
  //counter = 6 -> false, otherwise n0460

  sky130_fd_sc_hd__o211a u0437 (.C1(1'b1), .B1(n0630), .A2(n0613), .A1(n0305), .X(n0460));  // x=83.720 y=107.440

  sky130_fd_sc_hd__dfrtp ff_u0132 (.RESET_B(rst_n), .Q(n0299), .CLK(clk), .D(n0300));  // x=83.950 y=110.160
  //counter = 6 -> reset
  
  sky130_fd_sc_hd__inv u0543 (.Y(n0612), .A(n0305));  // x=88.550 y=102.000
  sky130_fd_sc_hd__a21oi u0413 (.A1(n0612), .Y(n0306), .A2(n0613), .B1(n0037));  // x=80.270 y=99.280
  sky130_fd_sc_hd__dfrtp ff_u0135 (.RESET_B(rst_n), .Q(n0305), .CLK(clk), .D(n0306));  // x=86.710 y=99.280
  

  sky130_fd_sc_hd__mux2 u0477 (.X(n0599), .A1(n0630), .A0(n0613), .S(n0305));  // x=83.030 y=102.000
  sky130_fd_sc_hd__a31o u0400 (.X(n0317), .A3(n0599), .A2(1'b1), .A1(n0037), .B1(n0316));  // x=81.650 y=96.560
  sky130_fd_sc_hd__dfrtp ff_u0143 (.RESET_B(rst_n), .Q(n0316), .CLK(clk), .D(n0317));  // x=85.790 y=93.840