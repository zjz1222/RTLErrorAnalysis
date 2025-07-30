
module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;
    end else begin
        q <= d;
    end
end

endmodule

/*
Variable Redefinition: q
*/
/*
The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob041_dff8r/000/design.sv:9: error: 'q' has already been declared in this scope.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob041_dff8r/000/design.sv:6:      : It was declared here as a variable.

*/
