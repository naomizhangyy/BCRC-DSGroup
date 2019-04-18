moduel M1(
input [3 : 0] Data;
input sclk,rst;
output ack;
);
parameter READY = 4'b0000,
          START = 4'b0001,
		  BIT1 = 4'b0002,
		  BIT2 = 4'b0003,
		  BIT3 = 4'b0004,
		  BIT4 = 4'b0005,
		  BIT5 = 4'b0006,
		  STOP = 4'b0007,
		  IDLE = 4'b0008;
reg [3 : 0] reg_data;
reg [3 : 0] state,next_state;
reg scl;
reg sda;
always@(posedge sclk or negedge rst)
  if(!rst)
    reg_data <= 4'b0000;
  else  if(ack)
    reg_data <= Data;//receive the data from outside of M1	
	
always@(posedge sclk or negedge rst)
  begin
    if(!rst)
	  scl <= 1;
	else 
	  scl <= ~scl;
  end
  
  always@(posedge sclk or negedge rst)
  if(!rst)
    state <= READY;
  else 
    state <= next_state;//transition of state
	
 always(state or ack or scl)
   begin
     next_state <= state;
       case(state)
         IDLE: if(ack)
	       next_state <= START;
		   sda <= 1;
		   ack <= 0;
		 else
		   ack <= 1;
	     START:if(scl) begin
	       next_state <= BIT1;
		   sda <= 0;
	     end else
	       next_state <= START;
	     end
	     Bit1:if(!scl) begin
		   sda <= reg_data[3];
		   next_state <= BIT2;
		 end 
	     BIT2: if(!scl) begin
		   sda <= reg_data[2];
		   next_state <= BIT3;
		 end
	     BIT3:if(!scl)  begin
		   sda <= reg_data[1];
		   next_state <= BIT4;
		 end
	     BIT4:if(!scl)  begin
		   sda <=reg_data[0];
		   next_state <= BIT5;
		 end
         BIT5：if(!scl) begin
	       sda <= 0;
		   next_state <= STOP;
	     end
	     STOP:if(scl)   begin
	       sda <= 1;
	       next_state <= IDLE;
         end	   
	     default:next_state <= 4'bxxxx;
	   endcase
   end
endmodule