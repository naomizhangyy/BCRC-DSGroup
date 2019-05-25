`timescale 1ns / 1ps

module p2s_8bit(
	input SIOC,
	input MID_SIOC,
	input HOLD_N,
	input [7:0] DATA_IN,
	output reg SDA,
	output reg P2S_END
	);

wire [7:0] data;
reg [7:0] state;

assign data = DATA_IN;

parameter
bit7 = 8'b0000_0001,
bit6 = 8'b0000_0010,
bit5 = 8'b0000_0100,
bit4 = 8'b0000_1000,
bit3 = 8'b0001_0000,
bit2 = 8'b0010_0000,
bit1 = 8'b0100_0000,
bit0 = 8'b1000_0000;

always@(posedge MID_SIOC) begin
	if(!SIOC)
		case(state)
			bit7: begin
				P2S_END <= 1'b0;
				if(HOLD_N) begin
					state <= bit6;
					SDA <= data[7];
				end
				else state <= bit7;
			end
			bit6: begin
				state <= bit5;
				SDA <= data[6];
			end
			bit5: begin
				state <= bit4;
				SDA <= data[5];
			end
			bit4: begin
				state <= bit3;
				SDA <= data[4];
			end
			bit3: begin
				state <= bit2;
				SDA <= data[3];
			end
			bit2: begin
				state <= bit1;
				SDA <= data[2];
			end
			bit1: begin
				state <= bit0;
				SDA <= data[1];
			end
			bit0: begin
				state <= bit7;
				SDA <= data[0];
				P2S_END <= 1'b1;
			end
			default: state <= bit7;
		endcase
	else state <= state;
end

endmodule:p2s_8bit
