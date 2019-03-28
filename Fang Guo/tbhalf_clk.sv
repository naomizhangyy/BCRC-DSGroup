`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/26 19:39:17
// Design Name: 
// Module Name: tbhalf_clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define half_clk_cycle 50

module tbhalf_clk;
    logic clk_in,reset;
    wire clk_out;
    
    always  #`half_clk_cycle  clk_in = ~clk_in;
    
    initial
        begin
          clk_in = 0;
          reset = 1;
          #10 reset = 0;
          #110 reset = 1;
          #100000 $stop;
        end
    half_clk  half_clk1(.reset(reset),.clk_in(clk_in),.clk_out(clk_out));
    
endmodule
