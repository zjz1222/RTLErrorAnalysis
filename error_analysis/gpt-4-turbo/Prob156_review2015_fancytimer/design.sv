module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [13:0] timer;
    reg [2:0] state;
    reg [3:0] current_count;
    reg [3:0] bit_counter;

    localparam IDLE = 3'b000,
               CHECK_PATTERN = 3'b001,
               LOAD_DELAY = 3'b010,
               COUNTING = 3'b011,
               DONE_WAIT = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            delay <= 4'b0000;
            timer <= 14'd0;
            counting <= 1'b0;
            done <= 1'b0;
            current_count <= 4'b0000;
            bit_counter <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= LOAD_DELAY;
                        bit_counter <= 4'b0000;
                    end
                end
                LOAD_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 4) begin
                        delay <= shift_reg;
                        timer <= (shift_reg + 1) * 1000;
                        state <= COUNTING;
                        counting <= 1'b1;
                        current_count <= shift_reg;
                    end
                end
                COUNTING: begin
                    if (timer > 0) begin
                        timer <= timer - 1;
                        if (timer % 1000 == 0) begin
                            current_count <= current_count - 1;
                        end
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        state <= DONE_WAIT;
                    end
                end
                DONE_WAIT: begin
                    if (ack) begin
                        done <= 1'b0;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign count = (state == COUNTING) ? current_count : 4'bxxxx;

endmodule
/*
Insufficient Understanding of Circuit Concepts: FSM
Missing Details of Long Descriptions
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: The first test case should count for 2000 cycles. Your circuit counted 1
Hint: The second test case should count for 15000 cycles. Your circuit counted 13001
Hint: Your FSM didn't pass the sample timing diagram posted with the problem statement. Perhaps try debugging that?
TIMEOUT
./Execute_environment/testbench.sv:216: $finish called at 1000000 (1ps)
Hint: Output 'count' has 192469 mismatches. First mismatch occurred at time 130.
Hint: Output 'counting' has 9266 mismatches. First mismatch occurred at time 130.
Hint: Output 'done' has 8676 mismatches. First mismatch occurred at time 160.
Hint: Total mismatched samples is 192745 out of 200000 samples

Simulation finished at 1000000 ps
Mismatches: 192745 in 200000 samples
*/