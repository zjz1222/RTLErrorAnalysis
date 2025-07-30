
module TopModule (
  input clk,
  input resetn,
  input in,
  output out
);
        reg [3:0] shift_reg;

        always @(posedge clk or negedge resetn) begin
            if (!resetn) begin
                shift_reg <= 4'b0000;
            end else begin
                shift_reg <= {shift_reg[2:0], in};
            end
        end

        assign out = shift_reg[3];
endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:21: $finish called at 1496 (1ps)
Hint: Output 'out' has 14 mismatches. First mismatch occurred at time 270.
Hint: Total mismatched samples is 14 out of 299 samples

Simulation finished at 1496 ps
Mismatches: 14 in 299 samples
*/

/*
Insufficient Understanding of Circuit Concept:
active high synchronous,   always @(posedge clk or posedge reset) error
*/