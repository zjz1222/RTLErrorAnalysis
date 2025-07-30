
module TopModule (
  input [99:0] in,
  output [98:0] out_both,
  output [99:1] out_any,
  output [99:0] out_different
);
        assign out_both[98:0] = in[99:1] & in[98:0];
        assign out_any[99:1] = in[99:1] | in[0:98];
        assign out_different[99] = in[99] ^ in[0];
        assign out_different[98:0] = in[98:0] ^ in[99:1];

endmodule
/*Status: Error compiling testbench

Fail Messages:The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./execute_environment/design.sv:9: error: part select in[0:98] is out of order.
1 error(s) during elaboration.

*/
/*
inverse vector-bit selection
*/