
module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [9:0] counter;
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter SHIFTING = 2'b01;
    parameter COUNTING = 2'b10;
    parameter DONE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0000;
            delay <= 4'b0000;
            counter <= 10'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (shift_reg == 4'b1101) begin
                        state <= SHIFTING;
                    end else begin
                        shift_reg <= {shift_reg[2:0], data};
                    end
                end
                SHIFTING: begin
                    if (counter < 4) begin
                        shift_reg <= {shift_reg[2:0], data};
                        counter <= counter + 1;
                    end else begin
                        delay <= shift_reg;
                        counter <= 10'd0;
                        state <= COUNTING;
                        counting <= 1'b1;
                    end
                end
                COUNTING: begin
                    if (counter < (delay + 1) * 10'd1000) begin
                        counter <= counter + 1;
                        count <= delay - (counter / 10'd1000);
                    end else begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule
/*
Insufficient Understanding of Circuit Concepts: FSM
Missing Details of Long Descriptions
Illegal Assignment
*/
/*
Status: Error compiling testbench

Fail Messages:The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./execute_environment/design.sv:52: error: count is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : count is declared here as wire.
1 error(s) during elaboration.

*/