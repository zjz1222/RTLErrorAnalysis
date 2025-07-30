
module TopModule (
  input clk,
  input in,
  output logic out
);
        reg q;

        always @(posedge clk) begin
            q <= in ^ q;
        end

        assign out = q;

endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:16: $finish called at 501 (1ps)
Hint: Output 'out' has 1 mismatches. First mismatch occurred at time 5.
Hint: Total mismatched samples is 1 out of 100 samples

Simulation finished at 501 ps
Mismatches: 1 in 100 samples
*/

/*
Ambiguous Design Descriptions: Lack of initialization
*/