
module submodule (
  input clk,
  input L,
  input [2:0] r,
  output reg [2:0] q
);

  always @(posedge clk) begin
    if (L) begin
      q <= r;
    end else begin
      q <= {q[1] ^ q[2], q[0], q[2]};
    end
  end

endmodule

module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  wire [2:0] q1, q2, q3;

  submodule sub1 (.clk(clk), .L(L), .r(r_in), .q(q1));
  submodule sub2 (.clk(clk), .L(L), .r(q1), .q(q2));
  submodule sub3 (.clk(clk), .L(L), .r(q2), .q(q3));

  assign Q = q3[0];

endmodule
/*
Ambiguous Design Descriptions
*/
/*
The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob104_mt2015_muxdff_test.sv:128: syntax error
I give up.

*/
