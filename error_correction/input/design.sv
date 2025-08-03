
module TopModule (
  input [7:0] a,
  input [7:0] b,
  output [7:0] s,
  output reg overflow
);

  reg [8:0] temp_sum;

  always @* begin
    temp_sum = a + b;
    if (temp_sum[8] != temp_sum[7]) overflow = 1;
    
    end else begin
      overflow = 0;
    end

  assign s = temp_sum[7:0];

endmodule
/*