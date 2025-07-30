
module TopModule (
  input clk,
  input in,
  input reset,
  output done
);
    reg [2:0] state;
    reg [7:0] data;
    reg [2:0] bit_count;
    reg done_reg;

    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data <= 8'b0;
            bit_count <= 3'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 1'b0;
                    if (in == 1'b0) begin
                        state <= START;
                    end
                end
                START: begin
                    if (in == 1'b0) begin
                        state <= DATA;
                        bit_count <= 3'b0;
                    end else begin
                        state <= IDLE;
                    end
                end
                DATA: begin
                    data[bit_count] <= in;
                    if (bit_count < 3'b111) begin
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done_reg <= 1'b1;
                        state <= IDLE;
                    end else begin
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    assign done = done_reg;

endmodule
/*Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:45: $finish called at 4526 (1ps)
Hint: Output 'done' has 53 mismatches. First mismatch occurred at time 110.
Hint: Total mismatched samples is 53 out of 905 samples

Simulation finished at 4526 ps
Mismatches: 53 in 905 samples

*/
/*
Insufficient Understanding of Circuit Concepts: State Transfer Diagram 
*/