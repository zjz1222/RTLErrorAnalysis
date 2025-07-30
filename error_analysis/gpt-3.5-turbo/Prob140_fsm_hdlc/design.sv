
module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

reg [2:0] state, next_state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

always @* begin
    disc = 1'b0;
    flag = 1'b0;
    err = 1'b0;
    
    case (state)
        3'b000: begin // State 0
            if (in) begin
                next_state = 3'b001;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b001: begin // State 1
            if (in) begin
                next_state = 3'b010;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b010: begin // State 2
            if (in) begin
                next_state = 3'b011;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b011: begin // State 3
            if (in) begin
                next_state = 3'b100;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b100: begin // State 4
            if (in) begin
                next_state = 3'b101;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b101: begin // State 5
            if (in) begin
                next_state = 3'b110;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b110: begin // State 6
            if (in) begin
                next_state = 3'b111;
                disc = 1'b1;
            end else begin
                next_state = 3'b000;
            end
        end
        3'b111: begin // State 7
            if (in) begin
                next_state = 3'b111;
                err = 1'b1;
            end else begin
                next_state = 3'b000;
            end
        end
        default: begin
            next_state = 3'b000;
        end
    endcase
end

endmodule
/*
The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:22: error: disc is not a valid l-value in tb.top_module1.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:6:      : disc is declared here as wire.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:23: error: flag is not a valid l-value in tb.top_module1.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:7:      : flag is declared here as wire.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:24: error: err is not a valid l-value in tb.top_module1.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:8:      : err is declared here as wire.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:72: error: disc is not a valid l-value in tb.top_module1.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:6:      : disc is declared here as wire.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:80: error: err is not a valid l-value in tb.top_module1.
D:\MyVerilogDebugger\Result\VerilogEval-Human\zero-shot\gpt35/Prob140_fsm_hdlc/000/design.sv:8:      : err is declared here as wire.
5 error(s) during elaboration.

*/
/*
Insufficient Understanding of Circuit Concepts: FSM
Insufficient Understanding of Circuit Concepts: Syn / Asyn
Illegal Assignment
*/