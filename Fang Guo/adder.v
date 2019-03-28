`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/24 21:12:33
// Design Name: 
// Module Name: adder
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


module adder(
    input [3 : 0] X,
    input [3 : 0] Y,
    input Cin,
    output wire [3 : 0] sum,
    output wire Cout
    );
    assign {Cout,sum} = X + Y + Cin;
endmodule
