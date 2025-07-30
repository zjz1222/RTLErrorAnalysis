
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
    reg [3:0] state;
    reg [4:0] fall_timer;
    parameter IDLE = 4'b0000,
              WALK_LEFT = 4'b0001,
              WALK_RIGHT = 4'b0010,
              FALLING = 4'b0100,
              DIGGING_LEFT = 4'b1000,
              DIGGING_RIGHT = 4'b1001,
              SPLATTERED = 4'b1111;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 5'b00000;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_timer <= 5'b00001;
                    end else if (dig) begin
                        state <= DIGGING_LEFT;
                    end else if (bump_left || (bump_left && bump_right)) begin
                        state <= WALK_RIGHT;
                    end
                end
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_timer <= 5'b00001;
                    end else if (dig) begin
                        state <= DIGGING_RIGHT;
                    end else if (bump_right || (bump_left && bump_right)) begin
                        state <= WALK_LEFT;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        if (fall_timer > 5'd20) begin
                            state <= SPLATTERED;
                        end else begin
                            if (state == WALK_LEFT) begin
                                state <= WALK_LEFT;
                            end else begin
                                state <= WALK_RIGHT;
                            end
                        end
                        fall_timer <= 5'b00000;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                DIGGING_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_timer <= 5'b00001;
                    end
                end
                DIGGING_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_timer <= 5'b00001;
                    end
                end
                SPLATTERED: begin
                    // Stay in splattered state
                end
                default: begin
                    state <= WALK_LEFT;
                end
            endcase
        end
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING_LEFT || state == DIGGING_RIGHT);

endmodule
/*
Insufficient Understanding of Circuit Concepts: FSM
Missing Details of Long Descriptions
*/
/*Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:158: $finish called at 5016 (1ps)
Hint: Output 'walk_left' has 45 mismatches. First mismatch occurred at time 110.
Hint: Output 'walk_right' has 83 mismatches. First mismatch occurred at time 110.
Hint: Output 'aaah' has 10 mismatches. First mismatch occurred at time 1960.
Hint: Output 'digging' has 16 mismatches. First mismatch occurred at time 1950.
Hint: Total mismatched samples is 117 out of 1003 samples

Simulation finished at 5016 ps
Mismatches: 117 in 1003 samples

*/