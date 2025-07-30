
module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
    reg [1:0] state;
    reg [2:0] count;

    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            count <= 3'b000;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (s == 1) begin
                        state <= B;
                        count <= 3'b000;
                    end
                end
                B: begin
                    if (count < 3) begin
                        count <= count + 1;
                        if (w == 1)
                            count[2] <= count[2] + 1;
                    end else begin
                        z <= (count[2] == 2);
                        state <= C;
                    end
                end
                C: begin
                    state <= B;
                    count <= 3'b000;
                end
            endcase
        end
    end

endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:59: $finish called at 7071 (1ps)
Hint: Output 'z' has 174 mismatches. First mismatch occurred at time 110.
Hint: Total mismatched samples is 174 out of 1414 samples

Simulation finished at 7071 ps
Mismatches: 174 in 1414 samples

*/

/*
Insufficient Understanding of Circuit Concepts: State Transfer Diagram 
*/