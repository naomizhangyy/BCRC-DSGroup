module tb_uart_rxd_if;
logic i_clk,i_rst,i_uart_clk,i_rxd_fifo_wr,i_error_clr,i_rd;
logic [9 : 0] i_rxd_fifo_wdata;
logic  o_busy,o_rxd_fifo_wfull;
logic [31 : 0] o_rdata;
logic [1 : 0] o_error;

initial
  begin
   i_clk = 0;
   forever #1 i_clk = ~i_clk;
  end
  
  initial
    begin
	i_uart_clk = 0;
	forever #4 i_uart_clk = ~i_uart_clk;
	end
  initial
    begin
	  i_rst = 0;
	  #2 i_rst = 1;
	  #2 i_rst = 0;
	end
	
	initial
	  begin 
	    i_rxd_fifo_wr = 1;
		i_error_clr = 1;
		i_rd = 1;
		i_rxd_fifo_wdata = 10'b00_1001_0011;
	  end
	  
	uart_rxd_if uart_rxd_if1(
	.i_clk,
	.i_rst,
	.o_rdata,
	.i_rd,
	.o_busy,
	.o_error,
	.i_error_clr,
	.i_uart_clk,
	.i_rxd_fifo_wr,
	.i_rxd_fifo_wdata,
	.o_rxd_fifo_wfull
	
	
	
	);
	endmodule
	