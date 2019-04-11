module tb_uart_rxd;
  logic [1 : 0] i_cfg_rxd_parity,i_cfg_rxd_sample;
  logic i_cfg_rxd_stop;
  logic i_enable,i_fifo_notfull;
  logic i_uart_clk,i_rxd,i_rst;
  wire [1 : 0] o_error;
  wire       o_fifo_wr;
  wire [7 : 0] o_fifo_data;
  
  initial
    begin
	 i_cfg_rxd_parity = 2'b10;
	 i_cfg_rxd_sample = 2'b00;
	 i_cfg_rxd_stop = 1'b0;
	 i_enable = 1'b1;
	 i_fifo_notfull = 1'b1;
	end
	
   initial
     begin 
	   i_rst = 0;
	   #2 i_rst = 1;
	   #2 i_rst = 0;
	 end
	 
	 initial
	 begin
	   i_uart_clk = 0;
	   forever #1 i_uart_clk = ~i_uart_clk;
	 end
	 
	 initial
	  begin
	    i_rxd = 1'b1;
		#8 i_rxd = 1'b0;
		#16 i_rxd = 1'b1;
		#16 i_rxd = 1'b1;
		#16 i_rxd = 1'b0;
		#16 i_rxd = 1'b1;
		#16 i_rxd = 1'b1;
		#16 i_rxd = 1'b0;
		#16 i_rxd = 1'b1;
		#16 i_rxd = 1'b0;
		#16 i_rxd = 1'b1;
		#16 i_rxd = 1'b1;
		#16 $stop;
		
		uart_rxd uart_rxd1(
.i_rst,
.i_uart_clk,
.i_rxd,
.i_enable,
.o_fifo_data,
.o_fifo_wr,
.i_fifo_notfull,
.o_error,
.i_cfg_rxd_parity,
.i_cfg_rxd_sample,
.i_cfg_rxd_stop						 
		
		
		
		);
		
		
		endmodule