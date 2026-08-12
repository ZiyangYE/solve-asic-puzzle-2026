module block_20 (
  input wire clk,
  input wire rst_n,
  input wire I,
  input wire enable,
  input wire u0077,
  input wire u0089,
  input wire u0118,
  input wire u0129,
  input wire u0141,
  output wire u0091,
  output wire u0147
);
  wire n0025, n0042, n0043, n0045, n0046, n0047, n0110, n0230;
  wire n0231, n0321, n0322, n0377, n0531, n0532, n0533;
  assign n0047 = u0077;
  assign n0043 = u0089;
  assign n0042 = u0118;
  assign n0045 = u0129;
  assign n0046 = u0141;
  assign u0091 = n0230;
  assign u0147 = n0321;
  sky130_fd_sc_hd__or4b u0040 (.C(n0045), .B(n0043), .A(n0046), .X(n0110), .D_N(n0042));  // x=118.680 y=227.120
  sky130_fd_sc_hd__inv u0528 (.Y(n0531), .A(n0230));  // x=108.330 y=235.280
  sky130_fd_sc_hd__and2b u0285 (.A_N(n0047), .B(enable), .X(n0025));  // x=31.510 y=199.920
  sky130_fd_sc_hd__nand2 u0581 (.Y(n0533), .B(n0025), .A(I));  // x=124.890 y=235.280
  sky130_fd_sc_hd__or4 u0333 (.C(n0110), .B(n0531), .A(n0321), .X(n0532), .D(n0533));  // x=124.890 y=232.560
  sky130_fd_sc_hd__nor2 u0635 (.A(n0110), .Y(n0377), .B(n0533));  // x=122.590 y=235.280
  sky130_fd_sc_hd__o21a u0498 (.X(n0231), .B1(n0532), .A2(n0377), .A1(n0230));  // x=114.310 y=229.840
  sky130_fd_sc_hd__a21o u0177 (.X(n0322), .B1(n0321), .A1(n0230), .A2(n0377));  // x=111.550 y=232.560
  sky130_fd_sc_hd__dfrtp ff_u0091 (.RESET_B(rst_n), .Q(n0230), .CLK(clk), .D(n0231));  // x=118.450 y=232.560
  sky130_fd_sc_hd__dfrtp ff_u0147 (.RESET_B(rst_n), .Q(n0321), .CLK(clk), .D(n0322));  // x=120.750 y=229.840
endmodule
