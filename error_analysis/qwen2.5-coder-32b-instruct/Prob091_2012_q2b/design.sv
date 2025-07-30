
module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);
        assign Y1 = (y[0] & ~w) | (y[1] & ~w) | (y[2] & w) | (y[4] & ~w);
        assign Y3 = (y[1] & w) | (y[2] & ~w) | (y[3] & w) | (y[4] & w) | (y[5] & w);

endmodule
/*Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:45: $finish called at 3001 (1ps)
Hint: Output 'Y1' has 349 mismatches. First mismatch occurred at time 10.
Hint: Output 'Y3' has 370 mismatches. First mismatch occurred at time 15.
Hint: Total mismatched samples is 528 out of 600 samples

Simulation finished at 3001 ps
Mismatches: 528 in 600 samples

*/
/*
Misinterpretation of Multimodal Data: State Transition Diagram
Vector Bit Process
*/