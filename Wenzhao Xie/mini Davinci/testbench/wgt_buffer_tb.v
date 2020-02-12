`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/15 14:21:41
// Design Name: sDavinci
// Module Name: wgt_buffer_tb
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module wgt_buffer_tb();

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

reg          i2c_wgt_start;

reg  [3:0]   kernel_size;
reg  [127:0] wgt_in;
reg  [3:0]   valid_num;

wire         i2c_ready;

wire [6:0]   wgt_rd_addr;
wire         wgt_rd_en;

wire [6:0]   wgt_wr_addr;
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
            bram_wr_go   <= FALSE;
        end
    end 
end
// Bram data in part finishes.

wire buf_empty;
wgt_buffer wgt_buffer_inst(
    .clock(clock),
    .rst_n(rst_n),

    .wgt_wr_en(wgt_wr_en),
    .wgt_wr_addr(wgt_wr_addr),
    .i2c_ready(i2c_ready),
    .weights_in(wgt_out),
    .valid_num(num_valid),

    .buf_empty(buf_empty)
);

reg flag = 1;
always@(posedge clock) begin
    if(bram_wr_done == TRUE && (flag==1)) begin
        if(buf_empty == TRUE) begin
            kernel_size <= 3;
            valid_num   <= 3;
            if(i2c_ready == TRUE) begin
                i2c_wgt_start <= TRUE;
                flag <= 0;
            end
        end
    end
    if(i2c_ready == FALSE) i2c_wgt_start <= FALSE;
end

endmodule