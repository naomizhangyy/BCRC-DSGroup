`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/15 20:04:53
// Design Name: 
// Module Name: EEPROM
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


module EEPROM(
input scl,
inout sda
    );
    
 reg [7 : 0] r_addr;
 reg [7 : 0] r_word_addr;
 reg [7 : 0] r_data;
 reg [7 : 0] memory [256 : 0];
 reg r_sda;
 integer i,j,k;
 reg r_sda_en;
 
 
 assign sda = r_sda_en ? r_sda : 1'bz;
  
 
 initial
   begin  
   r_sda_en = 0; 
if(scl) 

begin
  @(negedge sda);
  end  
   #0 i = 0;//this is a queation : if there is not this sentence, the i will be 1 from beginning.
   for( i = 0 ; i < 8 ; i = i + 1)//receive the device address
    begin
      @(posedge scl);
      r_addr[7 - i] = sda;
    end
    
  if(r_addr !== 8'b01011100)
   begin
     @(negedge scl);
     r_sda_en = 1;
     r_sda = 1;
     @(negedge scl);
      r_sda_en = 0;
      r_sda = 1;      
   end 
   
   else
   
    begin
      @(negedge scl);
      r_sda_en = 1;
      r_sda = 0;   
      @(negedge scl);
      r_sda_en = 0;
      r_sda = 1; 
    end 
      @(posedge scl);
      for(j = 0; j < 8 ; j = j + 1) //receive the word address 
        begin
        @(posedge scl);
          r_word_addr[ 7 - j] = sda;
        end
         
        begin
          @(negedge scl);
          #1;
          r_sda_en = 1;
          r_sda = 0;
          #2;
          r_sda_en = 0;
          r_sda = 1;       
        end
        @(posedge scl);
     for(k = 0; k < 8; k = k + 1)//receive the data 
       begin
         @(posedge scl);
         r_data[7 - k] = sda;
       end
       
       begin
         @(negedge scl);
         #1;
         r_sda_en = 1;
           r_sda = 0;
         #2;
         r_sda_en = 0;
           r_sda = 1;       
       end
 
       if(scl)
        begin
         @(posedge sda); //stop signal
         memory[r_word_addr] = r_data;  
         $display("memory[%0d] = %0d",r_word_addr,r_data);      
        end   
     
    end
   endmodule

//assign sda_shadow = (~scl || start_or_stop) ? sda : sda_shadow;
//assign start_or_stop = (~scl) ? 1'b0 : (sda ^ sda_shadow);


/*always@(posedge start_or_stop or negedge scl or negedge reset or posedge scl)
  if(!reset)
    incycle <= 1'b1;
  else if(start_or_stop)
    incycle <= 1'b0;
  else if(~scl)
    incycle <= 1'b1;
    */
    
    
/*always@(scl or reset1)
  if(reset)  begin
    start = 1'b0;
    stop = 1'b0;
  end else 
  if(scl)  begin
    start = (r_sda2 & !sda);
    stop = (!r_sda2 & sda);
 end
 */
        
    
    
    
/*always@(posedge scl or negedge reset)
  if(!reset) begin
    state <= IDLE;
    bit_cnt <= 4'b0111;
    r_sda1 <= 3'b000;
  end else 
  case(state)
  IDLE: if(start ) begin  
    state <= RECE;
    bit_cnt <= 4'b0111;    
  end
  RECE: if(scl) begin
    if(bit_cnt == 4'b0000) begin
      r_sda1[bit_cnt ] <= sda;
      bit_cnt <= 4'b0111;
      state <= ACK;      
    end else begin
    r_sda1[bit_cnt] <= sda;
    bit_cnt <= bit_cnt - 4'b0001;
    state <= RECE;
   end
  end
   ACK: if(!scl) begin
         if(r_sda == 8'b10100000) begin
         
           
             
           
         end
   // state <= COMPARE;
    
  end
  endcase  */
  
  /*task check;
    begin
      if(ctrl_byte == w7||
         ctrl_byte == w6||
         ctrl_byte == w5||
         ctrl_byte == w4||
         ctrl_byte == w3||
         ctrl_byte == w2||
         ctrl_byte == w1||
         ctrl_byte == w0)   
    end
   */




/*

//wire sda_shadow,start_or_stop;
//reg start,stop;
reg [2 : 0] state;
//reg [3 : 0] bit_cnt;
reg [2 : 0] r_sda1;
reg r_sda2;
reg out_flag;
reg ack_buf;
reg [7 : 0] ctrl_byte,addr_byte,memory_buf;
reg [11 : 0] address;
reg [7 : 0] memory [2047 : 0];
//reg reset1;
//wire sda1;



 

 
 parameter         r7 = 8'b10101111, w7 = 8'b10101110,
                    r6 = 8'b10101101, w6 = 8'b10101100,
                    r5 = 8'b10101011, w5 = 8'b10101010,  
                    r4 = 8'b10101001, w4 = 8'b10101000,
                    r3 = 8'b10100111, w3 = 8'b10100110,  
                     r2 = 8'b10100101, w2 = 8'b10100100,
                     r1 = 8'b10100011, w1 = 8'b10100010,
                     r0 = 8'b10100001, w0 = 8'b10100000;

assign sda = (out_flag == 1'b1) ? ack_buf : 1'bz; //generate sda bus model
//assign sda1 = sda;


always@(scl or reset) // check the negedge sda as the start signal
   if(scl)  begin
    @(negedge sda) state = 3'b001;    
    end else begin
      state = state;
    end

 always@(scl or reset) // check the negedge sda as the start signal
       if(scl)  begin
        @(posedge sda) state = 3'b000;    
        end else begin
          state = state;
        end

  

  
  
  initial
  case(state)
    3'b001: begin
              read_in;
              write_to_eeprom;//write operation          
            end
    default: state = 3'b000; 
  endcase
  
  
initial
 begin
   @(negedge reset)  state =3'b000;                        
  // @(posedge start)  state = 3'b001;
 end

initial
  begin
    out_flag = 1'b0;
  end


task  read_in;//read ctrl and word 
  begin
    shift_in(ctrl_byte);
    if(ctrl_byte == w7||
           ctrl_byte == w6||
           ctrl_byte == w5||
           ctrl_byte == w4||
           ctrl_byte == w3||
           ctrl_byte == w2||
           ctrl_byte == w1||
           ctrl_byte == w0)
     begin   
     ack;
    shift_in(addr_byte);
    ack;
    end else begin
      nack;
    end
    
  end  
endtask


task shift_in;
  output [7 : 0] shift;
  begin
  @(posedge scl) shift[7] = sda;
  @(posedge scl) shift[6] = sda;
  @(posedge scl) shift[5] = sda;
  @(posedge scl) shift[4] = sda;
  @(posedge scl) shift[3] = sda;
  @(posedge scl) shift[2] = sda;
  @(posedge scl) shift[1] = sda;
  @(posedge scl) shift[0] = sda;
  end
  endtask
  
 task ack;
   begin
     @(negedge scl) begin
     out_flag = 1'b1;
     ack_buf = 1'b0;
     end
    @(negedge scl) begin
         out_flag = 1'b0;
         ack_buf = 1'b1;
       end     
   end 
endtask

task nack;
   begin
     @(negedge scl) begin
     out_flag = 1'b1;
     ack_buf = 1'b1;
     end
    @(negedge scl) begin
         out_flag = 1'b0;
         ack_buf = 1'b1;
       end     
   end 
endtask

task write_to_eeprom;
  begin
    shift_in(memory_buf);
    address = {ctrl_byte[3 : 1],addr_byte};
    memory[address] = memory_buf;
    $display("eeprom---memory[%0d] = %0d",address,memory[address]);
    ack;
  end
endtask
*/