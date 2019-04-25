`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/21 21:08:27
// Design Name: 
// Module Name: M2
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


module M2(
input scl,sda,rst,
output [15 : 0] outhigh,
output [5 : 0] mstate,
output StartFlag,
output EndFlag
);
reg [3 : 0] pdata;
reg [3 : 0] pdatabuf;
reg StartFlag,EndFlag;
reg [5 : 0] mstate;
reg [15 : 0] outhigh;
parameter ready = 6'b00_0000,
           sbit0 = 6'b00_0001,
           sbit1 = 6'b00_0010,
           sbit2 = 6'b00_0100,
           sbit3 = 6'b00_1000;
          // sbit4 = 6'b10_0000;
           
/*always@(negedge sda or posedge scl)
  if(mstate == sbit0)
    StartFlag <= 0;
  else if (scl)
    StartFlag <= 1;*/
    
always@(negedge sda or negedge rst)
  begin
    if(!rst)
      StartFlag <= 0;
    else if(scl)
      begin
        StartFlag <= 1;
      end
   else if(EndFlag)
     StartFlag <= 0;
   end
      
always@(posedge sda or negedge rst)
  if(!rst)
    EndFlag <= 0;
  else if(scl) begin
    EndFlag <= 1;
    //pdatabuf <= pdata;
  end else if(mstate == sbit0)
    EndFlag <= 0;

always@(posedge sda)
  if(scl)
    pdatabuf <= pdata;

always@(pdatabuf)
  case(pdatabuf)
    4'b0000 : outhigh = 16'b0000_0000_0000_0001;
    4'b0001 : outhigh = 16'b0000_0000_0000_0010;
    4'b0010 : outhigh = 16'b0000_0000_0000_0100;
    4'b0011 : outhigh = 16'b0000_0000_0000_1000;
    4'b0100 : outhigh = 16'b0000_0000_0001_0000;
    4'b0101 : outhigh = 16'b0000_0000_0010_0000;
    4'b0110 : outhigh = 16'b0000_0000_0100_0000;
    4'b0111 : outhigh = 16'b0000_0000_1000_0000;
    4'b1000 : outhigh = 16'b0000_0001_0000_0000;
    4'b1001 : outhigh = 16'b0000_0010_0000_0000;
    4'b1010 : outhigh = 16'b0000_0100_0000_0000;
    4'b1011 : outhigh = 16'b0000_1000_0000_0000;
    4'b1100 : outhigh = 16'b0001_0000_0000_0000;
    4'b1101 : outhigh = 16'b0010_0000_0000_0000;
    4'b1110 : outhigh = 16'b0100_0000_0000_0000;
    4'b1111 : outhigh = 16'b1000_0000_0000_0000; 
    default : outhigh = 16'bx;
  endcase
  
always@(posedge scl or negedge rst)
  if(!rst)
    mstate <= ready;
  else  
      case(mstate)                
        ready : if(StartFlag)     
                begin             
                  mstate <= sbit0;
                  pdata[3] <= sda;
                end else          
                  mstate <= ready;  
        sbit0 : begin             
                  mstate <= sbit1;
                  pdata[2] <= sda;
                end               
        sbit1 : begin             
                  mstate <= sbit2;
                  pdata[1] <= sda;
                end               
        sbit2 : begin             
                  mstate <= sbit3;
                  pdata[0] <= sda;
                end               
        sbit3 : begin             
                  mstate <= ready;
                end               
        default : mstate <= ready;
      endcase
    

endmodule
