`timescale 1ns / 1ps

module SCCB_CTRL(
	input CLK,
	input RESET,
	input WR,
	input [15:0] ADDR,
	input [7:0] DATA_WR,

	output reg WR_END,
	output reg SCCB_START,

	output reg SIOC,
	inout SIOD
	);

reg sioc_holdn;

reg hold_n;
reg [2:0] cnt_rd;
reg [7:0] p2s_buf;
reg [9:0] main_state;

reg [11:0] cnt_clk_div;
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
IDLE 				= 		10'b00_0000_0001,
WRITE_CTRL 	        = 		10'b00_0000_0010,   // Write control signal
ACK_0 			    = 		10'b00_0000_0100,   // Ready to write address
WRITE_ADDR0 	    = 		10'b00_0000_1000,   // Write address
ACK_1 				= 		10'b00_0001_0000,   // Switch to Ctrl_Rd or Write data
WRITE_ADDR1         =       10'b00_0010_0000,
ACK_2               =       10'b00_0100_0000,
WRITE_DATA 			= 		10'b00_1000_0000,   // Write data to EEPROM
ACK_3				=		10'b01_0000_0000,
STOP_WRITE_DATA 	= 		10'b10_0000_0000;

p2s_8bit p2s_8bit_inst0(.MID_SIOC(mid_sioc),.SIOC(SIOC),.HOLD_N(hold_n),.DATA_IN(p2s_buf),.SDA(p2s),.P2S_END(p2s_end_signal));

// SIO_C generator, 1024 divided, if the CLK is 100M, the SIO_C will be 100k.
always@(posedge CLK or negedge RESET) begin
		if(!RESET) cnt_clk_div <= 12'b1000_0000_0000;
		else cnt_clk_div <= cnt_clk_div + 1'b1;
end

always@(negedge mid_sioc) begin
    if(sioc_holdn == 1'b0) SIOC <= 1'b1;
    else SIOC <= ~SIOC;
end

always@(posedge mid_sioc or negedge RESET) begin
	if(!RESET) begin
	    sioc_holdn <= 1'b0;
		hold_n <= 1'b0;
		link_0 <= 1'b0;
		link_1 <= 1'b1;				//Pull siod up
		link_p2s <= 1'b0;
		link_siod <= 1'b1;			//Set siod as output
		SCCB_START <= 1'b0;
		main_state <= IDLE;
	end
	else case(main_state)
		IDLE: begin
		    WR_END <= 1'b0;
			if(SIOC) begin
				if(WR) begin
				    sioc_holdn <= 1'b1;
					link_0 <= 1'b1;		        // Start signal
					link_1 <= 1'b0;
					WR_END <= 1'b0;
					p2s_buf <= 8'b0111_1000;	// SCCB ID : 0x78
					hold_n <= 1'b1;
					SCCB_START <= 1'b1;
					main_state <= WRITE_CTRL;
				end
				else begin
				    main_state <= IDLE;
				    WR_END <= 1'b0;
				end
			end
			else begin  						// SIOC == 0, can't start.
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
					p2s_buf <= ADDR[15:8];   // Dump the address to p2s unit
					link_p2s <= 1'b0;
					link_siod <= 1'b0;		// Set SIOD as Z, input state
				end
			end
			else main_state <= WRITE_CTRL;
		end

		//Next state is to write ADDR high 8bits
		ACK_0: begin
			if(SIOC) begin
				if(1'b1) begin              // Check the ACK signal from SCCB unit
					main_state <= WRITE_ADDR0;
					hold_n <= 1'b1;                 // Unlock p2s unit, ready to send address
				end
				else main_state <= ACK_0;
			end
			else main_state <= ACK_0;
		end

		WRITE_ADDR0: begin
		    if(!SIOC && link_siod == 1'b0) begin
                link_p2s <= 1'b1;
                link_siod <= 1'b1;            	// Set SIOD as output
            end
            if(SIOC)
				if(p2s_end_signal == 1'b1) hold_n <= 1'b0; // p2s finished, hold
			if(!SIOC) begin                     // Check while MID rises
				if(p2s_end_signal != 1'b1) main_state <= WRITE_ADDR0;
				else begin
                    p2s_buf <= ADDR[7:0];
				    link_p2s <= 1'b0;
				    link_siod <= 1'b0;			// Set SIOD as Z, input state
					main_state <= ACK_1;
				end
			end
		end

		ACK_1: begin
			if(SIOC) begin
				main_state <= WRITE_ADDR1;
				hold_n <= 1'b1;					// release p2s, ready to write data
			end
		end
		
		WRITE_ADDR1: begin
            if(!SIOC && link_siod == 1'b0) begin
                link_p2s <= 1'b1;
                link_siod <= 1'b1;                // Set SIOD as output
            end
            if(SIOC)
                if(p2s_end_signal == 1'b1) hold_n <= 1'b0; // p2s finished, hold
            if(!SIOC) begin                     // Check while MID rises
                if(p2s_end_signal != 1'b1) main_state <= WRITE_ADDR1;
                else begin
                    link_p2s <= 1'b0;
                    link_siod <= 1'b0;            // Set SIOD as Z, input state
                    main_state <= ACK_2;
                end
            end
        end
        
        ACK_2: begin
            if(SIOC) begin         //Ready to write data
                main_state <= WRITE_DATA;
                hold_n <= 1'b1;                    // release p2s, ready to write data
                p2s_buf <= DATA_WR;                // DATA output through SIOD
            end
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
					main_state <= ACK_3;
				end
		end

		//Next state is to STOP, write data finishes
		ACK_3: begin
			if(SIOC && 1'b1) main_state <= STOP_WRITE_DATA;
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
			    
			    sioc_holdn <= 1'b0;
			    SCCB_START <= 1'b0;
			    
			    main_state <= IDLE;
			end
			else main_state <= STOP_WRITE_DATA;
		end
		default: main_state <= IDLE;
	endcase
end

endmodule:SCCB_CTRL
