module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    // State declaration
    typedef enum reg [2:0] { A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100 } state_type;
    // State variables
    reg [2:0] state, next_state;
    reg [1:0] count_ones;
    // State register logic
    always @(posedge clk, posedge reset) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end
    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = s ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? E : D;
            E: next_state = B;
            default: next_state = A;
        endcase
    end
    // Output logic
    always @(posedge clk) begin
        if (state == B) begin
            count_ones <= 0;
        end
        else if (state == C || state == D) begin
            if (w) count_ones <= count_ones + 1;
        end
        else if (state == E) begin
            z <= (count_ones == 2);
        end
        else if (state != E)
            z <= 0;
    end

endmodule
/*
Insufficient Understanding of Circuit Concepts: FSM
Insufficient Understanding of Circuit Concepts: Syn / Asyn
*/