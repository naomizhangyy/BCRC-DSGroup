`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/08 16:16:47
// Design Name: 
// Module Name: IIC_recv_
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


module IIC_recv_(
input i_clk,
input i_rst_n,
input i_iic_recv_en,
input [6 : 0] i_dev_addr,
input [7 : 0] i_word_addr,
output o_done_flag,
output [7 : 0] o_read_data,
output scl,
inout sda,
output [3 : 0] r_state
    );

reg r_sda;//register that store sda signal
reg r_scl;//register that generate scl signal
reg r_scl_en;//enable siganl of scl register,when it == 1, the r_scl is enabled
wire link_sda;//bus sda control signal when link_sda == 1, sda is linked
reg [7 : 0] r_read_data;//register that store data read from slave 
reg [7 : 0] r_load;//register that store the data from CPU
reg o_done_flag;//the done flag
reg [3 : 0] r_bit_cnt;//the counter for transmit a Byte data
reg [3 : 0] r_state;//the register for state machine
reg [3 : 0] r_jump_state;//for state jump
reg  r_ack_flag;

assign scl = r_scl;

assign sda = (link_sda == 1) ? r_sda : 1'bz;

assign o_read_data = r_read_data;

always@(negedge i_clk or negedge i_rst_n)
  if(!i_rst_n)
    r_scl <= 1'b1;
  else if(r_scl_en)
    r_scl <= ~r_scl;
  else r_scl <= 1'b1;
  
always@(posedge i_clk or negedge i_rst_n)
  if(!i_rst_n) begin
    o_done_flag <= 1'b0;
    r_read_data <= 8'd0;
    r_sda <= 1'b1;
    r_scl <= 1'b1;
    r_scl_en <= 1'b0;
    r_state <= 4'd0;
    r_jump_state <= 4'd0;
    r_load <= 8'd0;
    r_bit_cnt <= 4'd0;
    r_ack_flag <= 1'b0;
  end else begin
    if(i_iic_recv_en) begin
      case(r_state)
      4'd0://空闲状态
        begin
          o_done_flag <= 1'b0;
            r_read_data <= 8'd0;
            r_sda <= 1'b1;
            r_scl <= 1'b1;
            r_scl_en <= 1'b0;
            r_state <= 4'd1;
            r_jump_state <= 4'd0;
            r_load <= 8'd0;
            r_bit_cnt <= 4'd0;
            r_ack_flag <= 1'b0;
        end
      4'd1://第一次加载物理设备地址
        begin
          r_state <= 4'd3;
          r_load <= {i_dev_addr,1'b0};
          r_jump_state <= 4'd2;
        end
      4'd2://加载设备的字地址
        begin
          r_state <= 4'd4;
          r_load <= i_word_addr;
          r_jump_state <= 4'd7;
        end
      4'd3://发送开始信号
        begin
          r_scl_en <= 1'b1;
          if(scl)  begin
            r_sda <= 1'b0;
            r_state <= 4'd4;
          end else 
            r_state <= 4'd3;
        end
      4'd4://发送一个字节的信号
        begin
          r_scl_en <= 1'b1;
          if(!scl) begin
          if(r_bit_cnt == 4'd8) begin
            r_bit_cnt <= 4'd0;
            r_state <= 4'd5;
          end
          else begin 
            r_sda <= r_load[7 - r_bit_cnt];
            r_bit_cnt <= r_bit_cnt + 4'd1;
            r_state <= 4'd4;
          end
          end  else begin
           r_state <= 4'd4;
         end       
       end
      4'd5://接受ack信号
        begin
          r_scl_en <= 1'b1;
          if(scl) begin
            r_ack_flag <= sda;
            r_state <= 4'd6;            
          end else begin
            r_state <= 4'd5;
          end
        end
      4'd6://检验ack信号
        begin
          r_scl_en <= 1'b1;
          if(r_ack_flag == 1'b0)
            r_state <= r_jump_state;
          else begin
            r_state <= 4'd0;
          end
        end
      4'd7://第2次加载物理设备地址
        begin
          r_scl_en <= 1'b1;
          r_load <= {i_dev_addr,1'b1};
          r_state <= 4'd3;
          r_jump_state <= 4'd8;
        end
      4'd8://接收一个字节的信号
        begin
          r_scl_en <= 1'b1;
          if(scl) begin
          if(r_bit_cnt == 4'd8) begin
            r_state <= 4'd9;
            r_bit_cnt <= 4'd0; 
            end else begin
              r_read_data[7 - r_bit_cnt] <= sda;
              r_bit_cnt <= r_bit_cnt + 4'd1;
              r_state <= 4'd8;
            end
          end else begin
            r_state <= 4'd8;
          end          
        end
      4'd9://发送no ack 信号
        begin
          r_scl_en <= 1'b1;
          if(!scl) begin
            r_sda <= 1'b1;
            r_state <= 4'd10;
          end else begin
            r_state <= 4'd9;
          end
        end
      4'd10://使sdai信号为0，为停止信号做准备
        begin
          r_scl_en <= 1'b1;
          r_sda <= 1'b0;
          r_state <= 4'd11;
        end
      4'd11://发送停止信号
       begin
         r_scl_en <= 1'b1;
         if(scl) begin
           r_sda <= 1'b1;
           r_state <= 4'd12;
         end else begin
           r_state <= 4'd11;
         end
       end
     4'd12://总线停止操作
       begin
         o_done_flag <= 1'b1;
         r_sda <= 1'b1;
         r_scl <= 1'b1;
         r_scl_en <= 1'b0;
         r_state <= 4'd0;
         r_jump_state <= 4'd0;
         r_load <= 8'd0;
         r_bit_cnt <= 4'd0;
         r_ack_flag <= 1'b0;
       end
      endcase
    end else begin
      o_done_flag <= 1'b0;
      r_read_data <= 8'd0;
      r_sda <= 1'b1;
      r_scl <= 1'b1;
      r_scl_en <= 1'b0;
      r_state <= 4'd0;
      r_jump_state <= 4'd0;
      r_load <= 8'd0;
      r_bit_cnt <= 4'd0;
      r_ack_flag <= 1'b0;    
    end
  end
  
assign link_sda = ((r_state == 4'd5) || (r_state == 4'd8)) ? 1'b0 : 1'b1;    
endmodule
