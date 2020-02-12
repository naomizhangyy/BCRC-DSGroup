`timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/18 15:54:21
// Design Name: sDavinci
// Module Name: img2col_ifm_size
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// //////////////////////////////////////////////////////////////////

module img2col_ifm_size
#(parameter SIZE=8)
    (
    input              clock        ,
    input              rst_n        ,

    input              i2c_ifm_start,

    input  [2:0]       ksize,
    input  [5:0]       tile_length  ,
    input  [5:0]       tile_height  ,
    input  [3:0]       valid_num    ,

    output             i2c_ready    ,
    output             i2c_done     ,

    input  [SIZE-1:0]  addr_valid   ,
    input  [79:0]      base_addr    ,
    input  [1023:0]    pixels_in    ,

    output             tile_continue,
    output [SIZE-1:0]  ifm_rd_en    ,
    output [79:0]      ifm_rd_addr  ,

    output [SIZE-1:0]  ifm_wr_en    ,
    output [39:0]      ifm_wr_addr  ,
    output [1023:0]    pixels_out
);


wire temp_wire     [SIZE-1:0];
wire continue_wire [SIZE-1:0];
wire done_wire     [SIZE-1:0];

genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        img2col_ifm img2col_ifm_inst(
            .clock(clock),
            .rst_n(rst_n),
            .i2c_ifm_start(i2c_ifm_start),

            .ksize(ksize),
            .tile_height(tile_height),
            .tile_length(tile_length),
            .valid_num(valid_num),

            .i2c_ready(temp_wire[gv_i]),
            .i2c_done(done_wire[gv_i]),
            
            .addr_valid(addr_valid[gv_i]),
            .base_addr(base_addr[gv_i*10+9:gv_i*10]),
            .pixels_in(pixels_in[gv_i*128+127:gv_i*128]),

            .tile_continue(continue_wire[gv_i]),
            .ifm_rd_addr(ifm_rd_addr[gv_i*10+9:gv_i*10]),
            .ifm_rd_en(ifm_rd_en[gv_i]),

            .ifm_wr_en(ifm_wr_en[gv_i]),
            .ifm_wr_addr(ifm_wr_addr[gv_i*5+4:gv_i*5]),
            .pixels_out(pixels_out[gv_i*128+127:gv_i*128])
        );
    end
endgenerate

assign i2c_ready     = temp_wire[0];
assign tile_continue = continue_wire[0];
assign i2c_done      = done_wire[0];

endmodule