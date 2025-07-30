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
    // State Encoding
    localparam WALK_LEFT = 3'd0,
               WALK_RIGHT = 3'd1,
               FALLING = 3'd2,
               DIGGING = 3'd3,
               SPLATTER = 3'd4;

    // Registers to hold state and fall count
    reg [2:0] state, next_state;
    reg [5:0] fall_count; // Enough to count up to 20+

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == FALLING)
                fall_count <= fall_count + 1;
            else
                fall_count <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground && fall_count > 20)
                    next_state = SPLATTER;
                else if (ground)
                    next_state = (fall_count > 20) ? SPLATTER : (next_state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT);
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (!ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

endmodule
/*
Insufficient Understanding of Circuit Concepts: FSM
Missing Details of Long Descriptions
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./Execute_environment/testbench.sv:158: $finish called at 5016 (1ps)
Hint: Output 'walk_left' has 45 mismatches. First mismatch occurred at time 110.
Hint: Output 'walk_right' has 95 mismatches. First mismatch occurred at time 110.
Hint: Output 'aaah' has 14 mismatches. First mismatch occurred at time 690.
Hint: Output 'digging' has 34 mismatches. First mismatch occurred at time 620.
Hint: Total mismatched samples is 151 out of 1003 samples

Simulation finished at 5016 ps
Mismatches: 151 in 1003 samples
*/