module block_27 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0119,
  output wire u0151
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0131, n0132;
  wire n0133, n0277, n0278, n0327, n0594;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0119 = n0277;
  assign u0151 = n0132;
  sky130_fd_sc_hd__and4bb u0199 (.X(n0131), .C(n0045), .D(n0046), .B_N(n0042), .A_N(n0043));  // x=128.800 y=284.240
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand4 u0050 (.D(n0131), .C(n0132), .B(n0025), .A(I), .Y(n0133));  // x=110.860 y=286.960
  sky130_fd_sc_hd__nand2b u0233 (.B(n0133), .Y(n0278), .A_N(n0277));  // x=109.710 y=284.240
  sky130_fd_sc_hd__a31o u0393 (.X(n0594), .A3(n0131), .A2(n0025), .A1(I), .B1(n0132));  // x=128.110 y=286.960
  sky130_fd_sc_hd__o21a u0508 (.X(n0327), .B1(n0594), .A2(n0133), .A1(n0277));  // x=106.950 y=286.960
  sky130_fd_sc_hd__dfrtp ff_u0119 (.RESET_B(rst_n), .Q(n0277), .CLK(clk), .D(n0278));  // x=118.450 y=286.960
  sky130_fd_sc_hd__dfrtp ff_u0151 (.RESET_B(rst_n), .Q(n0132), .CLK(clk), .D(n0327));  // x=120.750 y=284.240
endmodule
