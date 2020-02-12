`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/19 19:29:29
// Design Name: sDavinci
// Module Name: tile_buffer
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module tile_buffer
#(parameter SIZE=8)
    (
    input             clock,
    input             wea,
    input  [9:0]      addra,
    input  [127:0]    dina,

    input  [SIZE-1:0] enb,
    input  [79:0]     addrb,
    output [1023:0]   doutb
);

blk_mem_gen_1 tile_buffer_0(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[0]),
    .addrb(addrb[9:0]),
    .doutb(doutb[0*128+127:0*128]));

blk_mem_gen_1 tile_buffer_1(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[1]),
    .addrb(addrb[19:10]),
    .doutb(doutb[1*128+127:1*128]));

blk_mem_gen_1 tile_buffer_2(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[2]),
    .addrb(addrb[29:20]),
    .doutb(doutb[2*128+127:2*128]));

blk_mem_gen_1 tile_buffer_3(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[3]),
    .addrb(addrb[39:30]),
    .doutb(doutb[3*128+127:3*128]));

blk_mem_gen_1 tile_buffer_4(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[4]),
    .addrb(addrb[49:40]),
    .doutb(doutb[4*128+127:4*128]));

blk_mem_gen_1 tile_buffer_5(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[5]),
    .addrb(addrb[59:50]),
    .doutb(doutb[5*128+127:5*128]));

blk_mem_gen_1 tile_buffer_6(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[6]),
    .addrb(addrb[69:60]),
    .doutb(doutb[6*128+127:6*128]));

blk_mem_gen_1 tile_buffer_7(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina),

    .clkb(clock),
    .enb(enb[7]),
    .addrb(addrb[79:70]),
    .doutb(doutb[7*128+127:7*128]));

endmodule