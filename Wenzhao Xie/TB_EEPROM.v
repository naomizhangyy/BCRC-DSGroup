`timescale 1ns/1ps

module TB_EEPROM(
	input RD_END,
	input WR_END,
	inout [7:0] DATA,

	output CLK,
	output RESET,
	output RD,
	output WR,
	output [10:0] ADDR
	);

`define TIME 10

reg clk,reset,rd,wr;
reg link_data;
reg [7:0] reg_data;
reg [7:0] reg_rd_data;
reg [10:0] addr;
assign RESET = reset;
assign RD = rd;
assign WR = wr;
assign ADDR = addr;

integer i;
reg [7:0] counter;
reg [7:0] data_write [255:0];
reg [7:0] data_read  [255:0];

wire sda,scl,p2s_end_signal;

assign CLK = clk;
assign DATA = link_data ? reg_data : 8'bz;

EEPROM_CTRL EEP_CTL_INST(.CLK(CLK),.RESET(RESET),.RD_END(RD_END),.WR_END(WR_END),.DATA(DATA),.RD(RD),.WR(WR),.ADDR(ADDR),.SDA(sda),.SCL(scl));
EEPROM_UNIT EEPROM_INST(.SDA(sda),.SCL(scl));

initial begin
	clk = 0;
	forever #`TIME clk = ~clk;
end

initial begin
    for(i = 0;i<=255;) begin
        data_write[i] = 255 - i;
        i = i + 1;
    end
    counter = 8'b00000000;
end

initial begin
    #(`TIME*4) reset = 0;
	#(`TIME*6) reset = 1; 
	
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write[i];
        addr = {3'b001,counter};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        counter = counter + 1;
    end
    
    link_data = 1'b0;
    counter = 8'b00000000;
    
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b001,counter};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        counter = counter + 1;        
    end
    
    for(i=0;i<=255;i = i + 1) begin
        $display("The write data i is %d, the read data i is %d.",i,data_write[i],i,data_read[i]);
    end
    
    $finish;
end

/*
initial begin
	#(`TIME*2) begin
		wr = 0;
		rd = 0;
		reg_data = 8'b0000_0000;
		link_data = 1'b0;
	end
end

initial begin
	#(`TIME*12) begin
		wr = 1;
		addr = 11'b001_1101_1101;
		reg_data = 8'b1001_1001;
		link_data = 1'b1;
	end
end
	
initial begin
	wait(WR_END == 1'b1) begin 
	   wr = 0;
	   link_data = 0;
	   #(`TIME*10);
	end
	#(`TIME*6);
	rd = 1;
	wait(RD_END == 1'b1) begin
        reg_rd_data = DATA;
        rd = 0;
        $display("The data is : %b",reg_rd_data);
        #(`TIME*4);
        $finish;
    end
end
*/


endmodule
