`timescale 1ns/1ps


`define  half_clk_cycle 1


module  tb_uart_txd;


logic [1 : 0] i_cfg_txd_sample,i_cfg_txd_parity;
logic         i_cfg_txd_stop,i_enable,i_fifo_notempty,i_rst,i_uart_clk;
logic [7 : 0] i_fifo_data;
wire          o_txd,o_fifo_rd;
    
	
initial
  begin
    i_uart_clk = 0;
    forever  #`half_clk_cycle  i_uart_clk = ~i_uart_clk;//generate test clock
  end
  

initial
  begin
    i_cfg_txd_parity = 2'b10;//even check
	i_cfg_txd_sample = 2'b00;//sample rate = 8
	i_cfg_txd_stop = 1'b0;//stop bit = 1
	i_enable = 1'b1;
	i_fifo_notempty = 1'b1;
	i_fifo_data = 8'b01001011;
  end
 
initial
  begin
       i_rst = 0;
    #4 i_rst = 1;	
    #2 i_rst = 0;
  end
  
  

uart_txd  uart_txd1(
    .i_rst,
	.i_uart_clk,
	.o_txd,
	.i_enable,
	.i_fifo_notempty,
	.i_fifo_data,
	.o_fifo_rd,
	.i_cfg_txd_sample,
	.i_cfg_txd_parity,
	.i_cfg_txd_stop	
  );

endmodule





