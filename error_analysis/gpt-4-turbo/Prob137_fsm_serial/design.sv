module TopModule (
  input clk,
  input in,
  input reset,
  output done
);
    reg [3:0] state, next_state;
    reg [7:0] data;
    reg [2:0] bit_count;
    reg done_reg;

    localparam IDLE        = 4'd0,
               CHECK_START = 4'd1,
               RECEIVE     = 4'd2,
               CHECK_STOP  = 4'd3,
               ERROR       = 4'd4;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done_reg <= 0;
        end else begin
            state <= next_state;
            if (state == RECEIVE) begin
                data <= {in, data[7:1]};
            end
            if (state == CHECK_STOP) begin
                done_reg <= in;
            end else begin
                done_reg <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = CHECK_START;
                else
                    next_state = IDLE;
            end
            CHECK_START: begin
                if (in == 0) begin
                    next_state = RECEIVE;
                    bit_count = 0;
                end else begin
                    next_state = IDLE;
                end
            end
            RECEIVE: begin
                if (bit_count == 7) begin
                    next_state = CHECK_STOP;
                end else begin
                    next_state = RECEIVE;
                    bit_count = bit_count + 1;
                end
            end
            CHECK_STOP: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            ERROR: begin
                if (in == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = ERROR;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule

/*
Insufficient Understanding of Circuit Concepts: FSM
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./Execute_environment/testbench.sv:45: $finish called at 4526 (1ps)
Hint: Output 'done' has 48 mismatches. First mismatch occurred at time 110.
Hint: Total mismatched samples is 48 out of 905 samples

Simulation finished at 4526 ps
Mismatches: 48 in 905 samples
*/