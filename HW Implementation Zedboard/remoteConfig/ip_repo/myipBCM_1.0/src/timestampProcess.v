`timescale 1ns / 1ps

module timestampProcess(
    input [7:0] timestamp_in,
    input clk,
    input reset_in,
    output reg timeup_out,
    output reg [7:0] ticker
    );
     
    //new implementation using clock divider
    reg[31:0] counter=32'd0;
    localparam DIVISOR = 50000000;
    reg clock_out;
    // The frequency of the output clk_out
    //  = The frequency of the input clk_in divided by DIVISOR
    // For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
    // You will modify the DIVISOR parameter value to 28'd50.000.000
    // Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
    always @(posedge clk, posedge reset_in)
    begin
     if (reset_in == 1'b1)
        counter <= 32'b0;
     else if (counter == DIVISOR - 1)
        counter <= 32'd0;
     else
        counter <= counter + 1;
    end
        
    always @(posedge clk, posedge reset_in)
        begin
         if (reset_in == 1'b1)
            clock_out <= 1'b0;
         else if (counter == DIVISOR - 1)
            clock_out <= ~clock_out;
         else
            clock_out <= clock_out;
        end
    
    //this is active low reset
    always @ (posedge clock_out, posedge reset_in)
    begin
    if (reset_in == 1'b1)
       ticker <= timestamp_in;
    else if (ticker != 0)
       begin
       ticker <= ticker - 1'b1;
       timeup_out <= 1;
       end
    else
       timeup_out <= 0;
    end     
endmodule