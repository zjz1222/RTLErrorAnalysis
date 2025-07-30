
module RefModule (
  input clk,
  input reset,
  output reg [9:0] q
);

  always @(posedge clk)
    if (reset || q == 999)
      q <= 0;
    else
      q <= q+1;

endmodule

/*
1. 对HDL特定领域编程的不了解导致，触发沿出错
2. design_description比较长，忽略了重要信息
*/