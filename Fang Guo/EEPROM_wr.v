`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 09:22:20
// Design Name: 
// Module Name: EEPROM_wr
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


module EEPROM_wr(
input scl,
inout sda
    );
 reg [7 : 0] sda_buf;
 reg [7 : 0] memory[1024 : 0];  
 reg sda_buf_en;
 reg [7 : 0] dev_addr;
 reg [7 : 0] word_addr;
 reg r_ack;
 integer i,j,k;
 
 assign sda = sda_buf_en ? sda_buf[7] : 1'bz;

initial
  begin
    sda_buf_en = 0;
  end



 
always@(negedge sda)
  if(scl)
    begin
    for(i = 8; i > 0; i = i - 1 ) //receive dev_addr  
    begin
      @(posedge scl);
      dev_addr[i] = sda;     
    end
    
    
    begin
      @(negedge scl);//generate ack or nack signal
      if(dev_addr == 8'b10101101)
      begin
      sda_buf[7] = 0;
      sda_buf_en = 1;
      end else begin
      sda_buf[7] = 1;
      sda_buf_en = 1;
      end
      @(negedge scl);
      sda_buf_en = 0;
      end     
    
    
    for(j = 8; j > 0 ; j= j - 1)//receive word addr
      begin
      @(posedge scl);
      word_addr[j] = sda;
      end
      
      begin //generate ack or nack signal
      @(negedge scl);
      sda_buf[7] = 0;
      sda_buf_en = 1;
      @(negedge scl);
      sda_buf_en = 0;
      end
      
      begin
      sda_buf = memory[word_addr];
      sda_buf_en = 1;
      end
      
          for(k =0; k < 7; k = k + 1)
          begin
          @(negedge scl);
          sda_buf_en = 1;
          sda_buf = sda_buf << 1;    
          end
      
      begin    
      @(negedge scl);
      sda_buf_en = 0;
      @(posedge scl);
      r_ack = sda;
      if(r_ack == 0)
      begin
        $display("successful");
      end else begin
        $display("not successful");
      end
      end
      
      begin
      @(posedge sda);
      if(scl)
        $display("stop successfully");
      else 
        $display("stop unsuccefully");
      end              
    end  
endmodule
