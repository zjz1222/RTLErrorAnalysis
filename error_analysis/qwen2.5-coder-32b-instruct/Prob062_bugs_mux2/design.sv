
module TopModule (
  input sel,
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] out
);
        assign out = (~sel & a) | (sel & b);
endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:47: $finish called at 570 (1ps)
Hint: Output 'out' has 85 mismatches. First mismatch occurred at time 20.
Hint: Total mismatched samples is 85 out of 114 samples

Simulation finished at 570 ps
Mismatches: 85 in 114 samples
*/
/*
Ambiguous Design Descriptions
*/