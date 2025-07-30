module TopModule (
  input clk,
  input reset,
  input ena,
  output reg pm,
  output reg [7:0] hh,
  output reg [7:0] mm,
  output reg [7:0] ss
);
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00 AM
            hh <= 8'b0001_0010; // 12
            mm <= 8'b0000_0000; // 00
            ss <= 8'b0000_0000; // 00
            pm <= 1'b0; // AM
        end
        else if (ena) begin
            // Increment seconds
            if (ss == 8'b0101_1001) begin // 59 seconds
                ss <= 8'b0000_0000; // reset seconds to 00
                // Increment minutes
                if (mm == 8'b0101_1001) begin // 59 minutes
                    mm <= 8'b0000_0000; // reset minutes to 00
                    // Increment hours
                    if (hh == 8'b0001_0010) begin // 12 hours
                        hh <= 8'b0000_0001; // reset hours to 01
                        pm <= ~pm; // toggle AM/PM
                    end else if (hh[3:0] == 4'b1001) begin // x9 hours
                        hh[3:0] <= 4'b0000; // reset lower nibble
                        hh[7:4] <= hh[7:4] + 1; // increment upper nibble
                    end else begin
                        hh[3:0] <= hh[3:0] + 1; // increment lower nibble
                    end
                end else if (mm[3:0] == 4'b1001) begin // x9 minutes
                    mm[3:0] <= 4'b0000; // reset lower nibble
                    mm[7:4] <= mm[7:4] + 1; // increment upper nibble
                end else begin
                    mm[3:0] <= mm[3:0] + 1; // increment lower nibble
                end
            end else if (ss[3:0] == 4'b1001) begin // x9 seconds
                ss[3:0] <= 4'b0000; // reset lower nibble
                ss[7:4] <= ss[7:4] + 1; // increment upper nibble
            end else begin
                ss[3:0] <= ss[3:0] + 1; // increment lower nibble
            end
        end
    end
endmodule

/*
Insufficient Understanding of Circuit Concepts: Number and Vector
*/

/*
The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
TIMEOUT
./Execute_environment/testbench.sv:261: $finish called at 1000000 (1ps)
Hint: Output 'pm' has 177947 mismatches. First mismatch occurred at time 38270.
Hint: Output 'hh' has no mismatches.
Hint: Output 'mm' has no mismatches.
Hint: Output 'ss' has no mismatches.
Hint: Total mismatched samples is 177947 out of 200000 samples

Simulation finished at 1000000 ps
Mismatches: 177947 in 200000 samples
*/