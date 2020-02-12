`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// 
// Create Date: 2019/10/15 11:00:27
// Design Name: sDavinci
// Module Name: cmp_unit
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Delay time = 0;
//////////////////////////////////////////////////////////////////////////////////

module cmp_unit
#(parameter DATA_WID=16)
    (
    input clock,
    input rst_n,
    input signed [DATA_WID-1:0] weight,
    input signed [DATA_WID-1:0] pixel,
    
    output [2*DATA_WID-1:0] psum_out
);

mult_gen_0 mult16(
    .CLK(clock),
    .A(weight),
    .B(pixel),
    .P(psum_out)
);

endmodule