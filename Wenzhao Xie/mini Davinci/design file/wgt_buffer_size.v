`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/15 12:48:05
// Design Name: sDavinci
// Module Name: wgt_buffer_size
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description:
//
//////////////////////////////////////////////////////////////////////////////////:

module wgt_buffer_size
#(parameter DATA_WID=16, SIZE=8)
    (
    input             clock       ,
    input             rst_n       ,
    //input             wgt_buffer_refresh,

    input  [2:0]      ksize       ,
    input  [SIZE-1:0] wgt_wr_en   ,
    input  [39:0]     wgt_wr_addr ,
    input             i2c_ready   ,
    input  [1023:0]   weights_in  ,
    input  [3:0]      valid_num   ,
    output            buf_empty_wgt,

    //------------------------------
    input           cubic_fetch_en,
    input  [4:0]    fetch_num,
    output [1023:0] weights_to_cubic
);

wire temp_wire [SIZE-1:0];

wire signed [127:0] wgt_wire [SIZE-1:0];
genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        assign weights_to_cubic[128*gv_i+127:gv_i*128] = wgt_wire[gv_i];
    end
endgenerate

generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin:wgt_buffer_loop
        wgt_buffer wgt_buffer_inst(
            .clock          (clock),
            .rst_n          (rst_n),
            //.wgt_buffer_refresh(wgt_buffer_refresh),

            .ksize          (ksize),
            .wgt_wr_en      (wgt_wr_en[gv_i]),
            .wgt_wr_addr    (wgt_wr_addr[gv_i*5+4:gv_i*5]),
            .i2c_ready      (i2c_ready),
            .weights_in     (weights_in[gv_i*128+127:gv_i*128]),
            .valid_num      (valid_num),
            .buf_empty_wgt  (temp_wire[gv_i]),

            .cubic_fetch_en    (cubic_fetch_en),
            .fetch_num         (fetch_num),
            .weights_to_cubic  (wgt_wire[gv_i])
        );
    end
endgenerate
assign buf_empty_wgt = temp_wire[0];

endmodule