`timescale 1ns / 1ps

module hcmProcess(
    input [7:0] configs_in,
    input timeup_in,
    output reg [7:0] leds
    );
    
    always @(timeup_in)
    if (timeup_in == 1)
        leds <= configs_in[7:0];
    else if (timeup_in == 0)
        leds <= 8'b00000000;
    else 
        leds <= 8'b11111111;
                
    //assign leds = timeup_in? configs_in[7:0] : 8'b00000000;
endmodule
