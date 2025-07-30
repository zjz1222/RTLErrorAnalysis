
module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);
        reg [1:0] state;
        parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

        always @(posedge clk or negedge aresetn) begin
            if (!aresetn) begin
                state <= S0;
                z <= 0;
            end else begin
                case (state)
                    S0: begin
                        if (x == 1'b1) begin
                            state <= S1;
                            z <= 0;
                        end else begin
                            state <= S0;
                            z <= 0;
                        end
                    end
                    S1: begin
                        if (x == 1'b0) begin
                            state <= S2;
                            z <= 0;
                        end else begin
                            state <= S1;
                            z <= 0;
                        end
                    end
                    S2: begin
                        if (x == 1'b1) begin
                            state <= S2;
                            z <= 1;
                        end else begin
                            state <= S0;
                            z <= 0;
                        end
                    end
                    default: begin
                        state <= S0;
                        z <= 0;
                    end
                endcase
            end
        end
endmodule
/*Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:86: $finish called at 2200 (1ps)
Hint: Output 'z' has 103 mismatches. First mismatch occurred at time 60.
Hint: Total mismatched samples is 103 out of 440 samples

Simulation finished at 2200 ps
Mismatches: 103 in 440 samples

*/
/*
Insufficient Understanding of Circuit Concepts: State Transfer Diagram 
*/