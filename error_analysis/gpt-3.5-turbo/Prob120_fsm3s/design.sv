
module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

  reg [1:0] state, next_state;
  reg out;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // State A
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      2'b00: begin // State A
        if (in) begin
          next_state = 2'b01; // Next state B
        end else begin
          next_state = 2'b00; // Next state A
        end
        out = 1'b0;
      end
      2'b01: begin // State B
        if (in) begin
          next_state = 2'b01; // Next state B
        end else begin
          next_state = 2'b10; // Next state C
        end
        out = 1'b0;
      end
      2'b10: begin // State C
        if (in) begin
          next_state = 2'b11; // Next state D
        end else begin
          next_state = 2'b00; // Next state A
        end
        out = 1'b0;
      end
      2'b11: begin // State D
        if (in) begin
          next_state = 2'b01; // Next state B
        end else begin
          next_state = 2'b10; // Next state C
        end
        out = 1'b1;
      end
    endcase
  end

endmodule
/*
Insufficient Understanding of Circuit Concepts: Syn / Asyn
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob120_fsm3s_test.sv:77: $finish called at 1151 (1ps)
Hint: Output 'out' has 3 mismatches. First mismatch occurred at time 65.
Hint: Total mismatched samples is 3 out of 230 samples

Simulation finished at 1151 ps
Mismatches: 3 in 230 samples

*/
/*
Flawed Sensitivity List 
*/