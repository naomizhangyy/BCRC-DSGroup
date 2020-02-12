// Created date: 2019/12/23
// Creator: Xie Wenzhao

module ifm_chn_sel(
    input             clock,
    input             rst_n,
    input             loop_end,
    input             buf_in_switch,

    input             ifm_wr_en,
    input  [9:0]      ifm_wr_addr,
    input  [127:0]    ifm_in,

    output            ifm_wr_en_0,
    output [9:0]      ifm_wr_addr_0,
    output [127:0]    ifm_in_0,

    output            ifm_wr_en_1,
    output [9:0]      ifm_wr_addr_1,
    output [127:0]    ifm_in_1
);

localparam TRUE  = 1,
           FALSE = 0;

reg       chn_sel;

assign ifm_wr_en_0   = !chn_sel ? ifm_wr_en   : FALSE;
assign ifm_wr_addr_0 = !chn_sel ? ifm_wr_addr : 'b0;
assign ifm_in_0      = !chn_sel ? ifm_in      : 'b0; 

assign ifm_wr_en_1   =  chn_sel ? ifm_wr_en   : FALSE;
assign ifm_wr_addr_1 =  chn_sel ? ifm_wr_addr : 'b0;
assign ifm_in_1      =  chn_sel ? ifm_in      : 'b0; 

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        chn_sel <= 0;
    end
    else begin
        if(loop_end == TRUE) chn_sel <= 0;
        else if(buf_in_switch == TRUE) chn_sel <= ~chn_sel;
    end
end

endmodule