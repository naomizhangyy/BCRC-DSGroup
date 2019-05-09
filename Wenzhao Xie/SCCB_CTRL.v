`timescale 1ns / 1ps

module SCCB_CTRL(
	input CLK,
	input RESET,
	input RD,
	input WR,
	input [7:0] ADDR,
	input [7:0] DATA_WR,

	output reg RD_END,
	output reg WR_END,
	output reg [7:0] DATA_RD,

	output SIOC,
	inout SIOD
	);

reg r_w,hold_n;
reg [2:0] cnt_rd;
reg [7:0] p2s_buf;
reg [13:0] main_state;

reg [11:0] cnt_clk_div;
assign SIOC = cnt_clk_div[11];
wire mid_sioc;
assign mid_sioc = cnt_clk_div[10];

reg link_0,link_1,link_p2s,link_siod;
wire siod0,siod1,siod_p2s,p2s;
wire p2s_end_signal;
assign siod0 = link_0 ? 0 : 0;
assign siod1 = link_1 ? 1 : 0;
assign siod_p2s = link_p2s ? p2s : 0;
assign SIOD = link_siod ? (siod0|siod1|siod_p2s) : 1'bz;

parameter
IDLE 				= 		14'b00_0000_0000_0001,
WRITE_CTRL 			= 		14'b00_0000_0000_0010,   // Write control signal
ACK_0 				= 		14'b00_0000_0000_0100,   // Ready to write address
WRITE_ADDR 			= 		14'b00_0000_0000_1000,   // Write address
ACK_1 				= 		14'b00_0000_0001_0000,   // Switch to Ctrl_Rd or Write data
WRITE_DATA 			= 		14'b00_0000_0010_0000,   // Write data to EEPROM
STOP_BEFORE_CTRL_RD = 		14'b00_0000_0100_0000,
WRITE_CTRL_RD 		= 		14'b00_0000_1000_0000,   // Write read ctrl
ACK_4 				= 		14'b00_0001_0000_0000,   // Ready to stop after write data
ACK_5 				= 		14'b00_0010_0000_0000,   // Ready to read data from EEPROM unit
READ_DATA 			= 		14'b00_0100_0000_0000,   // Read data from EEPROM unit
NO_ACK 				= 		14'b00_1000_0000_0000,   // Pull up, ready to stop
STOP_WRITE_DATA 	= 		14'b01_0000_0000_0000,
STOP_AFTER_RD 		=		14'b10_0000_0000_0000;

p2s_8bit p2s_8bit_inst0(.MID_SIOC(mid_sioc),.SIOC(SIOC),.HOLD_N(hold_n),.DATA_IN(p2s_buf),.SDA(p2s),.P2S_END(p2s_end_signal));

// SIO_C generator, 1024 divided, if the CLK is 100M, the SIO_C will be 100k.
always@(posedge CLK or negedge RESET) begin
		if(!RESET) cnt_clk_div <= 12'b1000_0000_0000;
		else cnt_clk_div <= cnt_clk_div + 1'b1;
end

always@(posedge mid_sioc or negedge RESET) begin
	if(!RESET) begin
		hold_n <= 1'b0;
		link_0 <= 1'b0;
		link_1 <= 1'b1;				//Pull siod up
		link_p2s <= 1'b0;
		link_siod <= 1'b1;			//Set siod as output
		RD_END <= 1'b0;
		main_state <= IDLE;
	end
	else case(main_state)
		IDLE: begin
			if(SIOC) begin
				if(RD) begin
					link_0 <= 1'b1;		// Start signal
					link_1 <= 1'b0;
					r_w <= 1'b1;		// Read mode
				 	cnt_rd <= 3'b111;
					RD_END <= 1'b0;
					p2s_buf <= 8'b0100_0010;	// SCCB ID : 0x42
					hold_n <= 1'b1;
					main_state <= WRITE_CTRL;
				end
				else if(WR) begin
					link_0 <= 1'b1;		        // Start signal
					link_1 <= 1'b0;
					r_w <= 1'b0;		        // Write mode
					WR_END <= 1'b0;
					p2s_buf <= 8'b0100_0010;	// SCCB ID : 0x42
					hold_n <= 1'b1;
					main_state <= WRITE_CTRL;
				end
				else main_state <= IDLE;
			end
			else begin  						// SIOC == 0, can't start.
			    RD_END <= 1'b0;
			    WR_END <= 1'b0;
			    main_state <= IDLE;
			end
		end

		WRITE_CTRL: begin
			if(!SIOC) begin
				if(link_p2s != 1'b1) begin
					link_p2s <= 1'b1;
					link_0 <= 1'b0;
				end
			end
			if(SIOC)
				if(p2s_end_signal == 1'b1) hold_n <= 1'b0; // p2s finished, hold
			if(!SIOC) begin                    // Check while MID rise
				if(p2s_end_signal != 1'b1) begin
					main_state <= WRITE_CTRL;
				end
				else begin
					main_state <= ACK_0;	// Next state is to write 8bit ADDR
					p2s_buf <= ADDR[7:0];   // Dump the address to p2s unit
					link_p2s <= 1'b0;
					link_siod <= 1'b0;		// Set SIOD as Z, input state
				end
			end
			else main_state <= WRITE_CTRL;
		end

		//Next state is to write 8bit ADDR
		ACK_0: begin
			if(SIOC) begin
				if(SIOD == 1'b0) begin              // Check the ACK signal from SCCB unit
					main_state <= WRITE_ADDR;
					hold_n <= 1'b1;                 // Unlock p2s unit, ready to send address
				end
				else main_state <= ACK_0;
			end
			else main_state <= ACK_0;
		end

		WRITE_ADDR: begin
		    if(!SIOC && link_siod == 1'b0) begin
                link_p2s <= 1'b1;
                link_siod <= 1'b1;            	// Set SIOD as output
            end
            if(SIOC)
				if(p2s_end_signal == 1'b1) hold_n <= 1'b0; // p2s finished, hold
			if(!SIOC) begin                     // Check while MID rises
				if(p2s_end_signal != 1'b1) main_state <= WRITE_ADDR;
				else begin
				    link_p2s <= 1'b0;
				    link_siod <= 1'b0;			// Set SIOD as Z, input state
					main_state <= ACK_1;
				end
			end
			else main_state <= WRITE_ADDR;
		end

		//Next state is to READ ctrl or write data
		ACK_1: begin
			if(r_w == 1'b0 && SIOC && SIOD == 1'b0) begin //Ready to write data
				main_state <= WRITE_DATA;
				hold_n <= 1'b1;					// release p2s, ready to write data
				p2s_buf <= DATA_WR;				// DATA output through SIOD
			end
			if(r_w == 1'b1 && SIOC && SIOD == 1'b0) begin //Ready to STOP, then start, then read ctrl
				main_state <= STOP_BEFORE_CTRL_RD;
			end
			else main_state <= ACK_1;
		end

		WRITE_DATA: begin
		    if(!SIOC && link_siod == 1'b0) begin
		        link_p2s <= 1'b1;
		        link_siod <= 1'b1;				// Set SIOD as output to write data
		    end
		    if(SIOC)
				if(p2s_end_signal == 1'b1) hold_n <= 1'b0; // p2s finished, hold
			if(!SIOC)
				if(p2s_end_signal != 1'b1) main_state <= WRITE_DATA;
				else begin
					link_p2s <= 1'b0;
					link_siod <= 1'b0;			// Set SIOD as Z, input state
					main_state <= ACK_4;
				end
			else main_state <= WRITE_DATA;
		end

		STOP_BEFORE_CTRL_RD: begin
			if(!SIOC && link_siod == 1'b0) begin
				link_0 <= 1'b1;
				link_siod <= 1'b1;				// Pull down the SIOD, ready to stop.
				main_state <= WRITE_CTRL_RD;
			end
			if(SIOC && link_0 == 1'b1) begin
			    link_0 <= 1'b0;
			    link_1 <= 1'b1;					// Stop signal
			    main_state <= WRITE_CTRL_RD;
			end
		end

		WRITE_CTRL_RD: begin
			if(SIOC && link_1 == 1'b1) begin
				link_1 <= 1'b0;
				link_0 <= 1'b1;					// Start signal
				hold_n <= 1'b1;					// Release p2s unit
				p2s_buf <= 8'b0100_0011;		// Prepare to send sub-address
			end
			if(!SIOC && link_p2s == 1'b0) begin
				link_p2s <= 1'b1;
				link_0 <= 1'b0;
			end
			if(SIOC)
				if(p2s_end_signal == 1'b1) hold_n <= 1'b0; // p2s finished, hold
			if(!SIOC) begin
                if(p2s_end_signal != 1'b1) main_state <= WRITE_CTRL_RD;
                else begin
                	link_p2s <= 1'b0;
                	link_siod <= 1'b0;			// Set SIOD as input
                	main_state <= ACK_5;
            	end
            end
            else main_state <= WRITE_CTRL_RD;
		end

		//Next state is to STOP, write data finishes
		ACK_4: begin
			if(SIOC)
				if(SIOD == 1'b0) main_state <= STOP_WRITE_DATA;
				else main_state <= ACK_4;
			else main_state <= ACK_4;
		end

		//Next state is to read data
		ACK_5: begin
			if(SIOC && SIOD == 1'b0) main_state <= READ_DATA;
			else main_state <= ACK_5;
		end

		READ_DATA: begin
			if(SIOC) begin
			    DATA_RD[cnt_rd] <= SIOD;
				if(cnt_rd != 3'b000) main_state <= READ_DATA;
				else main_state <= NO_ACK;
				cnt_rd <= cnt_rd - 1;
			end
			else main_state <= READ_DATA;
		end

		NO_ACK: begin
			if(!SIOC) begin
				link_siod <= 1'b1;
				link_0 <= 1'b1;					// Pull down, ready to stop
				main_state <= STOP_AFTER_RD;
			end
			else main_state <= NO_ACK;
		end

		STOP_WRITE_DATA: begin
			if(!SIOC && link_siod == 1'b0) begin
				link_0 <= 1'b1;
				link_siod <= 1'b1;
			end
			if(SIOC) begin
				link_0 <= 1'b0;
				link_1 <= 1'b1;					// Pull up SIOD to stop
			    WR_END <= 1'b1;
			    main_state <= IDLE;
			end
			else main_state <= STOP_WRITE_DATA;
		end

		STOP_AFTER_RD: begin
			if(SIOC) begin
				link_0 <= 1'b0;
				link_1 <= 1'b1;					// Stop signal
				RD_END <= 1'b1;
				main_state <= IDLE;
			end
			else main_state <= STOP_AFTER_RD;
		end
		
		default: main_state <= IDLE;
	endcase
end

endmodule:SCCB_CTRL