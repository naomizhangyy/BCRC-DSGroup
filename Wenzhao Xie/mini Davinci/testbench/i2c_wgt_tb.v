`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/10/24 10:58:43
// Design Name: sDavinci
// Module Name: i2c_wgt_tb
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module i2c_wgt_tb();

localparam TRUE  = 1,
           FALSE = 0;

reg          clock;
reg          rst_n;

initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    #50  rst_n = 0;
    #100 rst_n = 1;
end

reg          i2c_wgt_start;

reg  [3:0]   kernel_size;
reg  [127:0] wgt_in;
reg  [3:0]   valid_num;

wire         i2c_ready;

wire [4:0]   wgt_rd_addr;
wire         wgt_rd_en;

wire [4:0]   wgt_wr_addr;
wire         wgt_wr_en;
wire [127:0] wgt_out;
wire [3:0]   num_valid;

img2col_weight i2c_wgt_inst(
    .clock(clock),
    .rst_n(rst_n),
    .i2c_wgt_start(i2c_wgt_start),

    .kernel_size(kernel_size),
    .wgt_in(wgt_in),
    .valid_num(valid_num),

    .i2c_ready(i2c_ready),

    .wgt_rd_addr(wgt_rd_addr),
    .wgt_rd_en(wgt_rd_en),
    
    .wgt_wr_addr(wgt_wr_addr),
    .wgt_wr_en(wgt_wr_en),
    .wgt_out(wgt_out),
    .num_valid(num_valid)
);

reg [127:0] dina;
reg         wea;
reg [6:0]   addra;
reg         bram_wr_go;
reg         bram_wr_done;
reg [6:0]   bram_wr_cnt;

blk_mem_gen_0 blk_mem_gen_inst0(
    .clka(clock),
    .dina(dina),
    .addra(addra),
    .wea(wea),

    .clkb(clock),
    .doutb(wgt_in),
    .enb(wgt_rd_en),
    .addrb(wgt_rd_addr));

// This is the bram data in part.
initial begin
    bram_wr_go = FALSE;
    bram_wr_done = FALSE;
    bram_wr_cnt = 'b0;

    #100 bram_wr_go = TRUE;
end

// 输入通道三层，ksize=3
always@(posedge clock) begin
    if(bram_wr_go == TRUE) begin
        if(bram_wr_cnt <= 24) begin
            wea <= TRUE;
            dina <= bram_wr_cnt + 1;
            addra <= bram_wr_cnt;
            bram_wr_cnt <= bram_wr_cnt + 1;
        end
        else begin
            wea <= FALSE;
            bram_wr_done <= TRUE;
        end
    end 
end
// Bram data in part finishes.

reg flag = 1;
// This is the bram data read part.
always@(posedge clock) begin
    if(bram_wr_done == TRUE && i2c_ready == TRUE && flag) begin
        kernel_size <= 3;
        valid_num <= 3;
        i2c_wgt_start <= TRUE;
        flag <= 0;
    end
    if(i2c_ready == FALSE) begin
        i2c_wgt_start <= FALSE;
    end
end

endmodule