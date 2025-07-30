module TopModule (
  input clk,
  input reset,
  output reg [9:0] q
);

  always @(posedge clk or posedge reset) 
  begin
    if (reset) begin
      q <= 10'b0;
    end else begin
      if (q == 10'd999) begin
        q <= 10'b0;
      end else begin
        q <= q + 1;
      end
    end
  end
endmodule
/*
Insufficient Understanding of Circuit Concepts: Syn / Asyn
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset should be synchronous, but doesn't appear to be.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob037_review2015_count1k_test.sv:71: $finish called at 40136 (1ps)
Hint: Output 'q' has 834 mismatches. First mismatch occurred at time 55.
Hint: Total mismatched samples is 834 out of 8027 samples

Simulation finished at 40136 ps
Mismatches: 834 in 8027 samples

*/
