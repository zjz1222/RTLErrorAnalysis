
module TopModule (
  input clk,
  input reset,
  input data,
  output reg shift_ena,
  output reg counting,
  input done_counting,
  output reg done,
  input ack
);

reg [3:0] state;

parameter IDLE = 2'b00;
parameter DETECT_PATTERN = 2'b01;
parameter SHIFT_IN = 2'b10;
parameter WAIT_COUNTING = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 4'b1101) begin
                    state <= DETECT_PATTERN;
                end
            end
            DETECT_PATTERN: begin
                shift_ena <= 1;
                state <= SHIFT_IN;
            end
            SHIFT_IN: begin
                shift_ena <= 0;
                counting <= 1;
                state <= WAIT_COUNTING;
            end
            WAIT_COUNTING: begin
                if (done_counting) begin
                    done <= 1;
                    state <= done & ~ack ? WAIT_COUNTING : IDLE;
                end
            end
        endcase
    end
end

endmodule
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your FSM didn't pass the sample timing diagram posted with the problem statement. Perhaps try debugging that?
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob151_review2015_fsm_test.sv:76: $finish called at 25346 (1ps)
Hint: Output 'shift_ena' has 256 mismatches. First mismatch occurred at time 90.
Hint: Output 'counting' has 1872 mismatches. First mismatch occurred at time 130.
Hint: Output 'done' has 2024 mismatches. First mismatch occurred at time 180.
Hint: Total mismatched samples is 4152 out of 5069 samples

Simulation finished at 25346 ps
Mismatches: 4152 in 5069 samples

*/
/*
Missing Details of Long Descriptions
Insufficient Understanding of Circuit Concepts: Syn / Asyn
Insufficient Understanding of Circuit Concepts: FSM
*/
