`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 20:52:26
// Design Name: 
// Module Name: spi_module
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


module spi_module(
input i_clk,
input i_rst,
input i_tx_en,
input i_rx_en,
input [7 : 0] i_data_in,
input i_spi_miso,
input buf_psr_w,//control data write from sspbuf to sspsr
input buf_psr_r,//control data read from sspsr to sspbuf
input out_buf_w,//control data write from outside to sspbuf
input out_buf_r,//control data read from sspbuf to outside
output [7 : 0]  o_data_out,
output o_tx_done,
output o_rx_done,
output o_spi_sck,
output o_spi_cs,
output o_spi_mosi,
output [3 : 0] state,
output o_busy,
output [7 : 0] sspsr
);

parameter idle = 4'b1000,
            bit7 = 4'b0111,
            bit6 = 4'b0110,
            bit5 = 4'b0101,
            bit4 = 4'b0100,
            bit3 = 4'b0011,
            bit2 = 4'b0010,
            bit1 = 4'b0001,
            bit0 = 4'b0000;
            
reg [7 : 0] sspsr;
reg [3 : 0] state,next_state;
reg o_spi_cs,o_tx_done,o_rx_done;
reg [7 :0] sspbuf;
reg [7 : 0] o_data_out;
reg o_spi_cs_next;
reg pul_detector;

assign o_spi_sck = i_clk;

//-------------------assign number for sspbuf-----------------------------------------
always@(posedge i_clk or negedge i_rst)
  if(!i_rst)
    sspbuf <= 8'b0;
  else if(out_buf_w || out_buf_r )  begin//question how to write verilog code that once the state enter the idle,only after the out_buf_w pulse,the state will come out of the idle state 
    sspbuf <= out_buf_w ? i_data_in : sspbuf;
    o_data_out <= out_buf_r ? sspbuf : 8'b0;
  end
  
//----------------------------------------state switch--------------------------------
always@(posedge i_clk or negedge i_rst)
  if(!i_rst) begin
    state <= idle;
  end else begin
    state <= next_state;
  end
always@(state or i_tx_en or buf_psr_w or buf_psr_r or i_rx_en)
  case(state)
    idle : 
      if(pul_detector || buf_psr_r) begin
        next_state = idle;
        o_spi_cs_next = 1'b1;
      end else if(i_tx_en || i_rx_en) begin
       // o_spi_cs = 0;
        next_state = bit7;
        o_spi_cs_next = 0;
      end  else begin
        next_state = idle;
        o_spi_cs_next = 1'b1;
      end
    bit7 : begin
             next_state = bit6;
             o_spi_cs_next = 0;
           end
    bit6 : begin 
             next_state = bit5;
             o_spi_cs_next = 1'b0;
           end 
    bit5 : begin
             next_state = bit4;
             o_spi_cs_next = 1'b0;
           end
    bit4 : begin
             next_state = bit3;
             o_spi_cs_next = 1'b0;
           end
    bit3 : begin
             next_state = bit2;
             o_spi_cs_next = 1'b0;
           end
    bit2 : begin
             next_state = bit1;
             o_spi_cs_next = 1'b0;
           end
    bit1 : begin
             next_state = bit0;
             o_spi_cs_next = 1'b0;
           end
    bit0 : begin
             next_state = idle;
             o_spi_cs_next = 1'b1;
           end 
    default : state = 4'bxxxx; 
   endcase
  //------------------------------------------------------------------------------------- 

 //---------------------------------------generate done signal----------------------------   
always@(state or i_tx_en or i_rx_en)//generate done signal
  if(!i_rst) begin
    o_tx_done = 0;
    o_rx_done = 0;
  end else  begin
    o_tx_done = (i_tx_en && state == bit0) ? 1 : 0 ;
    o_rx_done = (i_rx_en && state == bit0) ? 1 : 0 ;
  end
   //---------------------------------------------------------------------------------------   
   
 //------------------------------------generate shift register---------------------------- 
always@(posedge i_clk or negedge i_rst )  //shift register will shift at this condition  
  if(!i_rst)
    sspsr <= 8'b00000000;
  else if((buf_psr_w || buf_psr_r) && state == idle)  begin
    sspsr <= buf_psr_w ? sspbuf : sspsr;
    sspbuf <= buf_psr_r ? sspsr : sspbuf;
  end else if((i_tx_en || i_rx_en) && state != idle)  begin                 //&& state == bit7)
    sspsr <= sspsr << 1;
    sspsr[0] <= i_rx_en ? i_spi_miso : 0 ;
    end
 //-----------------------------------------------------------------------------------------
    
assign o_spi_mosi = i_tx_en ? sspsr[7] : 1'bz;  //data bus to link sspsr[7] and o_spi_mosi
assign o_busy = (state !== idle) ? 1'b1 : 1'b0 ;
  
//-----------------------generate cs register-----------------------------------------------  
always@(posedge i_clk or negedge i_rst )
  if(!i_rst)
    o_spi_cs <= 1'b1;
  else 
    o_spi_cs <= o_spi_cs_next; 
//------------------------------------------------------------------------------------------- 

//-----------------------------------generate a pulse detector of out_buf_w signal-----------
always@(posedge i_clk )
  if(out_buf_w)
    pul_detector <= 1'b1;
  else
    pul_detector <= 1'b0; 
//-------------------------------------------------------------------------------------------   
 endmodule
 
 
 //assign o_spi_mosi = sspsr[7];
     
 /*always@(posedge i_clk or negedge i_rst)
   if(!i_rst)
     sspsr <= 0;
   else if(i_tx_en) begin
       sspsr <= sspsr<<1;
     end   
   else if(i_rx_en) begin
     sspsr <= sspsr << 1;
     sspsr[0] <= i_spi_miso;
     end*/
     
     
     
 
 
  //else if(i_rx_en && state == bit0)
    //o_rx_done =1;
  /*else begin
    o_tx_done = 0;
    o_rx_done = 0;*/
    
    
 
 
 /*always@(posedge i_clk)
   if(i_rx_en)
     sspsr[0] <= i_spi_miso;
   else 
     sspsr[0] <= 0;*/
     
     
     
     
 
 /*always@(i_tx_en or i_rx_en or i_rst)  //generate select chip signal
   if(!i_rst)
     o_spi_cs = 1'b1;
   else if(buf_psr_w || buf_psr_r)
     o_spi_cs = 1'b0;
   else if(i_tx_en || i_rx_en)
     o_spi_cs = 1'b0;*/
     
     
     
     
     
 /* if(i_tx_en)
    o_spi_cs = 1'b0;
  else if(i_rx_en)
    o_spi_cs = 1'b0;*/

/*always@(i_clk)
  if(state == bit0)
    begin
      if(i_tx_en)
        o_tx_done = 1;
      else if(i_rx_en)
        o_rx_done = 1;
    end*/      