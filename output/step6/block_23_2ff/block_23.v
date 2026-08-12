module block_23 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0106,
  output wire u0149
);
  wire n0025, n0042, n0043, n0044, n0045, n0046, n0047, n0120;
  wire n0121, n0255, n0256, n0325, n0607;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0106 = n0255;
  assign u0149 = n0120;
  sky130_fd_sc_hd__and4b u0017 (.B(n0042), .C(n0043), .X(n0044), .A_N(n0045), .D(n0046));  // x=127.190 y=254.320
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand4 u0046 (.D(n0044), .C(n0120), .B(n0025), .A(I), .Y(n0121));  // x=113.620 y=257.040
  sky130_fd_sc_hd__nand2b u0216 (.B(n0121), .Y(n0256), .A_N(n0255));  // x=115.690 y=262.480
  sky130_fd_sc_hd__a31o u0406 (.X(n0607), .A3(n0044), .A2(n0025), .A1(I), .B1(n0120));  // x=118.910 y=262.480
  sky130_fd_sc_hd__o21a u0521 (.X(n0325), .B1(n0607), .A2(n0121), .A1(n0255));  // x=109.710 y=257.040
  sky130_fd_sc_hd__dfrtp ff_u0106 (.RESET_B(rst_n), .Q(n0255), .CLK(clk), .D(n0256));  // x=118.450 y=259.760
  sky130_fd_sc_hd__dfrtp ff_u0149 (.RESET_B(rst_n), .Q(n0120), .CLK(clk), .D(n0325));  // x=120.750 y=257.040
endmodule
