
module RefModule (
  input d,
  input ena,
  output logic q
);
  initial begin
     q = 0;
  end
  always@(*) begin
    if (ena)
      q = d;
  end

endmodule

