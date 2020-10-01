`timescale 1ns / 1ps

module hcmProcess(
    input [7:0] configs_in,
    input clk,
    input reset_in,
    input timeup_in,
    input [127:0] out,
    output reg [7:0] leds,
    output reg [63:0] state_out,
    output reg [1:0] aes_out,
    output [127:0] config_enc
    );
    
    //reg pipeline;
    
    always @(posedge clk, posedge reset_in)
    begin
        if (reset_in == 1'b1)
        begin
            aes_out <= 2'b00;
            state_out <= 64'd0;
        end
        else if (aes_out == 2'b01)
            state_out <= 64'd0;
        else if (aes_out == 2'b10)
            aes_out <= aes_out + 1;
        else if (aes_out == 2'b11)
            aes_out <= aes_out - 1;
        else 
            aes_out <= aes_out + 1;
    end
    
    always @(timeup_in)
    if (timeup_in == 1)
        leds <= configs_in[7:0];
    else if (timeup_in == 0)
        leds <= 8'b00000000;
    else 
        leds <= 8'b11111111;
                
    assign config_enc = {120'd0, configs_in} ^ out;
endmodule
