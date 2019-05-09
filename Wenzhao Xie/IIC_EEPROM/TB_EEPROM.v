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
reg [7:0] number;
reg [7:0] data_write0 [255:0];
reg [7:0] data_write1 [255:0];
reg [7:0] data_write2 [255:0];
reg [7:0] data_write3 [255:0];
reg [7:0] data_write4 [255:0];
reg [7:0] data_write5 [255:0];
reg [7:0] data_write6 [255:0];
reg [7:0] data_write7 [255:0];
reg [7:0] data_read  [255:0];

wire sda,scl;

assign CLK = clk;
assign DATA = link_data ? reg_data : 8'bz;

EEPROM_CTRL EEP_CTL_INST(.CLK(CLK),.RESET(RESET),.RD_END(RD_END),.WR_END(WR_END),.DATA(DATA),.RD(RD),.WR(WR),.ADDR(ADDR),.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b000)) EEPROM_INST0(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b001)) EEPROM_INST1(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b010)) EEPROM_INST2(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b011)) EEPROM_INST3(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b100)) EEPROM_INST4(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b101)) EEPROM_INST5(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b110)) EEPROM_INST6(.SDA(sda),.SCL(scl));
EEPROM_UNIT #(.page_addr(3'b111)) EEPROM_INST7(.SDA(sda),.SCL(scl));

initial begin
	clk = 0;
	forever #`TIME clk = ~clk;
end

// Initialization
initial begin
    for(i = 0;i<=255;) begin
        data_write0[i] = i;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write1[i] = i + 1;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write2[i] = i + 2;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write3[i] = i + 3;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write4[i] = i + 4;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write5[i] = i + 5;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write6[i] = i + 6;
        i = i + 1;
    end
    for(i = 0;i<=255;) begin
        data_write7[i] = i + 7;
        i = i + 1;
    end       
    number = 8'b00000000;
end

// Data write and read
initial begin
    #(`TIME*4) reset = 0;
	#(`TIME*6) reset = 1; 
	#(`TIME*6);
	
	// Write data0
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write0[i];
        addr = {3'b000,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
    
    // Write data1
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write1[i];
        addr = {3'b001,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
    
    // Write data2
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write2[i];
        addr = {3'b010,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
        
    // Write data3
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write3[i];
        addr = {3'b011,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
    
    // Write data4
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write4[i];
        addr = {3'b100,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
    
    // Write data5
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write5[i];
        addr = {3'b101,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
    
    // Write data6
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write6[i];
        addr = {3'b110,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
        
    // Write data7
    for(i=0;i<=255;i = i + 1) begin
        reg_data = data_write7[i];
        addr = {3'b111,number};
        wr = 1;
        link_data = 1'b1;
        wait(WR_END == 1) begin
            wr = 0;
            link_data = 0;
        end
        number = number + 1;
        #(`TIME*5);
    end
    
    wr = 0;
    link_data = 1'b0;
    number = 8'b00000000;
    #(`TIME*6); 
    
    // Read data0
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b000,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST0 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data1
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b001,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST1 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data2
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b010,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST2 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data3
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b011,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST3 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data4
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b100,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST4 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data5
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b101,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST5 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data6
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b110,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST6 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    // Read data7
    for(i=0;i<=255;i = i + 1) begin
        addr = {3'b111,number};
        rd = 1;
        wait(RD_END == 1'b1) begin
            rd = 0;
            reg_rd_data = DATA;
            data_read[i] = reg_rd_data;
        end
        $display("The EEPROM_INST7 addr is %d, the data is %d.",number,data_read[i]);
        number = number + 1;
        #(`TIME*5);        
    end
    
    $finish;
end

endmodule:TB_EEPROM