module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions using one-hot encoding
    localparam A = 2'b01;
    localparam B = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // State register logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;  // Reset to state A
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            A: next_state = (x == 1'b1) ? B : A;
            B: next_state = B;  // State B does not change based on x
            default: next_state = A;  // Default case to handle unknown states
        endcase
    end

endmodule
/*
Misinterpretation of Multimodal Data: State Transition Diagram
*/