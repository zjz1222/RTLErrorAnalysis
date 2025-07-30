
module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);
reg [1:0] state;
reg done_reg;

parameter IDLE = 2'b00;
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    state <= FIRST_BYTE;
                    done_reg <= 0;
                end
            end
            FIRST_BYTE: begin
                state <= SECOND_BYTE;
                done_reg <= 0;
            end
            SECOND_BYTE: begin
                state <= IDLE;
                done_reg <= 1;
            end
            default: begin
                state <= IDLE;
                done_reg <= 0;
            end
        endcase
    end
end

assign done = done_reg;

endmodule
/*Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:18: $finish called at 2001 (1ps)
Hint: Output 'done' has 66 mismatches. First mismatch occurred at time 250.
Hint: Total mismatched samples is 66 out of 400 samples

Simulation finished at 2001 ps
Mismatches: 66 in 400 samples

*/
/*
Insufficient Understanding of Circuit Concepts: State Transfer Diagram 
*/