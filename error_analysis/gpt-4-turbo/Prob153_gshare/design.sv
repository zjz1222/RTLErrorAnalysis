module TopModule (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output predict_taken,
  output [6:0] predict_history,

  input train_valid,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);
    reg [6:0] global_history;
    reg [1:0] pht [0:127];
    wire [6:0] predict_index;
    wire [6:0] train_index;

    assign predict_index = predict_pc ^ global_history;
    assign train_index = train_pc ^ train_history;

    assign predict_taken = pht[predict_index][1];
    assign predict_history = global_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            global_history <= 7'b0;
            integer i;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize PHT to weakly not taken
            end
        end else begin
            if (train_valid) begin
                // Training logic
                if (train_taken) begin
                    if (pht[train_index] != 2'b11) begin
                        pht[train_index] <= pht[train_index] + 1;
                    end
                end else begin
                    if (pht[train_index] != 2'b00) begin
                        pht[train_index] <= pht[train_index] - 1;
                    end
                end

                // Update global history on training
                global_history <= {global_history[5:0], train_taken};

                // If there was a misprediction, recover the history
                if (train_mispredicted) begin
                    global_history <= train_history;
                end
            end else if (predict_valid) begin
                // Update global history on prediction
                global_history <= {global_history[5:0], pht[predict_index][1]};
            end
        end
    end
endmodule

/*
Missing Details of Long Descriptions
Incorrect location of variable definition
*/

/*
The testbench failed to compile. Please fix the module. The output of iverilog is as follows:
./Execute_environment/design.sv:30: syntax error
./Execute_environment/design.sv:30: error: malformed statement
*/