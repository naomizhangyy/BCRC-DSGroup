`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/07 14:51:10
// Design Name: 
// Module Name: IIC_transmitter
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


module IIC_transmitter(
input i_clk,
input i_rst_n,
input i_iic_send_en,
input [6 : 0] i_dev_addr,
input [7 : 0] i_word_addr,
input [7 : 0] i_write_data,
output o_done_flag,
output [3 : 0] r_state,
inout sda,
output scl
    );
    
reg [7 : 0] r_load;
//reg [7 : 0] word_addr;
//reg [7 : 0] write_data;
reg r_sda;
reg r_scl;
reg scl_en;//if scl_en == 1, the scl is linked,scl_en = 0,the scl is not linked
reg [3 : 0] r_state;
reg [3 : 0] r_jump_state;
wire sda_mode;//when sda_mode = 1, the sda is output and sda_mode = 0, the sda is input 
reg o_done_flag;
reg [3 : 0] r_bit_cnt;
reg r_ack_flag;
wire scl;

assign scl = r_scl;

assign sda = (sda_mode == 1) ? r_sda : 1'bz; 

assign sda_mode = (r_state == 4'd6) ? 0 : 1;

always@(negedge i_clk or negedge i_rst_n)
  if(!i_rst_n)
    r_scl <= 1;
  else if(scl_en == 1)
    r_scl = ~r_scl;
  else
    r_scl = 1;
        
 always@(posedge i_clk or negedge i_rst_n)
   if(!i_rst_n)  begin
    // sda_mode <= 1'b1;
     r_sda <= 1'b1;
     scl_en <= 1'b0;
     r_state <= 4'd0;
     o_done_flag <= 1'b0;  
     r_bit_cnt <= 3'd0;
     r_ack_flag <= 1'b0;
     r_jump_state <= 4'd0;
   end else begin
     if(i_iic_send_en == 1) begin
     case(r_state)
       4'd0://设置状态为空闲状态
         begin
          // sda_mode <= 1'b1;
           r_sda <= 1'b1;
           r_ack_flag <= 1'b0;
           scl_en <= 1'b0;
           r_state <= 4'd1;
           o_done_flag <= 1'b0;
           r_bit_cnt <= 3'b0;
           r_jump_state <= 4'd0;
         end
       4'd1://设置状态为加载设备地址
         begin
           r_load <= {i_dev_addr,1'b0};
           r_state <= 4'd4;   
           r_jump_state <= 4'd2;     
         end
       4'd2://设置状态为加载字地址
         begin
           r_load <= i_word_addr;
           r_state <= 4'd5;  
           r_jump_state <= 4'd3;      
         end
       4'd3://设置状态为加载要发送的数据
         begin
           r_load <= i_write_data;
           r_state <= 4'd5;
           r_jump_state <= 4'd8;
         end
       4'd4://设置状态为发送起始信号
         begin
           scl_en <= 1'b1;
        //   sda_mode <= 1'b1;
           if(scl) begin
             r_sda <= 1'b0;
             r_state <= 4'd5;
           end else begin
             r_state <= 4'd4;
           end
         end
       4'd5://设置状态为发送1个字节，从高位开始发送
         begin
           scl_en <= 1'b1;
          // sda_mode <= 1'b1;
           if(!scl) begin
             if(r_bit_cnt == 4'd8) begin
             r_state <= 4'd6;
             r_bit_cnt <= 4'd0;
             end else begin
             r_sda <= r_load[7 - r_bit_cnt];
             r_bit_cnt <= r_bit_cnt + 4'd1;   
             r_state <= 4'd5;         
           end
          end else begin
            r_state <= 4'd5;
          end
         end
       4'd6://设置状态为接受应答状态
         begin
           scl_en <= 1'b1;
          // sda_mode <= 1'b0;
           if(scl) begin
             r_ack_flag <= sda;
             r_state <= 4'd7;
           end else begin
             r_state <= 4'd6;
           end        
         end
       4'd7://设置状态为检验应答状态
         begin
           scl_en <= 1'b1;
           if(r_ack_flag == 1'b0) begin
           if(!scl) begin
             r_state <= r_jump_state;            
             //sda_mode <= 1'b1;
             r_sda <= 1'b0; 
           end else begin
             r_state <= 4'd7;
           end
          end  else begin
            r_state <= 4'd0;
          end      
         end
       4'd8://设置状态为发送停止信号
         begin
           scl_en <= 1'b1;
           //sda_mode <= 1'b1;
           if(scl) begin
             r_sda <= 1'b1;
             r_state <= 4'd9;
           end else begin
             r_state <= 4'd8;
           end           
         end
        4'd9://是指状态为停止操作
          begin
           // sda_mode <=1'b1;
            r_sda <= 1'b1;
            scl_en <= 1'b0;
            o_done_flag <= 1'b1;
            r_state <= 4'd0;
            r_jump_state <= 4'd0;                  
          end
        default: r_state <= 4'd0;      
     endcase 
   end else begin
     scl_en <= 1'b0;
     //sda_mode <= 1'b1;
     r_sda <= 1'b1;
     o_done_flag <= 1'b0;
     r_state <= 4'd0;
     r_bit_cnt <= 4'd0;
     r_ack_flag <= 1'b0;
     r_jump_state <= 4'd0;
   end
   end
   
     
endmodule
