`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/26 19:34:02
// Design Name: 
// Module Name: half_clk
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


module half_clk(
    input reset,
    input clk_in,
    output clk_out
    );
    logic clk_out;
    always @(posedge clk_in,negedge reset)
        begin
          if(!reset)  clk_out = 0;
          else if(clk_in) 
          clk_out <= ~clk_out;
        end   
endmodule
