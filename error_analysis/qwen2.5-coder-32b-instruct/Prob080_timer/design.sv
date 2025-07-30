
module TopModule (
  input clk,
  input load,
  input [9:0] data,
  output tc
);
reg [9:0] counter;
reg tc_reg;

always @(posedge clk) begin
    if (load) begin
        counter <= data;
        tc_reg <= 0;
    end else if (counter > 0) begin
        counter <= counter - 1;
        tc_reg <= 0;
    end else begin
        tc_reg <= 1;
    end
end

assign tc = tc_reg;

endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:55: $finish called at 35636 (1ps)
Hint: Output 'tc' has 132 mismatches. First mismatch occurred at time 50.
Hint: Total mismatched samples is 132 out of 7127 samples

Simulation finished at 35636 ps
Mismatches: 132 in 7127 samples
*/
