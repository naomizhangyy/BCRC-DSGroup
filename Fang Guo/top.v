`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 15:23:24
// Design Name: 
// Module Name: top
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


module top;
wire sclk,rst;
wire [3 : 0] Data;
wire ack;
wire sda,scl;
wire [3 : 0] state,reg_data;
wire [15 : 0] outhigh;
wire [5 : 0] mstate;
wire StartFlag;


M0 M01(
.rst(rst),
.sclk(sclk),
.Data(Data),
.ack(ack)
);

M1 M11(
.Data(Data),
.rst(rst),
.sclk(sclk),
.ack(ack),
.sda(sda),
.scl(scl),
.state(state),
.reg_data(reg_data)
);

M2 M21(
.sda(sda),
.scl(scl),
.outhigh(outhigh),
.mstate(mstate),
.StartFlag(StartFlag),
.EndFlag(EndFlag),
.rst(rst)
);
endmodule
