`define half_cycle 10
module tb_uart_baud_clkgen;
logic i_rst,i_clk;
logic [15 : 0]  cfg_div_ratio;
logic  o_baud_clk;

uart_baud_clkgen  uart_baud_clkgen1(
        .i_rst,
		.i_clk,
		.cfg_div_ratio,
		.o_baud_clk
		);

initial
  begin
    i_clk = 0;
	forever #`half_cycle i_clk = ~i_clk;
  end
  
initial
  begin
    i_rst = 0;
	repeat(2) @(negedge i_clk);
	i_rst = 1;
	repeat(2) @(negedge i_clk);
	i_rst = 0;
  end
  
 initial
   cfg_div_ratio = 16'b0000_0000_0000_0110;
   
   
initial
   begin
   repeat(30)  @(posedge i_clk);
   $stop;
   end
   
   
endmodule