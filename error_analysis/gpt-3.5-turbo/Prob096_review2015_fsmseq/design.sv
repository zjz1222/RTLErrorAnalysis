
module TopModule (
  input clk,
  input reset,
  input data,
  output start_shifting
);

reg [2:0] state;
reg start_shifting;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
        start_shifting <= 1'b0;
    end
    else begin
        case (state)
            3'b000: begin
                if (data) begin
                    state <= 3'b001;
                end
                else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin
                if (data) begin
                    state <= 3'b010;
                end
                else begin
                    state <= 3'b000;
                end
            end
            3'b010: begin
                if (data) begin
                    state <= 3'b011;
                end
                else begin
                    state <= 3'b000;
                end
            end
            3'b011: begin
                if (data) begin
                    state <= 3'b011;
                    start_shifting <= 1'b1;
                end
                else begin
                    state <= 3'b000;
                end
            end
        endcase
    end
end

endmodule

/*
Insufficient Understanding of Circuit Concepts: FSM
Insufficient Understanding of Circuit Concepts: Syn / Asyn
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob096_review2015_fsmseq_test.sv:74: $finish called at 3216 (1ps)
Hint: Output 'start_shifting' has 175 mismatches. First mismatch occurred at time 50.
Hint: Total mismatched samples is 175 out of 643 samples

Simulation finished at 3216 ps
Mismatches: 175 in 643 samples

*/
