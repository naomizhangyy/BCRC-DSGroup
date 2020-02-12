// Created date: 2019/12/24
// Creator: Xie Wenzhao

module bridge_i2c_buf
#(parameter SIZE=8)
    (
    input clock,
    input rst_n,
    input loop_end,
    input buf_switch,

    // buffers
    output [SIZE-1:0] ifm_rd_en_part0_0,
    output [79:0]     ifm_rd_addr_part0_0,
    input  [1023:0]   ifm_out_part0_0,

    output [SIZE-1:0] ifm_rd_en_part0_1,
    output [79:0]     ifm_rd_addr_part0_1,
    input  [1023:0]   ifm_out_part0_1,

    output [SIZE-1:0] ifm_rd_en_part1_0,
    output [79:0]     ifm_rd_addr_part1_0,
    input  [1023:0]   ifm_out_part1_0,

    output [SIZE-1:0] ifm_rd_en_part1_1,
    output [79:0]     ifm_rd_addr_part1_1,
    input  [1023:0]   ifm_out_part1_1,

    // img2col units
    output [1023:0]   pixel_2_i2c_0,
    input  [SIZE-1:0] ifm_rd_en_i2c_0,
    input  [79:0]     ifm_rd_addr_i2c_0,

    output [1023:0]   pixel_2_i2c_1,
    input  [SIZE-1:0] ifm_rd_en_i2c_1,
    input  [79:0]     ifm_rd_addr_i2c_1
);

reg buf_sel;

assign ifm_rd_en_part0_0 = !buf_sel ? ifm_rd_en_i2c_0 : 'b0;
assign ifm_rd_en_part0_1 = !buf_sel ? ifm_rd_en_i2c_1 : 'b0;
assign ifm_rd_en_part1_0 =  buf_sel ? ifm_rd_en_i2c_0 : 'b0;
assign ifm_rd_en_part1_1 =  buf_sel ? ifm_rd_en_i2c_1 : 'b0;

assign ifm_rd_addr_part0_0 = !buf_sel ? ifm_rd_addr_i2c_0 : 'b0;
assign ifm_rd_addr_part0_1 = !buf_sel ? ifm_rd_addr_i2c_1 : 'b0;
assign ifm_rd_addr_part1_0 =  buf_sel ? ifm_rd_addr_i2c_0 : 'b0;
assign ifm_rd_addr_part1_1 =  buf_sel ? ifm_rd_addr_i2c_1 : 'b0;

assign pixel_2_i2c_0 = buf_sel ? ifm_out_part1_0 : ifm_out_part0_0;
assign pixel_2_i2c_1 = buf_sel ? ifm_out_part1_1 : ifm_out_part0_1;

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        buf_sel <= 0;
    end
    else begin
        if(loop_end == 1) buf_sel <= 0;
        else if(buf_switch == 1) buf_sel <= ~buf_sel;
    end
end

endmodule