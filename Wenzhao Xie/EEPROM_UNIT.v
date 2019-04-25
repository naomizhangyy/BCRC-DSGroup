`timescale 1ns / 1ps

module EEPROM_UNIT(
    inout SDA,
    input SCL
    );
    
reg reg_bit;
reg reg_tag;
reg link_sda,link_1,link_0,link_data;
wire sda0,sda1,sda2;    
assign SDA = link_sda ? (sda0 || sda1 || sda2) : 1'bz;
assign sda0 = link_0 ? 1'b0 : 1'b0;
assign sda1 = link_1 ? 1'b1 : 1'b0;
assign sda2 = link_data ? reg_bit : 1'b0;

reg reg_start;
reg [1:0] tmp;
reg [2:0] counter;
reg [7:0] reg_ctrl;
reg [7:0] reg_addr;
reg [7:0] reg_wr_data;
reg [12:0] state;
reg [7:0] mem [255:0];

parameter
Idle = 13'b0_0000_0000_0001,//
Write_Ctrl = 13'b0_0000_0000_0010,//
ACK0 = 13'b0_0000_0000_0100,//
Write_Addr = 13'b0_0000_0000_1000,//
ACK1 = 13'b0_0000_0001_0000,//
Choice = 13'b0_0000_0010_0000,
Write_Data = 13'b0_0000_0100_0000,//
Write_Ctrl_Rd = 13'b0_0000_1000_0000,//
ACK2 = 13'b0_0001_0000_0000,//
ACK3 = 13'b0_0010_0000_0000,//
Read_Data = 13'b0_0100_0000_0000,//
NO_ACK = 13'b0_1000_0000_0000,//
STOP = 13'b1_0000_0000_0000;// 

always@(SCL) begin
	case(state)
		Idle: begin
			reg_start <= SDA;
            //else reg_start[0] <= SDA;
            if(reg_start == 1'b1 && !SCL && !SDA) begin
                counter <= 3'b111;
                reg_ctrl <= 8'b0;
                link_sda <= 1'b0;
                link_0 <= 1'b0;
                link_1 <= 1'b0;
                link_data <= 1'b0;
                state <= Write_Ctrl;
            end
            else begin
                link_sda <= 1'b0;
                state <= Idle;
            end
		end
		Write_Ctrl: begin
			if(SCL) begin
				reg_ctrl[counter] <= SDA;
				counter <= counter - 3'b001;
				if(counter != 3'b000) state <= Write_Ctrl;
				else begin
					//counter <= 3'b111;
					state <= ACK0;
				end
			end
			else state <= Write_Ctrl;
		end
		ACK0: begin
			if(!SCL) begin
				link_sda <= 1'b1;		//Set SDA as output
				link_0 <= 1'b1;
				link_1 <= 1'b0;
				state <= Write_Addr;
			end
			else state <= ACK0;
		end
		Write_Addr: begin
		    if(!SCL && link_0 == 1'b1) begin
                link_sda <= 1'b0;        //Set SDA as input
                link_0 <= 1'b0;
                link_1 <= 1'b0;
                reg_addr <= 8'b0;
                counter <= 3'b111;
                state <= Write_Addr;
              end
			if(!SCL) state <= Write_Addr;
			else begin
				reg_addr[counter] <= SDA;
				counter <= counter - 3'b001;
				if(counter == 3'b000) begin
					state <= ACK1;
				end
				else state <= Write_Addr;
			end
		end
		ACK1: begin
			if(!SCL) begin
				link_sda <= 1'b1;	//Set SDA as output
				link_1 <= 1'b0;
				link_0 <= 1'b1;
			end
			if(SCL && link_sda == 1'b1) begin
				link_sda <= 1'b0;	//Set SDA as input
				link_0 <= 1'b0;
				state <= Choice;
			end
		end
		Choice: begin
			if(!SCL) begin
				if(SDA  == 1'b1) begin
					state <= Write_Ctrl_Rd;
					tmp <= 2'b10;
					counter <= 3'b111;
				end
				else state <= Write_Data;
			end
			else state <= Choice;
		end
		Write_Data: begin
			if(SCL) begin
			    reg_wr_data[counter] <= SDA;
				//mem[reg_addr][counter] <= SDA;
				counter <= counter - 3'b001;
				if(counter != 3'b000) state <= Write_Data;
				else begin
					state <= ACK2;		//Ready to stop
				end
			end
			else state <= Write_Data;
		end
		Write_Ctrl_Rd: begin
			if(tmp != 2'b00) tmp <= tmp - 2'b01;
			else if(SCL) begin
				reg_ctrl[counter] <= SDA;
				counter <= counter - 3'b001;
				if(counter == 3'b000) begin
					state <= ACK3;		//Ready to read data
				end
				else state <= Write_Ctrl_Rd;
			end
		end
		ACK2: begin 	//Ready to stop
			if(!SCL && link_sda == 1'b0) begin
				link_sda <= 1'b1;		//Set SDA as output
				link_0 <= 1'b1;
				mem[reg_addr] <= reg_wr_data;
			end
			if(!SCL && link_sda == 1'b1) begin
				link_0 <= 1'b0;
				link_sda <= 1'b0;
				state <= STOP;
			end
		end
		ACK3: begin 	//Ready to read data
			if(!SCL && link_sda == 1'b0) begin
				link_0 <= 1'b1;
				link_sda <= 1'b1;	//Set as output to read data
			end
			if(SCL && link_sda == 1'b1) begin
				counter <= 3'b111;
				state <= Read_Data;
			end
			//else state <= ACK3;
		end
		Read_Data: begin
		    if(!SCL && link_0 == 1'b1) begin
		        link_0 <= 1'b0;
                link_data <= 1'b1;
		    end
			if(!SCL) begin
				reg_bit <= mem[reg_addr][counter];
				counter <= counter - 3'b001;
				if(counter != 3'b000) state <= Read_Data;
				else state <= NO_ACK;
			end
			else state <= Read_Data;
		end
		NO_ACK: begin
			if(!SCL && link_1 == 1'b0) begin
				link_1 <= 1'b1;
				link_data <= 1'b0;
			end
			if(SCL && link_1 == 1'b1) begin
				link_1 <= 1'b0;
				link_sda <= 1'b0;
				state <= STOP;
			end
		end
		STOP: begin
			if(SCL) reg_tag <= SDA;
			else begin
				if(reg_tag == 1'b0 && SDA == 1'b1) state <= Idle;
				else state <= STOP;
			end
		end
		default: state <= Idle;

	endcase
    end
endmodule
