
module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
    integer i, j;
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                integer index = i * 16 + j;
                integer left = i * 16 + (j - 1 + 16) % 16;
                integer right = i * 16 + (j + 1) % 16;
                integer top = ((i - 1 + 16) % 16) * 16 + j;
                integer bottom = ((i + 1) % 16) * 16 + j;
                integer topLeft = ((i - 1 + 16) % 16) * 16 + (j - 1 + 16) % 16;
                integer topRight = ((i - 1 + 16) % 16) * 16 + (j + 1) % 16;
                integer bottomLeft = ((i + 1) % 16) * 16 + (j - 1 + 16) % 16;
                integer bottomRight = ((i + 1) % 16) * 16 + (j + 1) % 16;
                integer neighbors = q[left] + q[right] + q[top] + q[bottom] +
                                    q[topLeft] + q[topRight] + q[bottomLeft] + q[bottomRight];

                if (neighbors == 2)
                    next_q[index] = q[index];
                else if (neighbors == 3)
                    next_q[index] = 1;
                else
                    next_q[index] = 0;
            end
        end
    end

endmodule

/*
Illegal Assignment: Incorrectly assigning values to integer variables
*/

/*
Status: Error running testbench

Fail Messages:The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:
VCD info: dumpfile wave.vcd opened for output.
Hint: The first test case is a blinker (initial state = 256'h7). First mismatch occurred at cycle 2.
Hint:
Hint: Cycle 2:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:
Hint:

Hint: Cycle 3:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000111
Hint:
Hint:

Hint: Cycle 4:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:
Hint:

Hint: Cycle 5:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000111
Hint:
Hint:

Hint: The second test case is a glider (initial state = 256'h000200010007). First mismatch occurred at cycle 2.
Hint:
Hint: Cycle 2:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000101
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000011
Hint:
Hint:

Hint: Cycle 3:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000011
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000001
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000101
Hint:
Hint:

Hint: Cycle 4:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000011
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000010
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      1000000000000001
Hint:
Hint:

Hint: Cycle 5:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      1000000000000011
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000001
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      1000000000000000
Hint:
Hint:

Hint: Cycle 6:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      1000000000000001
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000001
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      1000000000000010
Hint:
Hint:

Hint: Cycle 7:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      1000000000000010
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      1000000000000001
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      1000000000000000
Hint:
Hint:

Hint: Cycle 8:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      1100000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      1000000000000001
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000001
Hint:
Hint:

Hint: Cycle 9:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0100000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      1100000000000001
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      1000000000000000
Hint:
Hint:

Hint: Cycle 10:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0100000000000001
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      1100000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      1000000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 11:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0100000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0100000000000001
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      1100000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 12:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      1000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0110000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      1100000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 13:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0100000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0010000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      1110000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 14:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      1010000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0110000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0100000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 15:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0010000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      1010000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0110000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 16:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0100000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0011000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0110000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 17:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0010000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0001000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0111000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 18:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0101000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0011000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0010000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

Hint: Cycle 19:         Your game state       Reference game state
Hint:   q[255:240]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[239:224]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[223:208]     xxxxxxxxxxxxxxxx      0001000000000000
Hint:   q[207:192]     xxxxxxxxxxxxxxxx      0101000000000000
Hint:   q[191:176]     xxxxxxxxxxxxxxxx      0011000000000000
Hint:   q[175:160]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[159:144]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[143:128]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[127:112]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[111: 96]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 95: 80]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 79: 64]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 63: 48]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 47: 32]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 31: 16]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:   q[ 15:  0]     xxxxxxxxxxxxxxxx      0000000000000000
Hint:
Hint:

./execute_environment/testbench.sv:96: $finish called at 25116 (1ps)
Hint: Output 'q' has 5008 mismatches. First mismatch occurred at time 20.
Hint: Total mismatched samples is 5008 out of 5023 samples

Simulation finished at 25116 ps
Mismatches: 5008 in 5023 samples

*/