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
    reg [3:0] shift_reg;
    reg [2:0] state, next_state;

    // State encoding
    localparam IDLE = 3'd0,
               CHECK_PATTERN = 3'd1,
               SHIFT = 3'd2,
               COUNT = 3'd3,
               NOTIFY = 3'd4,
               WAIT_ACK = 3'd5;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (shift_reg == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = CHECK_PATTERN;
            end
            CHECK_PATTERN: begin
                next_state = (shift_reg == 4'b1101) ? SHIFT : CHECK_PATTERN;
            end
            SHIFT: begin
                if (shift_ena_counter == 4)
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end
            COUNT: begin
                if (done_counting)
                    next_state = NOTIFY;
                else
                    next_state = COUNT;
            end
            NOTIFY: begin
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic and shift register update
    reg [2:0] shift_ena_counter;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0000;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_ena_counter <= 0;
        end else begin
            shift_reg <= {shift_reg[2:0], data}; // Shift in the new bit

            case (state)
                CHECK_PATTERN: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
                SHIFT: begin
                    shift_ena <= 1;
                    shift_ena_counter <= shift_ena_counter + 1;
                    counting <= 0;
                    done <= 0;
                end
                COUNT: begin
                    shift_ena <= 0;
                    counting <= 1;
                    done <= 0;
                    shift_ena_counter <= 0;
                end
                NOTIFY: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 1;
                end
                WAIT_ACK: begin
                    shift_ena <= 0;
                    counting <= 0;
                    // Keep 'done' high until acknowledged
                end
                default: begin
                    shift_ena <= 0;
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end
endmodule

/*
Insufficient Understanding of Circuit Concepts: FSM
Missing Details of Long Descriptions
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your FSM didn't pass the sample timing diagram posted with the problem statement. Perhaps try debugging that?
./Execute_environment/testbench.sv:76: $finish called at 25346 (1ps)
Hint: Output 'shift_ena' has 320 mismatches. First mismatch occurred at time 90.
Hint: Output 'counting' has 396 mismatches. First mismatch occurred at time 130.
Hint: Output 'done' has 320 mismatches. First mismatch occurred at time 180.
Hint: Total mismatched samples is 644 out of 5069 samples

Simulation finished at 25346 ps
Mismatches: 644 in 5069 samples
*/