
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
    reg [3:0] pattern;
    reg [1:0] shift_counter;

    typedef enum reg [2:0] {
        IDLE,
        DETECT_PATTERN,
        SHIFTING,
        COUNTING,
        NOTIFIED
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0000;
            shift_counter <= 2'b00;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101)
                        next_state = DETECT_PATTERN;
                    else
                        next_state = IDLE;
                end
                DETECT_PATTERN: begin
                    shift_ena <= 1'b1;
                    shift_counter <= shift_counter + 1;
                    if (shift_counter == 2'b11)
                        next_state = SHIFTING;
                    else
                        next_state = DETECT_PATTERN;
                end
                SHIFTING: begin
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                    if (done_counting)
                        next_state = COUNTING;
                    else
                        next_state = SHIFTING;
                end
                COUNTING: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack)
                        next_state = NOTIFIED;
                    else
                        next_state = COUNTING;
                end
                NOTIFIED: begin
                    done <= 1'b0;
                    next_state = IDLE;
                end
                default: next_state = IDLE;
            endcase
        end
    end

endmodule
/*
Missing Details of Long Description
Insufficient Understanding of Circuit Concepts: FSM
*/
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your FSM didn't pass the sample timing diagram posted with the problem statement. Perhaps try debugging that?
./execute_environment/testbench.sv:76: $finish called at 25346 (1ps)
Hint: Output 'shift_ena' has 744 mismatches. First mismatch occurred at time 90.
Hint: Output 'counting' has 1505 mismatches. First mismatch occurred at time 130.
Hint: Output 'done' has 1464 mismatches. First mismatch occurred at time 180.
Hint: Total mismatched samples is 2554 out of 5069 samples

Simulation finished at 25346 ps
Mismatches: 2554 in 5069 samples

*/