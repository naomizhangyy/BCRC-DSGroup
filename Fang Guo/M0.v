`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/22 15:30:49
// Design Name: 
// Module Name: M0
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


`define halfperiod 1

module M0(
output rst,sclk,
output [3 : 0] Data,
//output [3 : 0] state,reg_data,
input ack
);

reg sclk,rst;
reg [3 : 0] Data;
wire ack;//sda,scl;
wire [3 : 0] state,reg_data;
initial
  begin
    rst = 1;
    #2 rst = 0;
    #(`halfperiod*2 + 2) rst = 1;
  end
  
initial
  begin
    sclk = 0;
    Data = 4'b0000;
    #(`halfperiod*1000) $stop;
  end
   always #(`halfperiod) sclk = ~sclk;
 always@(posedge ack)
   begin
     Data = Data + 1;
   end
  /* M1 M11(
   .rst(rst),
   .sclk(sclk),
   .Data(Data),
   .ack(ack),
   .sda(sda),
   .scl(scl),
   .state(state),
   .reg_data(reg_data)
   );*/
endmodule