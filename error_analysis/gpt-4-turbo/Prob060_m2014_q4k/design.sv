module TopModule (
  input clk,
  input resetn,
  input in,
  output out
);
    always @(posedge clk) begin
        if (!resetn) begin
            q[0] <= 1'b0;
            q[1] <= 1'b0;
            q[2] <= 1'b0;
            q[3] <= 1'b0;
        end else begin
            q[0] <= in;
            q[1] <= q[0];
            q[2] <= q[1];
            q[3] <= q[2];
        end
    end

    assign out = q[3];

endmodule

/*
Using undefined variables
*/
/*
The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./Execute_environment/design.sv:21: error: Unable to bind wire/reg/memory `q['sd3]' in `tb.top_module1'
./Execute_environment/design.sv:21: error: Unable to elaborate r-value: q['sd3]
./Execute_environment/design.sv:9: error: Could not find variable ``q['sd0]'' in ``tb.top_module1''
./Execute_environment/design.sv:10: error: Could not find variable ``q['sd1]'' in ``tb.top_module1''
./Execute_environment/design.sv:11: error: Could not find variable ``q['sd2]'' in ``tb.top_module1''
./Execute_environment/design.sv:12: error: Could not find variable ``q['sd3]'' in ``tb.top_module1''
./Execute_environment/design.sv:14: error: Could not find variable ``q['sd0]'' in ``tb.top_module1''
./Execute_environment/design.sv:15: error: Could not find variable ``q['sd1]'' in ``tb.top_module1''
./Execute_environment/design.sv:16: error: Could not find variable ``q['sd2]'' in ``tb.top_module1''
./Execute_environment/design.sv:17: error: Could not find variable ``q['sd3]'' in ``tb.top_module1''
10 error(s) during elaboration.
*/