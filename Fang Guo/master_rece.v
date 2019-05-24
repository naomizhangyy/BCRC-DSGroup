`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 10:33:32
// Design Name: 
// Module Name: master_rece
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


module master_rece(
input i_clk,
input i_rst,
inout sda,
output scl,
input [7 : 0] data,
input [6 : 0] dev_addr,
input [7 : 0] word_addr,
input master_rece_go
    );
    
 reg r_scl;
 reg r_scl_en;
 reg [2 : 0] state;
 reg [7 : 0] mid_r;
 reg [3 : 0] data_cnt;
 reg sda_en;
 reg [7 : 0] r_sda;
 reg r_ack;
 reg [1 : 0] trans_cnt;
 
 
 parameter IDLE = 3'b000,
            START = 3'b001,
            TR_DATA = 3'b010,
            ACK = 3'b011,
            ACK_CHK = 3'b100,
            RE_DATA = 3'b101,
            RE_ACK = 3'b110,
            STOP = 3'b111;
            
 
 assign scl = r_scl;
 assign sda = sda_en ? r_sda[7] : 1'bz;
    
 always@(negedge i_clk or i_rst)//generate the r_scl ,its frequency is the half of i_clk
   if(!i_rst) begin
     r_scl <= 1'b1;
   end else if(r_scl_en) begin
     r_scl <= ~r_scl;
   end else begin
     r_scl <= 1;
   end
   
always@(posedge i_clk or negedge i_rst)
  if(!i_rst) begin
    state <= 3'b000;
    mid_r <= {dev_addr,1'b0};
    data_cnt <= 4'b1000;
    r_sda[7] <= 1'b1;
    sda_en <= 1'b1;
    r_ack <= 0;
    trans_cnt <= 2'b01;
    r_scl_en <= 1'b0;
  end else begin    
      case(state)
        IDLE: if(master_rece_go)
              begin
                state <= START;
                r_sda[7] <= 0;
                r_scl_en <= 1'b1;
              end else begin
                state <= IDLE;
              end
        START: if(!scl)
               if(data_cnt == 4'b1000) begin
                  state <= TR_DATA;
                  r_sda <= mid_r;
                  data_cnt <= data_cnt - 4'b0001;
               end else begin
                   state <= START;
               end
         TR_DATA: begin
                 if(data_cnt == 4'b0000) begin
                   state <= ACK;
                   data_cnt <= 4'b1000;
                   //sda_en <= 1'b0;
                 end else if(!scl) 
                 begin
                   state <= TR_DATA;
                   r_sda <= r_sda << 1;
                   data_cnt <= data_cnt - 4'b0001;
                 end else begin
                 state <= TR_DATA;
               end
              end
          ACK: begin
               sda_en <= 1'b0; 
               state <= ACK_CHK;
               end
          ACK_CHK: begin
                   
                   if(r_ack == 1'b0) begin
                   if(trans_cnt == 2'b10) begin
                      state <= START;  
                      sda_en <= 1'b1;                    
                    end else if(trans_cnt == 2'b11) 
                    begin
                      sda_en <= 1'b0;
                      state <= RE_DATA; 
                    end else begin
                      sda_en <= 1'b1;
                      state <= STOP;
                      r_sda[7] <= 1'b0;
                    end
                   end else begin
                      sda_en <= 1'b1;
                      state <= IDLE;
                      r_sda[7] <= 1'b1;
                   end   
                 end
           RE_DATA: begin 
                     if(scl) begin               
                     if(data_cnt == 4'b0001) begin
                       r_sda[0] <= sda;  
                       r_sda <= r_sda << 1; 
                       state <= RE_ACK; 
                       data_cnt <= 4'b1000; 
                     end else  begin
                       r_sda[0] <= sda;  
                       r_sda <= r_sda << 1;                   
                       state <= RE_DATA;
                       data_cnt <= data_cnt - 3'b001;                      
                     end end  else begin
                       state <= RE_DATA;
                     end
                 end   
           RE_ACK:begin
                    sda_en <= 1'b1;
                    r_sda <= 1'b0;
                    state <= STOP;
                  end                   
                 
           STOP:begin
                if(scl)
                  r_sda[7] <= 1;
                  r_scl_en <= 1'b0;
               end
      endcase
    end 
    
    
     always@(posedge scl)
            if(state == ACK_CHK)
               begin
                  r_ack <= sda;
                  case(trans_cnt)
                  2'b00:begin
                         mid_r <= {dev_addr,1'b0} ;
                         trans_cnt <= trans_cnt + 2'b01;
                       end
                  2'b01: begin
                          mid_r <= word_addr;
                          trans_cnt <= trans_cnt + 2'b01;
                          end
                  2'b10:begin
                        mid_r <= data;
                        trans_cnt <= trans_cnt + 2'b01;
                        end
                  default: mid_r <= 8'b0000_0000; 
                  endcase
               end else  begin
                  r_ack <= r_ack;
               end         
 
 
 
endmodule
