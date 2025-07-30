module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);
    always @(posedge clk) begin
        case (y)
            3'b000: Y0 <= 1'b0;
            3'b001: Y0 <= x ? 1'b0 : 1'b1;
            3'b010: Y0 <= 1'b0;
            3'b011: Y0 <= x ? 1'b0 : 1'b1;
            3'b100: Y0 <= x ? 1'b0 : 1'b1;
            default: Y0 <= 1'b0;
        endcase
    end

    always @(posedge clk) begin
        case (y)
            3'b000: z <= 1'b0;
            3'b001: z <= 1'b0;
            3'b010: z <= 1'b0;
            3'b011: z <= 1'b1;
            3'b100: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
endmodule
/*
Misinterpretation of Multimodal Data: Table
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./Execute_environment/testbench.sv:18: $finish called at 1001 (1ps)
Hint: Output 'Y0' has 54 mismatches. First mismatch occurred at time 45.
Hint: Output 'z' has 55 mismatches. First mismatch occurred at time 10.
Hint: Total mismatched samples is 83 out of 200 samples

Simulation finished at 1001 ps
Mismatches: 83 in 200 samples
*/