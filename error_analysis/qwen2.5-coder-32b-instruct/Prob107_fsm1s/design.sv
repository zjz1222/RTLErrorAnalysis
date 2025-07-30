
module TopModule (
  input clk,
  input in,
  input reset,
  output out
);
        reg [1:0] state, next_state;
        parameter B = 2'b01, A = 2'b10;

        always @(posedge clk or posedge reset) begin
            if (reset)
                state <= B;
            else
                state <= next_state;
        end

        always @(*) begin
            case (state)
                B: begin
                    if (in == 0)
                        next_state = A;
                    else
                        next_state = B;
                end
                A: begin
                    if (in == 0)
                        next_state = B;
                    else
                        next_state = A;
                end
                default: next_state = B;
            endcase
        end

        assign out = (state == B) ? 1'b1 : 1'b0;
endmodule
/*Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset should be synchronous, but doesn't appear to be.
./execute_environment/testbench.sv:70: $finish called at 1151 (1ps)
Hint: Output 'out' has 57 mismatches. First mismatch occurred at time 85.
Hint: Total mismatched samples is 57 out of 230 samples

Simulation finished at 1151 ps
Mismatches: 57 in 230 samples

*/
/*
Insufficient Understanding of Circuit Concepts
*/