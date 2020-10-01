`timescale 1ns / 1ps

module bcmProcess(
    input [16:0] configtime,
    output reset_out,
    output [7:0] configs_out,
    output [7:0] timestamp_out
    );
    
    assign reset_out = configtime[16];
    assign configs_out = configtime[15:8];
    assign timestamp_out = configtime[7:0];
endmodule
