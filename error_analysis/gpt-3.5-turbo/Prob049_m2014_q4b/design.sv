
module TopModule (
  input clk,
  input d,
  input ar,
  output logic q
);

  always_ff @(posedge clk or negedge ar)
  begin
    if (!ar)
      q <= 1'b0;
    else
      q <= d;
  end
endmodule

/*
Insufficient Understanding of Circuit Concepts: Syn/Asyn
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob049_m2014_q4b_test.sv:16: $finish called at 501 (1ps)
Hint: Output 'q' has 20 mismatches. First mismatch occurred at time 30.
Hint: Total mismatched samples is 20 out of 100 samples

Simulation finished at 501 ps
Mismatches: 20 in 100 samples

*/