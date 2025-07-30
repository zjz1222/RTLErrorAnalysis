
module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);
    reg [1:0] current_state;
    reg [1:0] next_state;

    // State encoding
    parameter LOW = 2'b00;   // Below s[1]
    parameter MID1 = 2'b01;  // Between s[1] and s[2]
    parameter MID2 = 2'b10;  // Between s[2] and s[3]
    parameter HIGH = 2'b11;  // Above s[3]

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= LOW;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            LOW: begin
                if (s == 3'b001) begin
                    next_state = MID1;
                end else begin
                    next_state = LOW;
                end
            end
            MID1: begin
                if (s == 3'b011) begin
                    next_state = MID2;
                end else if (s == 3'b001) begin
                    next_state = MID1;
                end else begin
                    next_state = LOW;
                end
            end
            MID2: begin
                if (s == 3'b111) begin
                    next_state = HIGH;
                end else if (s == 3'b011) begin
                    next_state = MID2;
                end else if (s == 3'b001) begin
                    next_state = MID1;
                end else begin
                    next_state = LOW;
                end
            end
            HIGH: begin
                if (s != 3'b111) begin
                    next_state = MID2;
                end else begin
                    next_state = HIGH;
                end
            end
            default: begin
                next_state = LOW;
            end
        endcase
    end

    always @(current_state) begin
        case (current_state)
            LOW: begin
                fr3 = 1;
                fr2 = 1;
                fr1 = 1;
                dfr = 0;
            end
            MID1: begin
                fr3 = 0;
                fr2 = 1;
                fr1 = 1;
                dfr = (s == 3'b001) ? 0 : 1;
            end
            MID2: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = 1;
                dfr = (s == 3'b011) ? 0 : 1;
            end
            HIGH: begin
                fr3 = 0;
                fr2 = 0;
                fr1 = 0;
                dfr = 0;
            end
        endcase
    end

endmodule
/*
Insufficient Understanding of Circuit Concepts: FSM / Syn
*/
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset doesn't seem to be working.
./execute_environment/testbench.sv:84: $finish called at 10200 (1ps)
Hint: Output 'fr3' has 1 mismatches. First mismatch occurred at time 55.
Hint: Output 'fr2' has no mismatches.
Hint: Output 'fr1' has no mismatches.
Hint: Output 'dfr' has 1252 mismatches. First mismatch occurred at time 10.
Hint: Total mismatched samples is 1253 out of 2040 samples

Simulation finished at 10200 ps
Mismatches: 1253 in 2040 samples

*/