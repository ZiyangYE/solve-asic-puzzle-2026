module block_19 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0098,
  output wire u0160
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0134, n0135;
  wire n0136, n0243, n0244, n0342, n0598;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0098 = n0243;
  assign u0160 = n0135;
  sky130_fd_sc_hd__and4bb u0191 (.X(n0134), .C(n0043), .D(n0046), .B_N(n0042), .A_N(n0045));  // x=118.220 y=224.400
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand4 u0051 (.D(n0134), .C(n0135), .B(n0025), .A(I), .Y(n0136));  // x=118.220 y=221.680
  sky130_fd_sc_hd__nand2b u0219 (.B(n0136), .Y(n0244), .A_N(n0243));  // x=111.550 y=218.960
  sky130_fd_sc_hd__a31o u0399 (.X(n0598), .A3(n0134), .A2(n0025), .A1(I), .B1(n0135));  // x=122.130 y=221.680
  sky130_fd_sc_hd__o21a u0495 (.X(n0342), .B1(n0598), .A2(n0136), .A1(n0243));  // x=114.310 y=224.400
  sky130_fd_sc_hd__dfrtp ff_u0098 (.RESET_B(rst_n), .Q(n0243), .CLK(clk), .D(n0244));  // x=118.910 y=216.240
  sky130_fd_sc_hd__dfrtp ff_u0160 (.RESET_B(rst_n), .Q(n0135), .CLK(clk), .D(n0342));  // x=121.210 y=218.960
endmodule
