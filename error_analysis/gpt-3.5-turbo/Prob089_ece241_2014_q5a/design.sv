
module TopModule (
  input clk,
  input areset,
  input x,
  output z
);

  reg [1:0] state;
  reg [1:0] next_state;
  reg [1:0] z_reg;
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b00;
      z_reg <= 2'b00;
    end
    else begin
      state <= next_state;
      z_reg <= (state == 2'b11) ? ~x + 2'b01 : z_reg;
    end
  end
  
  always @* begin
    case (state)
      2'b00: begin
        next_state = x ? 2'b01 : 2'b00;
      end
      2'b01: begin
        next_state = x ? 2'b01 : 2'b10;
      end
      2'b10: begin
        next_state = x ? 2'b11 : 2'b10;
      end
      2'b11: begin
        next_state = x ? 2'b11 : 2'b00;
      end
    endcase
  end
  
  assign z = z_reg[1];
  
endmodule

/*
Insufficient Understanding of Circuit Concepts: FSM / Syn
Vector Bit Selection Error
*/
/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
D:/MyVerilogDebugger/Dataset/dataset_verilog-eval-human/Prob089_ece241_2014_q5a_test.sv:73: $finish called at 2180 (1ps)
Hint: Output 'z' has 257 mismatches. First mismatch occurred at time 20.
Hint: Total mismatched samples is 257 out of 436 samples

Simulation finished at 2180 ps
Mismatches: 257 in 436 samples

*/
