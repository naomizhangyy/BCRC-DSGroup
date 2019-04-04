`define half_i_clk 1
`define half_i_uart_clk 5
module tb_uart_txd_if;
logic          i_clk,i_rst,i_wr,o_busy,i_uart_clk,i_txd_fifo_rd;
logic [31 : 0] i_wdata;
wire  [7 : 0]  o_txd_fifo_rdata;
wire  [31 : 0] o_rdata;
wire  o_txd_fifo_rempty;


initial
  begin
    i_clk = 0;
    forever #`half_i_clk i_clk = ~i_clk;
  end
  
initial
  begin
    i_uart_clk = 0;
	forever #`half_i_uart_clk i_uart_clk = ~i_uart_clk;
  end
  
initial
  begin
    i_rst = 0;
	#2 i_rst = 1;
	#2 i_rst = 0;
  end
  
initial 
 begin
   i_wr = 1;
   i_txd_fifo_rd =1;
   i_wdata = 32'h1_2_3_4_5_6_7_8;
 end
 
uart_txd_if uart_txd_if1(
  .i_clk,
  .i_rst,
  .i_wdata,
  .o_rdata,
  .i_wr,
  .o_busy,
  .i_uart_clk,
  .i_txd_fifo_rd,
  .o_txd_fifo_rdata,
  .o_txd_fifo_rempty
);
endmodule

