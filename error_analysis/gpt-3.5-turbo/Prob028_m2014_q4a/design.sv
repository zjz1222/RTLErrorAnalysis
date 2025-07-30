
module TopModule (
  input d, ena,
  output logic q
);
  always @(posedge ena) begin
    if (ena)
      q <= d;
  end
endmodule

/*
Ambiguous Design Description: Lack of initialisation
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob028_m2014_q4a_test.sv:16: $finish called at 501 (1ps)
Hint: Output 'q' has 42 mismatches. First mismatch occurred at time 5.
Hint: Total mismatched samples is 42 out of 100 samples

Simulation finished at 501 ps
Mismatches: 42 in 100 samples

*/
