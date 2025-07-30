
module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);
    reg [2:0] state;
    reg [2:0] next_state;
    reg disc_reg, flag_reg, err_reg;

    parameter S0 = 3'b000; // Start state or state after 0
    parameter S1 = 3'b001; // State after 1
    parameter S2 = 3'b010; // State after 11
    parameter S3 = 3'b011; // State after 111
    parameter S4 = 3'b100; // State after 1111
    parameter S5 = 3'b101; // State after 11111
    parameter S6 = 3'b110; // State after 111111
    parameter S7 = 3'b111; // State after 1111111

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        disc_reg = 0;
        flag_reg = 0;
        err_reg = 0;

        case (state)
            S0: begin
                if (in == 1)
                    next_state = S1;
            end
            S1: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S2;
            end
            S2: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S3;
            end
            S3: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S4;
            end
            S4: begin
                if (in == 0)
                    next_state = S0;
                else
                    next_state = S5;
            end
            S5: begin
                if (in == 0) begin
                    next_state = S0;
                    disc_reg = 1;
                end else if (in == 1)
                    next_state = S6;
            end
            S6: begin
                if (in == 0) begin
                    next_state = S0;
                    flag_reg = 1;
                end else if (in == 1)
                    next_state = S7;
            end
            S7: begin
                if (in == 0)
                    next_state = S0;
                else
                    err_reg = 1;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= disc_reg;
            flag <= flag_reg;
            err <= err_reg;
        end
    end

endmodule
/*
Status: Error compiling testbench

Fail Messages:The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./execute_environment/design.sv:90: error: disc is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : disc is declared here as wire.
./execute_environment/design.sv:91: error: flag is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:7:      : flag is declared here as wire.
./execute_environment/design.sv:92: error: err is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:8:      : err is declared here as wire.
./execute_environment/design.sv:94: error: disc is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:6:      : disc is declared here as wire.
./execute_environment/design.sv:95: error: flag is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:7:      : flag is declared here as wire.
./execute_environment/design.sv:96: error: err is not a valid l-value in tb.top_module1.
./execute_environment/design.sv:8:      : err is declared here as wire.
6 error(s) during elaboration.
*/

/*
Illegal Assignment
*/