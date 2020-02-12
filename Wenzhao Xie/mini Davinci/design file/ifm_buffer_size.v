`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/17 12:55:20
// Design Name: sDavinci
// Module Name: ifm_buffer_size
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description:
//
//////////////////////////////////////////////////////////////////////////////////

module ifm_buffer_size
#(parameter SIZE=8)
    (
    input             clock      ,
    input             rst_n      ,

    input  [2:0]      ksize      ,
    input  [SIZE-1:0] ifm_wr_en  ,
    input  [39:0]     ifm_wr_addr,
    input             i2c_ready  ,
    input             i2c_done   ,
    input  [1023:0]   pixels_in  ,
    input  [3:0]      valid_num  ,

    output            buf_empty,
    //------------------------------
    input          cubic_fetch_en,
    input  [4:0]   fetch_num,
    output [1023:0]   pixels_to_cubic
);

wire temp_wire [SIZE-1:0];

genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        ifm_buffer ifm_buffer_inst(
            .clock          (clock)                           ,
            .rst_n          (rst_n)                           ,

            .ksize          (ksize)                           ,
            .ifm_wr_en      (ifm_wr_en[gv_i])                 ,
            .ifm_wr_addr    (ifm_wr_addr[gv_i*5+4:gv_i*5])    ,
            .i2c_ready      (i2c_ready)                       ,
            .i2c_done       (i2c_done)                        ,
            .pixels_in      (pixels_in[gv_i*128+127:gv_i*128]),
            .valid_num      (valid_num)                       ,
            .buf_empty      (temp_wire[gv_i]),

            .cubic_fetch_en    (cubic_fetch_en),
            .fetch_num         (fetch_num),
            .pixels_to_cubic   (pixels_to_cubic[128*gv_i+127:gv_i*128])
        );
    end
endgenerate

assign buf_empty = temp_wire[0];

endmodule