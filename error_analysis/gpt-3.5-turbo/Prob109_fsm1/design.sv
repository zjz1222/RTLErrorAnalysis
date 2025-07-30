
module TopModule (
  input clk,
  input in,
  input areset,
  output out
);

  reg [1:0] state, next_state;

  parameter A = 2'b00;
  parameter B = 2'b01;

  always @(*) begin
    case(state)
      A: begin
        if(in)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        if(in)
          next_state = B;
        else
          next_state = A;
      end
    endcase
  end

  always @(posedge clk or posedge areset) begin
    if(areset)
      state <= B;
    else
      state <= next_state;
  end

  assign out = state[1];

endmodule
/*
Vector Bit Selection Error
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset doesn't seem to be working.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob109_fsm1_test.sv:71: $finish called at 1141 (1ps)
Hint: Output 'out' has 134 mismatches. First mismatch occurred at time 5.
Hint: Total mismatched samples is 134 out of 228 samples

Simulation finished at 1141 ps
Mismatches: 134 in 228 samples
*/