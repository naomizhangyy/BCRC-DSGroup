`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/08 19:25:26
// Design Name: 
// Module Name: tb_IIC_recv_
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


module tb_IIC_recv_;
reg i_clk;
reg i_rst_n;
reg i_iic_recv_en;
reg link_sda;
reg [6 : 0] i_dev_addr;
reg [7 : 0] i_word_addr;
wire sda1;
reg sda2;
wire o_done_flag;
wire [7 : 0] o_read_data;
wire sda;
wire scl;
wire [3 : 0] r_state;

initial
  begin
    i_iic_recv_en = 1'b1;
    i_dev_addr = 7'b1101101;
    i_word_addr = 8'b11101001;
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
    sda2 = 1'b0;
    link_sda = 0;
    #43 link_sda = 1;
    #2 link_sda = 0;
    #38 link_sda = 1;
    #2 link_sda = 0;
    #42  link_sda = 1;
    #2  link_sda = 0;
    #2  link_sda = 1;
        sda2 = 1'b1;
    #4  sda2 = 1'b1;
    #4 sda2 = 1'b1;
    #4 sda2 = 1'b0;
    #4 sda2 = 1'b1;
    #4 sda2 = 1'b0;
    #4 sda2 = 1'b0;
    #4 sda2 = 1'b1;
    #4;
    #2 sda2 = 1'b1;
       link_sda = 1'b0;    
  end
 
assign sda = (link_sda == 1) ? sda2 : 1'bz;
assign sda1 = sda ;

IIC_recv_ IIC_recv_1(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_iic_recv_en(i_iic_recv_en),
.i_dev_addr(i_dev_addr),
.i_word_addr(i_word_addr),
.o_done_flag(o_done_flag),
.o_read_data(o_read_data),
.sda(sda),
.scl(scl),
.r_state(r_state)
);

endmodule
