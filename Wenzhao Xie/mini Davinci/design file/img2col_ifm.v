`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie wenzhao
// 
// Create Date: 2019/11/02 11:06:03
// Design Name: sDavinci
// Module Name: img2col_ifm
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module img2col_ifm
#(parameter SIZE=8, DATA_WID=16)
    (
    input               clock,
    input               rst_n,
    input               i2c_ifm_start,

    input       [2:0]   ksize,          // 此数据应从寄存器中读到:1,3,5
    input       [5:0]   tile_length,    // 此数据应从寄存器中读到
    input       [5:0]   tile_height,    // 此数据应从寄存器中读到
    input       [3:0]   valid_num,      // 此数据应从寄存器中读到

    output reg          i2c_ready,      // 此项为TRUE时说明本单元准备好传输新的一轮ifmap pixels（一个kernel大小）
    output reg          i2c_done,
    // Above control side

    // Below ifmap transmition side

    input               addr_valid,     // 控制img2col_ifm单元通断
    input       [9:0]   base_addr,      // 将要传输的ifmap区域的首地址（kernel的左上角）
    input       [SIZE*DATA_WID-1:0] pixels_in,

    output reg          tile_continue,
    output reg          ifm_rd_en,      // ifmap tile读取使能
    output reg  [9:0]   ifm_rd_addr,    // ifmap tile pixel读取地址

    output wire         ifm_wr_en,      // ifmap matrix buffer写使能
    output reg  [4:0]   ifm_wr_addr,
    output wire [SIZE*DATA_WID-1:0] pixels_out
);

localparam TRUE        = 1,
           FALSE       = 0,
           rd2wr_delay = 2;

reg [2:0] current_state;
reg [2:0] next_state;
localparam IDLE    = 'b001,
           PREPARE = 'b010,
           RUN     = 'b100;

reg [3:0] cnt_length;   // 记录行传输坐标
reg [3:0] cnt_height;   // 记录列传输坐标
reg [4:0] cnt_trans;    // 记录已传输的pixel个数

reg       wr_en_delay_reg;
reg [4:0] wr_addr_delay_reg0,wr_addr_delay_reg1;

always@(posedge clock or negedge rst_n) begin  // current_state状态转换
    if(!rst_n) current_state <= IDLE;
    else current_state <= next_state;
end

always@(*) begin                               // next_state状态转换
    if(!rst_n) next_state = IDLE;
    else begin
        case(current_state)
            IDLE: begin
                if((i2c_ifm_start==TRUE)) next_state = PREPARE; //&&(addr_valid==TRUE)
                else next_state = IDLE;
            end
            PREPARE: next_state <= RUN;
            RUN: begin
                if(cnt_trans == ksize**2 + 2) next_state = IDLE;
                else next_state = RUN;
            end
            default: next_state = IDLE;
        endcase
    end
end

reg       addr_valid_reg;
reg [9:0] base_addr_reg;
always@(posedge clock or negedge rst_n) begin   // state状态行为
    if(!rst_n) begin
        i2c_ready      <= TRUE;
        i2c_done       <= FALSE;
        ifm_rd_en      <= FALSE;
        tile_continue  <= FALSE;
        addr_valid_reg <= FALSE;
        base_addr_reg  <= FALSE;
    end
    else begin
        case(current_state)
            IDLE: begin
                i2c_ready  <= TRUE;
                i2c_done   <= FALSE;
                ifm_rd_en  <= FALSE;
                cnt_height <= 'b0;
                cnt_length <= 'b0;
                cnt_trans  <= 'b0;
                if(i2c_ifm_start == TRUE) begin
                    i2c_ready      <= FALSE;
                    tile_continue  <= TRUE;
                end
            end
            PREPARE: begin
                tile_continue  <= FALSE;
                addr_valid_reg <= addr_valid;       // TODO:这里注意
                base_addr_reg  <= base_addr;
            end
            RUN: begin
                
                if(cnt_trans<ksize**2 + 2) begin
                    ifm_rd_en <= TRUE;
                    cnt_trans <= cnt_trans + 1;
                end
                else begin
                    ifm_rd_en <= FALSE;
                    i2c_ready <= TRUE;
                    i2c_done  <= TRUE;
                end

                if(cnt_trans<ksize**2) begin
                    ifm_rd_addr <= base_addr_reg + cnt_height*tile_length + cnt_length;
                    if(cnt_length != ksize-1) begin
                        cnt_length <= cnt_length + 1;
                    end
                    else begin
                        cnt_length <= 'b0;
                        cnt_height <= cnt_height + 1;
                    end
                end
                else ifm_rd_addr <= 'b0;
            end
            default: ;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin   // wr enable signal generate
    if(!rst_n) begin
        wr_addr_delay_reg0 <= 'b0;
        wr_addr_delay_reg1 <= 'b0;
        ifm_wr_addr        <= 'b0;
    end
    else begin
        wr_addr_delay_reg0 <= cnt_trans;
        wr_addr_delay_reg1 <= wr_addr_delay_reg0;
        ifm_wr_addr        <= wr_addr_delay_reg1;
    end
end
assign ifm_wr_en  = (cnt_trans > rd2wr_delay) ? ifm_rd_en : FALSE;
assign pixels_out = ifm_wr_en ? (addr_valid_reg ? pixels_in : 'b0) : 'b0;

endmodule