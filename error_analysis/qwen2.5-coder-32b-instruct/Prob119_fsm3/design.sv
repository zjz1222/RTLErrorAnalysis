
module TopModule (
  input clk,
  input in,
  input areset,
  output out
);
        reg [1:0] state, next_state;
        parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

        always @(posedge clk or posedge areset) begin
            if (areset)
                state <= A;
            else
                state <= next_state;
        end

        always @(*) begin
            case (state)
                A: begin
                    if (in == 0)
                        next_state = A;
                    else
                        next_state = B;
                    out = 0;
                end
                B: begin
                    if (in == 0)
                        next_state = C;
                    else
                        next_state = B;
                    out = 0;
                end
                C: begin
                    if (in == 0)
                        next_state = A;
                    else
                        next_state = D;
                    out = 0;
                end
                D: begin
                    if (in == 0)
                        next_state = C;
                    else
                        next_state = B;
                    out = 1;
                end
                default: begin
                    next_state = A;
                    out = 0;
                end
            endcase
        end

endmodule
/*Status: Error compiling testbench

Fail Messages:The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./execute_environment/design.sv:25: error: out is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : out is declared here as wire.
./execute_environment/design.sv:32: error: out is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : out is declared here as wire.
./execute_environment/design.sv:39: error: out is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : out is declared here as wire.
./execute_environment/design.sv:46: error: out is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : out is declared here as wire.
./execute_environment/design.sv:50: error: out is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : out is declared here as wire.
5 error(s) during elaboration.

*/
/*
Illegal Assignment 
*/