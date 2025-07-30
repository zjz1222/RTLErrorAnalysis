
module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

reg [2:0] state, next_state;

parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @* begin
    case(state)
        WALK_LEFT: begin
            if (bump_right) begin
                next_state = WALK_RIGHT;
            end else if (ground && dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (ground && dig) begin
                next_state = DIGGING;
            end else if (!ground) begin
                next_state = FALLING;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = state;
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else begin
                next_state = state;
            end
        end
    endcase
end

assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob152_lemmings3_test.sv:94: $finish called at 2216 (1ps)
Hint: Output 'walk_left' has 80 mismatches. First mismatch occurred at time 190.
Hint: Output 'walk_right' has 80 mismatches. First mismatch occurred at time 240.
Hint: Output 'aaah' has 211 mismatches. First mismatch occurred at time 190.
Hint: Output 'digging' has 135 mismatches. First mismatch occurred at time 310.
Hint: Total mismatched samples is 253 out of 443 samples

Simulation finished at 2216 ps
Mismatches: 253 in 443 samples

*/
/*
/*
Missing Details of Long Descriptions
Insufficient Understanding of Circuit Concepts: FSM
*/
*/
/*
条件/状态设计错误
ground == 0 应该falling但是
ground == 0 and bump_right却walk left
*/