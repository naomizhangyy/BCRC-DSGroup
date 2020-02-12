`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// 
// Create Date: 2019/10/15 15:42:59
// Design Name: sDavinci
// Module Name: cmp_layer
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module cmp_layer
#(parameter DATA_WID=16, SIZE=8)
    (
    input clock,
    input rst_n,
    input [DATA_WID*SIZE-1:0] weights,
    input [DATA_WID*SIZE-1:0] pixels,
    
    output [32*SIZE*SIZE-1:0] psums_out
);

wire [15:0] wgt_wire [SIZE-1:0];
wire [15:0] ifm_wire [SIZE-1:0];
wire [31:0] mul_wire [SIZE*SIZE-1:0];

genvar gv_ifm,gv_wgt;

generate
    for(gv_ifm=0;gv_ifm<SIZE;gv_ifm=gv_ifm+1)
    begin
        assign ifm_wire[gv_ifm] = pixels[gv_ifm*16+15:gv_ifm*16];
    end
endgenerate

generate
    for(gv_wgt=0;gv_wgt<SIZE;gv_wgt=gv_wgt+1)
    begin
        assign wgt_wire[gv_wgt] = weights[gv_wgt*16+15:gv_wgt*16];
    end
endgenerate

generate
    for(gv_ifm=0;gv_ifm<SIZE;gv_ifm=gv_ifm+1)
    begin
        for(gv_wgt=0;gv_wgt<SIZE;gv_wgt=gv_wgt+1)
        begin
            assign psums_out[gv_ifm*SIZE*32+gv_wgt*32+31:gv_ifm*SIZE*32+gv_wgt*32] = mul_wire[gv_ifm*SIZE+gv_wgt];
        end
    end
endgenerate

generate
    for(gv_ifm=0;gv_ifm<SIZE;gv_ifm=gv_ifm+1)
    begin
        for(gv_wgt=0;gv_wgt<SIZE;gv_wgt=gv_wgt+1)
        begin
            cmp_unit cmp_unit_inst(
                .clock(clock),
                .rst_n(rst_n),
                .weight(wgt_wire[gv_wgt]),
                .pixel(ifm_wire[gv_ifm]),
                .psum_out(mul_wire[gv_ifm*SIZE+gv_wgt])
            );
        end
    end
endgenerate

endmodule