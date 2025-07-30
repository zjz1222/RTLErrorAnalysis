
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
reg [1:0] pht [127:0];

always @(posedge clk or posedge areset) begin
  if (areset) begin
    global_history <= 7'b0;
    for (int i = 0; i < 128; i = i + 1) begin
      pht[i] <= 2'b10; // Initialize all entries to weakly taken
    end
  end else begin
    if (train_valid) begin
      reg [6:0] index;
      index = train_pc ^ train_history;
      if (train_taken) begin
        if (pht[index] != 2'b11)
          pht[index] <= pht[index] + 1;
      end else begin
        if (pht[index] != 2'b00)
          pht[index] <= pht[index] - 1;
      end
      if (train_mispredicted)
        global_history <= train_history;
    end
    if (predict_valid && !train_valid)
      global_history <= {global_history[5:0], predict_taken};
  end
end

assign predict_taken = (pht[predict_pc ^ global_history] >= 2'b10);
assign predict_history = global_history;

endmodule
/*
Missing Details of Long Descriptions
*/

/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset doesn't seem to be working.
./execute_environment/testbench.sv:161: $finish called at 5416 (1ps)
Hint: Output 'predict_taken' has 429 mismatches. First mismatch occurred at time 20.
Hint: Output 'predict_history' has 586 mismatches. First mismatch occurred at time 110.
Hint: Total mismatched samples is 601 out of 1083 samples

Simulation finished at 5416 ps
Mismatches: 601 in 1083 samples

*/