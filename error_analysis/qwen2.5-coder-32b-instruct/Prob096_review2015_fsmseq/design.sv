
module TopModule (
  input clk,
  input reset,
  input data,
  output start_shifting
);
        reg [3:0] state;
        reg start_shifting_reg;

        parameter IDLE = 4'b0000;
        parameter S1 = 4'b0001;
        parameter S11 = 4'b0010;
        parameter S110 = 4'b0100;

        always @(posedge clk or posedge reset) begin
            if (reset) begin
                state <= IDLE;
                start_shifting_reg <= 0;
            end else begin
                case (state)
                    IDLE: begin
                        if (data == 1)
                            state <= S1;
                        else
                            state <= IDLE;
                    end
                    S1: begin
                        if (data == 1)
                            state <= S11;
                        else
                            state <= IDLE;
                    end
                    S11: begin
                        if (data == 0)
                            state <= S110;
                        else
                            state <= S1;
                    end
                    S110: begin
                        if (data == 1) begin
                            state <= IDLE;
                            start_shifting_reg <= 1;
                        end else
                            state <= IDLE;
                    end
                    default: state <= IDLE;
                endcase
            end
        end

        assign start_shifting = start_shifting_reg;

endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset should be synchronous, but doesn't appear to be.
./execute_environment/testbench.sv:74: $finish called at 3216 (1ps)
Hint: Output 'start_shifting' has 68 mismatches. First mismatch occurred at time 105.
Hint: Total mismatched samples is 68 out of 643 samples

Simulation finished at 3216 ps
Mismatches: 68 in 643 samples
*/

/*
Insufficient Understanding of Circuit Concepts:
State Design
@(posedge clk or posedge reset)
*/

