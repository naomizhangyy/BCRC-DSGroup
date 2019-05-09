`timescale 1ns / 1ps

module p2s_8bit(
	input SCL,
	input CLK,
	input hold_n,
	input [7:0] DATA_IN,
	output SDA,
	output p2s_end
	);
reg sda;
wire [7:0] data;
reg [7:0] state;
reg p2s_end_out;

assign p2s_end = p2s_end_out;
assign data = DATA_IN;
assign SDA = sda;

parameter
bit7 = 8'b0000_0001,
bit6 = 8'b0000_0010,
bit5 = 8'b0000_0100,
bit4 = 8'b0000_1000,
bit3 = 8'b0001_0000,
bit2 = 8'b0010_0000,
bit1 = 8'b0100_0000,
bit0 = 8'b1000_0000;

always@(negedge SCL) begin
	case(state)
		bit7: begin
			p2s_end_out <= 1'b0;
			if(hold_n) begin
				state <= bit6;
				sda <= data[7];
			end
			else state <= bit7;
		end
		bit6: begin
			state <= bit5;
			sda <= data[6];
		end
		bit5: begin
			state <= bit4;
			sda <= data[5];
		end
		bit4: begin
			state <= bit3;
			sda <= data[4];
		end
		bit3: begin
			state <= bit2;
			sda <= data[3];
		end
		bit2: begin
			state <= bit1;
			sda <= data[2];
		end
		bit1: begin
			state <= bit0;
			sda <= data[1];
		end
		bit0: begin
			state <= bit7;
			sda <= data[0];
			p2s_end_out <= 1'b1;
		end
		default: state <= bit7;
	endcase
end

endmodule