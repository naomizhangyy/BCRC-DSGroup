`timescale 1ns / 1ps

module ifm_chn_sel_tb();

localparam TRUE  = 1,
           FALSE = 0,
           SIZE  = 8;

reg clock;
reg rst_n;

initial begin
    #5 clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
end

reg mod_rd_start;
reg mod_rd_end;
reg sys_wr_start;
reg sys_wr_end;

wire [1:0] ifm_buf_state;

initial begin
    mod_rd_end   = FALSE;
    mod_rd_start = FALSE;
    sys_wr_start = FALSE;
    sys_wr_end   = FALSE;
    #200
    
    sys_wr_start <= TRUE;
    #10 sys_wr_start <= FALSE;

    #50
    sys_wr_end <= TRUE;
    #10 sys_wr_end <= FALSE;

    #50
    mod_rd_start <= TRUE;
    #10 mod_rd_start <= FALSE;

    #10
    sys_wr_start <= TRUE;
    #10 sys_wr_start <= FALSE;

    #50
    sys_wr_end <= TRUE;
    #10 sys_wr_end <= FALSE;

    #50
    mod_rd_end <= TRUE;
    #10 mod_rd_end <= FALSE;

    #50
    mod_rd_start <= TRUE;
    #10 mod_rd_start <= FALSE;

    #50
    sys_wr_start <= TRUE;
    #10 sys_wr_start <= FALSE;

    #50
    mod_rd_end <= TRUE;
    #10 mod_rd_end <= FALSE;

    #50
    sys_wr_end <= TRUE;
    #10 sys_wr_end <= FALSE;

    #50
    mod_rd_start <= TRUE;
    #10 mod_rd_start <= FALSE;
end

ifm_chn_sel ifm_chn_sel_inst(
    .clock(clock),
    .rst_n(rst_n),

    .mod_rd_end(mod_rd_end),
    .mod_rd_start(mod_rd_start),
    .sys_wr_end(sys_wr_end),
    .sys_wr_start(sys_wr_start),

    .ifm_buf_state(ifm_buf_state)
);

endmodule