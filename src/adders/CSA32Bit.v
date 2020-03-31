module CSelA32(output [31:0] sum, output cout, input [31:0] a, b);

  wire [31:0] sum0, sum1;
  wire [7:1] c;
  wire [7:0] cout0, cout1;

  RCA4 rca0_0(sum0[3:0], cout0[0], a[3:0], b[3:0], 0);
  RCA4 rca0_1(sum1[3:0], cout1[0], a[3:0], b[3:0], 1);
  MUX2to1_w4 mux0_sum(sum[3:0], sum0[3:0], sum1[3:0], 0);
  MUX2to1_w1 mux0_cout(c[1], cout0[0], cout1[0], 0);

  RCA4 rca_other_0[6:1](sum0[27:4], cout0[6:1], a[27:4], b[27:4], 1'b0);
  RCA4 rca_other_1[6:1](sum1[27:4], cout1[6:1], a[27:4], b[27:4], 1'b1);
  MUX2to1_w4 mux_other_sum[6:1](sum[27:4], sum0[27:4], sum1[27:4], c[6:1]);
  MUX2to1_w1 mux_other_cout[6:1](c[7:2], cout0[6:1], cout1[6:1], c[6:1]);

  RCA4 rca_last_0(sum0[31:28], cout0[7], a[31:28], b[31:28], 0);
  RCA4 rca_last_1(sum1[31:28], cout1[7], a[31:28], b[31:28], 1);
  MUX2to1_w4 mux_last_sum(sum[31:28], sum0[31:28], sum1[31:28], c[7]);
  MUX2to1_w1 mux_last_cout(cout, cout0[7], cout1[7], c[7]);

endmodule