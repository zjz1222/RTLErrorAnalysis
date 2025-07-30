
module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] q;

always @(posedge clk or posedge areset) begin
    if (areset) begin
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
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob047_dff8ar/000/design.sv:9: error: 'q' has already been declared in this scope.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob047_dff8ar/000/design.sv:6:      : It was declared here as a variable.

*/
