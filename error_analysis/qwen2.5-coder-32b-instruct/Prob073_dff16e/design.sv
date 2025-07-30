
module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
        always @(posedge clk or negedge resetn) begin
            if (!resetn) begin
                q <= 16'b0;
            end else begin
                if (byteena[0])
                    q[7:0] <= d[7:0];
                if (byteena[1])
                    q[15:8] <= d[15:8];
            end
        end
endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset should be synchronous, but doesn't appear to be.
./execute_environment/testbench.sv:80: $finish called at 2216 (1ps)
Hint: Output 'q' has 1 mismatches. First mismatch occurred at time 65.
Hint: Total mismatched samples is 1 out of 443 samples

Simulation finished at 2216 ps
Mismatches: 1 in 443 samples
*/

/*
Insufficient Understanding of Circuit Concepts: Syn/Asyn
*/