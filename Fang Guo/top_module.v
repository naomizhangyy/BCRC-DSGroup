`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/24 19:11:57
// Design Name: 
// Module Name: top_module
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


module top_module;
reg i_clk;
reg i_rst;
wire sda;
wire scl;
reg [7 : 0] data;
reg [6 : 0] dev_addr;
reg [7 : 0] word_addr;
reg master_rece_go;

initial
  begin
    i_clk <= 0;
    i_rst <= 1;
    #2 i_rst = 0;
    #2 i_rst = 1;
  end
    
    always #1 i_clk = ~i_clk;// generate clock
    
  initial
    begin
      data = 8'b11011011;
      dev_addr = 7'b1000111;
      word_addr = 8'b00001111;
      master_rece_go = 1'b1;
    end
    
    
EEPROM_wr EEPROM_wr1(
.scl(scl),
.sda(sda)
);

master_rece master_rece1(
.i_clk(i_clk),
.i_rst(i_rst),
.sda(sda),
.scl(scl),
.data(data),
.dev_addr(dev_addr),
.word_addr(word_addr),
.master_rece_go(master_rece_go)
);



endmodule
