`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/07 18:50:23
// Design Name: 
// Module Name: tb_IIC_transmitter
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


module tb_IIC_transmitter;
reg i_clk;
reg i_rst_n;
reg i_iic_send_en;
reg [6 : 0] i_dev_addr;
reg [7 : 0] i_word_addr;
reg [7 : 0] i_write_data;
reg sda1;
wire sda2;
reg link_sda;
wire [3 : 0] r_state;
wire o_done_flag;
wire sda;
wire scl;

initial
  begin
    i_iic_send_en = 1;
    i_dev_addr = 7'b1010111;
    i_word_addr = 8'b11101010;
    i_write_data = 8'b11100011;
  end 
  
initial
  begin
    i_clk = 0;
    forever #1 i_clk = ~i_clk;
  end

initial
  begin
    i_rst_n = 1;
    #2 i_rst_n = 0;
    #2 i_rst_n = 1;
  end

initial
  begin
        link_sda=0;
        sda1 = 1;
    #43 link_sda = 1;
        sda1 = 0;
    #2  link_sda = 0;  
        sda1 = 1;
    #38 link_sda = 1;
        sda1 = 0;
    #2  link_sda = 0;
        sda1 = 1;
    #38 link_sda = 1;
        sda1 = 0;
    #2  link_sda = 0;
        sda1 = 1;
  end

assign sda = (link_sda == 1) ? sda1 : 1'bz;
assign sda2 = sda;


IIC_transmitter M1(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_iic_send_en(i_iic_send_en),
.i_dev_addr(i_dev_addr),
.i_word_addr(i_word_addr),
.i_write_data(i_write_data),
.r_state(r_state),
.o_done_flag(o_done_flag),
.sda(sda),
.scl(scl)
);  
  
  
  
endmodule
