
module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

reg [2:0] state, next_state;

parameter IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, STOP_BIT = 3'b011;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @* begin
    next_state = state;
    
    case(state)
        IDLE: begin
            if (in == 1'b0) begin
                next_state = START_BIT;
            end
        end
        
        START_BIT: begin
            next_state = DATA_BITS;
        end
        
        DATA_BITS: begin
            if (in == 1'b1) begin
                next_state = STOP_BIT;
            end
        end
        
        STOP_BIT: begin
            if (in == 1'b1) begin
                next_state = IDLE;
            end
        end
    endcase
end

assign done = (state == STOP_BIT);

endmodule
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob137_fsm_serial_test.sv:45: $finish called at 4526 (1ps)
Hint: Output 'done' has 236 mismatches. First mismatch occurred at time 120.
Hint: Total mismatched samples is 236 out of 905 samples

Simulation finished at 4526 ps
Mismatches: 236 in 905 samples

*/
/*
Insufficient Understanding of Circuit Concepts: FSM 
Insufficient Understanding of Circuit Concepts: Syn / Asyn
*/