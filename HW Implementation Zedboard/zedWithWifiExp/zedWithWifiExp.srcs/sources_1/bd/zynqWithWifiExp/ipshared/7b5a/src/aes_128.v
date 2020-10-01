`timescale 1ns / 1ps

module aes_128(clk, reset_in, state_in, aes_in, out);
    input  clk;
    input reset_in;
    input  [63:0] state_in;
    input [1:0] aes_in;
    output [127:0] out;
    reg [127:0] state;
    reg aes_start;
    reg    [127:0] key;
    reg    [127:0] s0, k0;
    wire   [127:0] s1, s2, s3, s4, s5, s6, s7, s8, s9,
                   k1, k2, k3, k4, k5, k6, k7, k8, k9,
                   k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8b, k9b;

    initial key = 128'h11111111111111111111111111111111;
    
    always @(posedge clk, posedge reset_in)
        begin
         if (reset_in == 1'b1)
            aes_start <= 0;
        end
    
    always @ (posedge clk)
    begin
        if (aes_in == 2'b00)
            state[63:0] = state_in;
        else if (aes_in == 2'b01)
            state[127:64] = state_in;
            aes_start <= 1;
    end

    always @ (posedge clk)
    if (aes_start == 1)
      begin
        s0 <= state ^ key;
        k0 <= key;
      end
      


    expand_key_128
        a1 (clk, aes_start, k0, k1, k0b, 8'h1),
        a2 (clk, aes_start, k1, k2, k1b, 8'h2),
        a3 (clk, aes_start, k2, k3, k2b, 8'h4),
        a4 (clk, aes_start, k3, k4, k3b, 8'h8),
        a5 (clk, aes_start, k4, k5, k4b, 8'h10),
        a6 (clk, aes_start, k5, k6, k5b, 8'h20),
        a7 (clk, aes_start, k6, k7, k6b, 8'h40),
        a8 (clk, aes_start, k7, k8, k7b, 8'h80),
        a9 (clk, aes_start, k8, k9, k8b, 8'h1b),
       a10 (clk, aes_start, k9,   , k9b, 8'h36);

    one_round
        r1 (clk, aes_start, s0, k0b, s1),
        r2 (clk, aes_start, s1, k1b, s2),
        r3 (clk, aes_start, s2, k2b, s3),
        r4 (clk, aes_start, s3, k3b, s4),
        r5 (clk, aes_start, s4, k4b, s5),
        r6 (clk, aes_start, s5, k5b, s6),
        r7 (clk, aes_start, s6, k6b, s7),
        r8 (clk, aes_start, s7, k7b, s8),
        r9 (clk, aes_start, s8, k8b, s9);

    final_round
        rf (clk, aes_start, s9, k9b, out);
endmodule

module expand_key_128(clk, aes_start, in, out_1, out_2, rcon);
    input              clk;
    input aes_start;
    input      [127:0] in;
    input      [7:0]   rcon;
    output reg [127:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3,
                       v0, v1, v2, v3;
    reg        [31:0]  k0a, k1a, k2a, k3a;
    wire       [31:0]  k0b, k1b, k2b, k3b, k4a;

    assign {k0, k1, k2, k3} = in;
    
    assign v0 = {k0[31:24] ^ rcon, k0[23:0]};
    assign v1 = v0 ^ k1;
    assign v2 = v1 ^ k2;
    assign v3 = v2 ^ k3;

    always @ (posedge clk)
        if (aes_start == 1)
        {k0a, k1a, k2a, k3a} <= {v0, v1, v2, v3};

    S4
        S4_0 (clk, aes_start, {k3[23:0], k3[31:24]}, k4a);

    assign k0b = k0a ^ k4a;
    assign k1b = k1a ^ k4a;
    assign k2b = k2a ^ k4a;
    assign k3b = k3a ^ k4a;

    always @ (posedge clk)
    if (aes_start == 1)
        out_1 <= {k0b, k1b, k2b, k3b};

    assign out_2 = {k0b, k1b, k2b, k3b};
endmodule

