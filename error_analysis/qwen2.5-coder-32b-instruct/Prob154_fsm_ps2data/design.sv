
module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output done
);
    reg [1:0] state;
    reg [23:0] message;
    reg done_reg;

    parameter IDLE = 2'b00;
    parameter FIRST_BYTE = 2'b01;
    parameter SECOND_BYTE = 2'b10;
    parameter THIRD_BYTE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            message <= 24'b0;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= FIRST_BYTE;
                        message[23:16] <= in;
                        done_reg <= 0;
                    end
                end
                FIRST_BYTE: begin
                    state <= SECOND_BYTE;
                    message[15:8] <= in;
                    done_reg <= 0;
                end
                SECOND_BYTE: begin
                    state <= THIRD_BYTE;
                    message[7:0] <= in;
                    done_reg <= 0;
                end
                THIRD_BYTE: begin
                    state <= IDLE;
                    done_reg <= 1;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign out_bytes = message;
    assign done = done_reg;

endmodule

/*
Insufficient Understanding of Circuit Concepts: FSM
Misinterpretation of Multimodal Data: Waveform
*/
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
./execute_environment/testbench.sv:31: $finish called at 8096 (1ps)
Hint: Output 'out_bytes' has 317 mismatches. First mismatch occurred at time 240.
Hint: Output 'done' has 717 mismatches. First mismatch occurred at time 210.
Hint: Total mismatched samples is 859 out of 1619 samples

Simulation finished at 8096 ps
Mismatches: 859 in 1619 samples

*/