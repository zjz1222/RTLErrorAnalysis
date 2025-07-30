module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output done
);
    reg [7:0] data;
    reg [3:0] bit_count;
    reg done_reg;
    reg [1:0] state, next_state;

    // State encoding
    localparam IDLE = 2'b00,
               START_BIT = 2'b01,
               RECEIVE_BITS = 2'b10,
               STOP_BIT = 2'b11;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            data <= 0;
            bit_count <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            if (state == RECEIVE_BITS && next_state == RECEIVE_BITS) begin
                data <= {in, data[7:1]};
                bit_count <= bit_count + 1;
            end
            if (state == STOP_BIT) begin
                done_reg <= 1;
            end else begin
                done_reg <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                next_state = RECEIVE_BITS;
            end
            RECEIVE_BITS: begin
                if (bit_count == 8)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVE_BITS;
            end
            STOP_BIT: begin
                if (in == 1)
                    next_state = IDLE;
                else
                    next_state = STOP_BIT;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output assignments
    assign out_byte = data;
    assign done = done_reg;

endmodule

/*
Insufficient Understanding of Circuit Concepts： FSM
*/

/*
The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./Execute_environment/design.sv:1: syntax error
I give up.
*/