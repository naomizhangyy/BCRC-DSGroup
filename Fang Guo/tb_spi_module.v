`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/23 14:04:11
// Design Name: 
// Module Name: tb_spi_module
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


module tb_spi_module;
reg i_clk,i_rst,i_tx_en,i_rx_en;
reg i_spi_miso;

wire o_tx_done,o_rx_done;
wire o_spi_cs,o_spi_sck,o_spi_mosi;
wire [3 : 0] state; 
reg [7 : 0] i_data_in;
wire [7 : 0] o_data_out;
reg buf_psr_w,buf_psr_r,out_buf_w,out_buf_r;
wire o_busy;
wire [7 : 0] sspsr;

initial
  begin
    i_clk = 0;
    i_rst = 1;
    #2 i_rst = 0;
    #2 i_rst = 1;
  end

always  #1 i_clk = ~i_clk;

initial
  begin
    i_tx_en = 1;
    i_rx_en = 1;
  end

//initial
 // begin
    always #2  i_spi_miso = {$random}%2;
//  end

initial
  begin
    #3 out_buf_w = 1;
    #1 i_data_in = 8'b10101111;
    #1 buf_psr_w = 1;
       out_buf_w = 0;
    #2 //i_tx_en = 1;         
    #1  buf_psr_w = 0;
    #1 ;//i_tx_en = 0;
    #18 buf_psr_r = 1;
    #2  buf_psr_r = 0;
    #1  out_buf_r = 1;  
    #2 out_buf_r = 0;
       out_buf_w = 1;
       
    #2 out_buf_w = 0;
       i_data_in = 8'b00101001;
  end



spi_module spi_module1(
.i_clk(i_clk),
.i_rst(i_rst),
.i_tx_en(i_tx_en),
.i_rx_en(i_rx_en),
.i_data_in(i_data_in),
.i_spi_miso(i_spi_miso),
.buf_psr_w(buf_psr_w),
.buf_psr_r(buf_psr_r),
.out_buf_w(out_buf_w),
.out_buf_r(out_buf_r),
.o_data_out(o_data_out),
.o_tx_done(o_tx_done),
.o_rx_done(o_rx_done),
.o_spi_sck(o_spi_sck),
.o_spi_cs(o_spi_cs),
.o_spi_mosi(o_spi_mosi),
.state(state),
.o_busy(o_busy),
.sspsr(sspsr)
);
endmodule
