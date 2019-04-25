`timescale 1ns / 1ps

module EEPROM_CTRL(
	input CLK,
	input RESET,
	input RD,
	input WR,
	input [10:0] ADDR,
	//input p2s_end_signal,

	output SCL,
	output RD_END,
	output WR_END,
	inout SDA,
	inout [7:0] DATA
	);

reg R_W,scl,rd_end,wr_end;
reg hold_n;
reg [7:0] data_in_reg,p2s_buf;
reg [12:0] main_state;

reg [2:0] temp;

wire p2s_end_signal;
reg link_read;
reg link_0,link_1,link_p2s,link_sda;
wire sda0,sda1,sda_p2s,p2s;
assign sda0 = link_0 ? 0 : 0;
assign sda1 = link_1 ? 1 : 0;
assign sda_p2s = link_p2s ? p2s : 0;
assign SDA = link_sda ? (sda0|sda1|sda_p2s) : 1'bz;
assign DATA = link_read ? data_in_reg : 8'bz;
assign SCL = scl;
assign RD_END = rd_end;
assign WR_END = wr_end;

parameter
Idle = 13'b0_0000_0000_0001,//
Write_Ctrl = 13'b0_0000_0000_0010,//
ACK_0 = 13'b0_0000_0000_0100,//
Write_Addr = 13'b0_0000_0000_1000,//
ACK_1 = 13'b0_0000_0001_0000,//
Write_Ctrl_Rd = 13'b0_0000_0010_0000,//
Read_Data = 13'b0_0000_0100_0000,
ACK_3 = 13'b0_0000_1000_0000,//
Write_Data = 13'b0_0001_0000_0000,//
ACK_4 = 13'b0_0010_0000_0000,//
NO_ACK = 13'b0_0100_0000_0000,//
ACK_5 = 13'b0_1000_0000_0000,//
STOP = 13'b1_0000_0000_0000;//

p2s_8bit p2s_8bit_inst0(.SCL(scl),.CLK(CLK),.hold_n(hold_n),.DATA_IN(p2s_buf),.SDA(p2s),.p2s_end(p2s_end_signal));

always@(posedge CLK or negedge RESET) begin
	if(!RESET) scl = 1'b0;
	else scl = ~scl;
end

always@(posedge CLK or negedge RESET) begin
	if(!RESET) begin
		hold_n <= 1'b0;
		link_0 <= 1'b0;
		link_1 <= 1'b1;				//Pull SDA up
		link_p2s <= 1'b0;
		link_sda <= 1'b1;			//Set SDA as output
		link_read <= 1'b0;
		rd_end <= 1'b0;
		main_state <= Idle;
	end
	else case(main_state)
		Idle: begin
			if(scl) begin
				if(RD) begin
					link_0 <= 1'b1;		//Start signal	
					link_1 <= 1'b0;
					R_W <= 1'b1;		//Read mode
					temp <= 3'b111;
					rd_end <= 1'b0;
					p2s_buf <= {1'b1,1'b0,1'b1,1'b0,ADDR[10:8],1'b0};
					hold_n <= 1'b1;
					main_state <= Write_Ctrl;
				end
				else if(WR) begin
					link_0 <= 1'b1;		//Start signal
					link_1 <= 1'b0;
					R_W <= 1'b0;		//Write mode
					wr_end <= 1'b0;
					p2s_buf <= {1'b1,1'b0,1'b1,1'b0,ADDR[10:8],1'b0};
					hold_n <= 1'b1;
					main_state <= Write_Ctrl;
				end
				else main_state <= Idle;
			end
			else begin
			    link_read <= 1'b0;
			    main_state <= Idle;
			end
		end
		
		Write_Ctrl: begin
			if(!scl) begin
				if(link_p2s != 1'b1) begin
					link_p2s <= 1'b1;
					link_0 <= 1'b0;
				end
			end
			if(scl) begin
				if(p2s_end_signal != 1'b1) begin
					main_state <= Write_Ctrl;
				end
				else begin
					hold_n <= 1'b0;
					//link_p2s <= 1'b0;
					//link_sda <= 1'b0;		//Set SDA as input
					main_state <= ACK_0;	//Next state is to write 8bit ADDR
					p2s_buf <= ADDR[7:0];
				end
			end
			else main_state <= Write_Ctrl;
		end

		//Next state is to write 8bit ADDR
		ACK_0: begin
		    if(!scl) begin
		      //hold_n <= 1'b0;
              link_p2s <= 1'b0;
              link_sda <= 1'b0;        //Set SDA as input
		    end
			if(scl) begin
				if(SDA == 1'b0) begin
					main_state <= Write_Addr;
					hold_n <= 1'b1;
				    //link_p2s <= 1'b1;
					//link_sda <= 1'b1;			//Set SDA as output
				end
				else main_state <= ACK_0;
			end
			else main_state <= ACK_0;
		end

		Write_Addr: begin
		    if(!scl && link_sda == 1'b0) begin
		        p2s_buf <= ADDR[7:0];
                hold_n <= 1'b1;
                link_p2s <= 1'b1;
                link_sda <= 1'b1;            //Set SDA as output
            end
			if(scl) begin
				if(p2s_end_signal != 1'b1) begin
					main_state <= Write_Addr;
				end
				else begin
				    hold_n <= 1'b0;
					main_state <= ACK_1;
				end
			end
			else main_state <= Write_Addr;
		end

		//Next state is to READ ctrl or write data
		ACK_1: begin
			if(!scl && link_sda == 1'b1) begin
			    hold_n <= 1'b0;
				link_0 <= 1'b0;
				link_1 <= 1'b0;
				link_p2s <= 1'b0;
				link_sda <= 1'b0;
			end
			if(R_W == 1'b0 && scl && SDA == 1'b0) begin   		//Ready to write data
				main_state <= Write_Data;
				hold_n <= 1'b1;
				link_0 <= 1'b1;             //Pull down
				link_1 <= 1'b0;
				link_p2s <= 1'b0;
				link_sda <= 1'b1;			//Set SDA as input
				p2s_buf <= DATA;			//DATA output through SDA, link_read remains 0
			end
			if(R_W == 1'b1 && scl && SDA == 1'b0) begin
				hold_n <= 1'b0;				//Ready to READ ctrl signal
				link_p2s <= 1'b0;
				link_0 <= 1'b0;
				link_1 <= 1'b1;				//Pull up
				link_sda <= 1'b1;			//Set SDA as output
				main_state <= Write_Ctrl_Rd;
			end
		end

		//Next state is to write DATA
		ACK_3: begin
			if(scl) begin
				if(SDA == 1'b0) begin
					main_state <= Write_Data;
					hold_n <= 1'b1;
					link_sda <= 1'b1;			//Set SDA as output
				end
				else main_state <= ACK_3;
			end
			else main_state <= ACK_3;
		end

		Write_Data: begin
		    if(!scl && link_0 == 1'b1) begin
		        link_0 <= 1'b0;
		        link_p2s <= 1'b1;
		    end
			if(scl) begin
				if(p2s_end_signal != 1'b1) begin
					main_state <= Write_Data;
				end
				else begin
					hold_n <= 1'b0;
					main_state <= ACK_4;
				end
			end
			else main_state <= Write_Data;
		end

		Write_Ctrl_Rd: begin	
			if(scl && link_1 == 1'b1) begin
				link_1 <= 1'b0;
				link_0 <= 1'b1;
				hold_n <= 1'b1;
				p2s_buf <= {1'b1,1'b0,1'b1,1'b0,ADDR[10:8],1'b1};
				main_state <= Write_Ctrl_Rd;
			end
			
			if(!scl && link_0 == 1'b1) begin
			    link_0 <= 1'b0;
			    link_p2s <= 1'b1;
			end
			if(hold_n == 1'b1 && scl) begin
                if(p2s_end_signal != 1'b1) main_state <= Write_Ctrl_Rd;
                else main_state <= ACK_5;
            end
            else main_state <= Write_Ctrl_Rd;
		end

		ACK_5: begin
		    if(!scl && link_sda == 1'b1) begin
		        link_p2s <= 1'b0;
                link_sda <= 1'b0;        //Set SDA as input
                hold_n <= 1'b0;
		    end
			if(scl)
				if(SDA == 1'b0) begin
				    main_state <= Read_Data;
				    link_read <= 1'b1;
				end
		        else main_state <= ACK_5;
			else main_state <= ACK_5;
		end

		Read_Data: begin
			if(scl) begin
			    data_in_reg[temp] <= SDA;
				if(temp != 3'b000) main_state <= Read_Data;
				else main_state <= NO_ACK;
				temp <= temp - 1;
			end
			else main_state <= Read_Data;
		end

		//Next state is to STOP
		ACK_4: begin
			if(link_sda == 1'b1) begin
				link_sda <= 1'b0;			//Set SDA as input
				link_p2s <= 1'b0;
			end
			if(scl) begin
				if(SDA == 1'b0) begin
					main_state <= STOP;
				end
				else main_state <= ACK_4;
			end
			else main_state <= ACK_4;
		end

		NO_ACK: begin
			if(scl) begin
				if(SDA == 1'b1) begin
					main_state <= STOP;
					link_0 <= 1'b1;
					link_1 <= 1'b0;
					link_p2s <= 1'b0;
					link_sda <= 1'b1;
				end
				else main_state <= NO_ACK;
			end
			else main_state <= NO_ACK;
		end

		STOP: begin
			if(!scl && link_sda == 1'b0) begin
				link_1 <= 1'b0;
				link_0 <= 1'b1;
				link_sda <= 1'b1;
			end
			if(scl) begin
				link_0 <= 1'b0;
				link_1 <= 1'b1;
				link_sda <= 1'b1;
			end
			if(!scl && link_1 == 1'b1) begin
			    if(R_W == 1'b1) rd_end <= 1'b1;
			    else wr_end <= 1'b1;
			    main_state <= Idle;
			end
		end
		default: main_state <= Idle;

	endcase
end

endmodule
