`timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/17 15:54:21
// Design Name: sDavinci
// Module Name: img2col_weight_size
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// //////////////////////////////////////////////////////////////////

module img2col_weight_size
#(parameter SIZE=8)
    (
    input clock,
    input rst_n,
    input i2c_wgt_start,

    input  [2:0]      kernel_size,
    input  [1023:0]   wgt_in     ,
    input  [3:0]      valid_num  ,

    output            i2c_ready  ,
    output [39:0]     wgt_rd_addr,
    output [SIZE-1:0] wgt_rd_en  ,

    output [39:0]     wgt_wr_addr,
    output [SIZE-1:0] wgt_wr_en  ,
    output [1023:0]   wgt_out
);

wire temp_wire [SIZE-1:0];

genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        img2col_weight img2col_weight_inst(
            .clock          (clock),
            .rst_n          (rst_n),
            .i2c_wgt_start  (i2c_wgt_start),

            .kernel_size    (kernel_size),
            .wgt_in         (wgt_in[gv_i*128+127:gv_i*128]),
            .valid_num      (valid_num),
            
            .i2c_ready      (temp_wire[gv_i]),

            .wgt_rd_addr    (wgt_rd_addr[gv_i*5+4:gv_i*5]),
            .wgt_rd_en      (wgt_rd_en[gv_i]),
            
            .wgt_wr_addr    (wgt_wr_addr[gv_i*5+4:gv_i*5]),
            .wgt_wr_en      (wgt_wr_en[gv_i]),

            .wgt_out        (wgt_out[gv_i*128+127:gv_i*128])
        );
    end
endgenerate

assign i2c_ready = temp_wire[0];

endmodule