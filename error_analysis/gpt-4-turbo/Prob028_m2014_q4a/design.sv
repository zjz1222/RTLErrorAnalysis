module TopModule (
  input d,
  input ena,
  output logic q
);
always @(ena, d) begin
    if (ena)
        q <= d;
end

endmodule
/*
Ambiguous design descriptions: Lack of Initialization
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./Execute_environment/testbench.sv:16: $finish called at 501 (1ps)
Hint: Output 'q' has 2 mismatches. First mismatch occurred at time 5.
Hint: Total mismatched samples is 2 out of 100 samples

Simulation finished at 501 ps
Mismatches: 2 in 100 samples
*/