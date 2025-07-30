module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output f,
  output g
);
    reg f, g;
    reg [2:0] state, next_state;
    
    // State encoding
    localparam STATE_A = 3'd0,
               STATE_B = 3'd1,
               STATE_X1 = 3'd2,
               STATE_X0 = 3'd3,
               STATE_X1_AGAIN = 3'd4,
               STATE_G1 = 3'd5,
               STATE_Y_CHECK = 3'd6,
               STATE_G_PERMANENT = 3'd7,
               STATE_G_RESET = 3'd8;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                next_state = STATE_B;
            end
            STATE_B: begin
                next_state = STATE_X1;
            end
            STATE_X1: begin
                if (x == 1)
                    next_state = STATE_X0;
                else
                    next_state = STATE_X1;
            end
            STATE_X0: begin
                if (x == 0)
                    next_state = STATE_X1_AGAIN;
                else
                    next_state = STATE_X1;
            end
            STATE_X1_AGAIN: begin
                if (x == 1)
                    next_state = STATE_G1;
                else
                    next_state = STATE_X1;
            end
            STATE_G1: begin //error
                next_state = STATE_Y_CHECK;
            end
            STATE_Y_CHECK: begin
                if (y == 1)
                    next_state = STATE_G_PERMANENT;
                else
                    next_state = STATE_G_RESET;
            end
            STATE_G_PERMANENT: begin
                next_state = STATE_G_PERMANENT;
            end
            STATE_G_RESET: begin
                next_state = STATE_G_RESET;
            end
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                STATE_B: f <= 1;
                STATE_X1: f <= 0;
                STATE_X0: f <= 0;
                STATE_X1_AGAIN: f <= 0;
                STATE_G1: g <= 1;
                STATE_Y_CHECK: g <= 1;
                STATE_G_PERMANENT: g <= 1;
                STATE_G_RESET: g <= 0;
                default: begin
                    f <= 0;
                    g <= 0;
                end
            endcase
        end
    end

endmodule

/*
Insufficient Understanding of Circuit Concepts: FSM
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./Execute_environment/testbench.sv:24: $finish called at 5011 (1ps)
Hint: Output 'f' has 44 mismatches. First mismatch occurred at time 20.
Hint: Output 'g' has 334 mismatches. First mismatch occurred at time 60.
Hint: Total mismatched samples is 376 out of 1002 samples

Simulation finished at 5011 ps
Mismatches: 376 in 1002 samples
*/