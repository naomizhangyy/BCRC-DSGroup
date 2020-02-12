module kernel_buffer
#(parameter SIZE=8)  
    (
    input             clock,

    input             wea,
    input  [4:0]      addra,

    input  [127:0]    dina_0,
    input  [127:0]    dina_1,
    input  [127:0]    dina_2,
    input  [127:0]    dina_3,
    input  [127:0]    dina_4,
    input  [127:0]    dina_5,
    input  [127:0]    dina_6,
    input  [127:0]    dina_7,

    input  [SIZE-1:0] enb,
    input  [39:0]     addrb,
    output [1023:0]   doutb
);

blk_mem_gen_0 kernel_buffer_0(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_0),

    .clkb(clock),
    .enb(enb[0]),
    .addrb(addrb[0*5+4:0*5]),
    .doutb(doutb[0*128+127:0*128]));

blk_mem_gen_0 kernel_buffer_1(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_1),

    .clkb(clock),
    .enb(enb[1]),
    .addrb(addrb[1*5+4:1*5]),
    .doutb(doutb[1*128+127:1*128]));

blk_mem_gen_0 kernel_buffer_2(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_2),

    .clkb(clock),
    .enb(enb[2]),
    .addrb(addrb[2*5+4:2*5]),
    .doutb(doutb[2*128+127:2*128]));

blk_mem_gen_0 kernel_buffer_3(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_3),

    .clkb(clock),
    .enb(enb[3]),
    .addrb(addrb[3*5+4:3*5]),
    .doutb(doutb[3*128+127:3*128]));

blk_mem_gen_0 kernel_buffer_4(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_4),

    .clkb(clock),
    .enb(enb[4]),
    .addrb(addrb[4*5+4:4*5]),
    .doutb(doutb[4*128+127:4*128]));

blk_mem_gen_0 kernel_buffer_5(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_5),

    .clkb(clock),
    .enb(enb[5]),
    .addrb(addrb[5*5+4:5*5]),
    .doutb(doutb[5*128+127:5*128]));

blk_mem_gen_0 kernel_buffer_6(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_6),

    .clkb(clock),
    .enb(enb[6]),
    .addrb(addrb[6*5+4:6*5]),
    .doutb(doutb[6*128+127:6*128]));

blk_mem_gen_0 kernel_buffer_7(
    .clka(clock),
    .wea(wea),
    .addra(addra),
    .dina(dina_7),

    .clkb(clock),
    .enb(enb[7]),
    .addrb(addrb[7*5+4:7*5]),
    .doutb(doutb[7*128+127:7*128]));

endmodule