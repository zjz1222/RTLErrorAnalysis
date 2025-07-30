
module TopModule (
  input clk,
  input reset,
  output [3:1] ena,
  output reg [15:0] q
);
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                q <= 16'b0000_0000_0000_0000;
                ena <= 3'b000;
            end else begin
                // Increment the ones digit
                if (q[3:0] == 4'd9) begin
                    q[3:0] <= 4'd0;
                    ena[0] <= 1'b1; // Enable increment for tens digit
                end else begin
                    q[3:0] <= q[3:0] + 1;
                    ena[0] <= 1'b0;
                end

                // Increment the tens digit if enabled
                if (ena[0]) begin
                    if (q[7:4] == 4'd9) begin
                        q[7:4] <= 4'd0;
                        ena[1] <= 1'b1; // Enable increment for hundreds digit
                    end else begin
                        q[7:4] <= q[7:4] + 1;
                        ena[1] <= 1'b0;
                    end
                end

                // Increment the hundreds digit if enabled
                if (ena[1]) begin
                    if (q[11:8] == 4'd9) begin
                        q[11:8] <= 4'd0;
                        ena[2] <= 1'b1; // Enable increment for thousands digit
                    end else begin
                        q[11:8] <= q[11:8] + 1;
                        ena[2] <= 1'b0;
                    end
                end

                // Increment the thousands digit if enabled
                if (ena[2]) begin
                    if (q[15:12] == 4'd9) begin
                        q[15:12] <= 4'd0;
                    end else begin
                        q[15:12] <= q[15:12] + 1;
                    end
                end
            end
        end
endmodule
/*
Status: Error compiling testbench

Fail Messages:The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./execute_environment/design.sv:11: error: ena is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:5:      : ena is declared here as wire.
./execute_environment/design.sv:16: error: ena['sd0] is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:5:      : ena['sd0] is declared here as wire.
./execute_environment/design.sv:19: error: ena['sd0] is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:5:      : ena['sd0] is declared here as wire.
./execute_environment/design.sv:37: error: ena['sd2] is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:5:      : ena['sd2] is declared here as wire.
./execute_environment/design.sv:40: error: ena['sd2] is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:5:      : ena['sd2] is declared here as wire.
5 error(s) during elaboration.
*/

/*
Insufficient Understanding of Circuit Concepts: @(posedge clk or posedge reset)
Illegal Assignment: ena[0] <= 1'b1; // Enable increment for tens digit
*/