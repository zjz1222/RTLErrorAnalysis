module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

reg [1:0] state, next_state;
reg [1:0] w_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // State A
        z <= 0; // Initialize output z to 0 in reset state
    end else begin
        state <= next_state;
    end
end

always @* begin
    case (state)
        2'b00: begin // State A
            if (s == 1) begin
                next_state = 2'b01; // Move to State B
            end else begin
                next_state = 2'b00; // Stay in State A
            end
        end
        2'b01: begin // State B
            if (w == 1) begin
                w_count <= w_count + 1;
            end
            if (w_count == 2) begin
                next_state = 2'b11; // Move to State D
                z = 1; // Set output z to 1
            end else begin
                next_state = 2'b10; // Move to State C
            end
        end
        2'b10: begin // State C
            if (w == 1) begin
                next_state = 2'b11; // Move to State D
            end else begin
                next_state = 2'b01; // Go back to State B
            end
        end
        2'b11: begin // State D
            if (w == 0) begin
                z = 0; // Set output z to 0
            end
            next_state = 2'b01; // Go back to State B
            w_count <= 0; // Reset w_count
        end
        default: next_state = 2'b00; // Default to State A
    endcase
end

endmodule
/*
Insufficient Understanding of Circuit Concepts： FSM
Insufficient Understanding of Circuit Concepts： Syn / Asyn
*/
