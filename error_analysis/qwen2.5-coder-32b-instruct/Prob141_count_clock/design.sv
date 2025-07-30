
module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm <= 0;
            hh <= 8'd12; // 12 in BCD
            mm <= 8'd00; // 00 in BCD
            ss <= 8'd00; // 00 in BCD
        end else if (ena) begin
            if (ss == 8'd59) begin // 59 in BCD
                ss <= 8'd00; // Reset seconds to 00
                if (mm == 8'd59) begin // 59 in BCD
                    mm <= 8'd00; // Reset minutes to 00
                    if (hh == 8'd12) begin // 12 in BCD
                        hh <= 8'd01; // Reset hours to 01
                        pm <= ~pm; // Toggle AM/PM
                    end else begin
                        hh <= hh + 8'd01; // Increment hours
                    end
                end else begin
                    mm <= mm + 8'd01; // Increment minutes
                end
            end else begin
                ss <= ss + 8'd01; // Increment seconds
            end
        end
    end

endmodule
/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: Your reset doesn't seem to be working.
Hint: Clock seems to reset to 0c:00:00 AM (Should be 12:00:00 AM).
TIMEOUT
./execute_environment/testbench.sv:261: $finish called at 1000000 (1ps)
Hint: Output 'pm' has 177947 mismatches. First mismatch occurred at time 38270.
Hint: Output 'hh' has 50852 mismatches. First mismatch occurred at time 10.
Hint: Output 'mm' has 165947 mismatches. First mismatch occurred at time 8270.
Hint: Output 'ss' has 166381 mismatches. First mismatch occurred at time 55.
Hint: Total mismatched samples is 199999 out of 200000 samples

Simulation finished at 1000000 ps
Mismatches: 199999 in 200000 samples
*/

/*
Insufficient Understanding of Circuit Concepts： Number and Vector Processing, BCD
*/