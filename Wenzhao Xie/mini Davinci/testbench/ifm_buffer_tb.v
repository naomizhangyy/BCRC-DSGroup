`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/14 15:44:50
// Design Name: sDavinci
// Module Name: ifm_buffer_tb
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

// Created Date: 2019/11/14
// Creator: Xie Wenzhao

module ifm_buffer_tb();

localparam TRUE  = 1,
           FALSE = 0;

reg clock;
reg rst_n;

initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
end

reg       i2c_ifm_start;

reg [3:0] ksize;
reg [5:0] tile_length;
reg [5:0] tile_height;
reg [3:0] valid_num;

wire      i2c_ready;

reg          addr_valid;
reg  [9:0]   base_addr;
wire [127:0] pixels_in;

wire       ifm_rd_en;
wire [9:0] ifm_rd_addr;

wire         ifm_wr_en;
wire [4:0]   ifm_wr_addr;
wire [127:0] pixels_out;
wire [3:0]   num_valid;

img2col_ifm img2col_ifm_inst(
    .clock(clock),
    .rst_n(rst_n),
    .i2c_ifm_start(i2c_ifm_start),

    .ksize(ksize),
    .tile_length(tile_length),
    .tile_height(tile_height),
    .valid_num(valid_num),

    .i2c_ready(i2c_ready),

    .addr_valid(addr_valid),
    .base_addr(base_addr),
    .pixels_in(pixels_in),

    .ifm_rd_en(ifm_rd_en),
    .ifm_rd_addr(ifm_rd_addr),

    .ifm_wr_en(ifm_wr_en),
    .ifm_wr_addr(ifm_wr_addr),
    .pixels_out(pixels_out),
    .num_valid(num_valid)
);

reg         wea;
reg [9:0]   addra;
reg [127:0] data_in;

blk_mem_gen_1 bram_inst(
    .clka(clock),
    .dina(data_in),
    .wea(wea),
    .addra(addra),

    .clkb(clock),
    .doutb(pixels_in),
    .enb(ifm_rd_en),
    .addrb(ifm_rd_addr)
);

// Below is the bram initialization part
reg bram_init;
reg [127:0] data_set [1023:0];
reg [9:0] bram_cnt;
integer i;

initial begin
    for(i=0;i<1024;i=i+1) data_set[i] = i;
    bram_cnt = 'b0;
    bram_init = TRUE;
end

always@(posedge clock) begin
    if(bram_init == TRUE) begin
        if(bram_cnt <= 783) begin
            bram_cnt <= bram_cnt + 1;
            wea <= TRUE;
            addra <= bram_cnt;
            data_in <= data_set[bram_cnt[9:0]];
        end
        else begin
            wea <= FALSE;
            bram_init <= FALSE;
        end
    end
end

// Below is the img2col_ifm initial block
initial begin
    ksize = 3;
    tile_height = 28;
    tile_length = 28;
    valid_num = 8;
    i2c_ifm_start = FALSE;
    addr_valid = TRUE;
end

// Below is the ifm_buffer initial block

wire       buf_empty;

ifm_buffer ifm_buffer_inst(
    .clock(clock),
    .rst_n(rst_n),
    .ifm_wr_en(ifm_wr_en),
    .ifm_wr_addr(ifm_wr_addr),

    .i2c_ready(i2c_ready),
    .pixels_in(pixels_out),
    .valid_num(num_valid),

    .buf_empty(buf_empty)
);

reg i2c_start_flag = 0;
always@(posedge clock) begin
    if(bram_init == FALSE) begin
        if(buf_empty == TRUE) begin
            base_addr <= 14;
            i2c_start_flag <= 1;
        end
    end
end

reg start_reg0,start_reg1;
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        start_reg0 <= 0;
        start_reg1 <= 0;
    end
    else begin
        start_reg0 <= start_reg1;
        start_reg1 <= i2c_start_flag;

        if(start_reg0 != start_reg1) i2c_ifm_start <= TRUE;
        else i2c_ifm_start <= FALSE;
    end
end

endmodule