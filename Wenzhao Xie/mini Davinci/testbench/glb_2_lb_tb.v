`timescale 1ns/1ps
// Created date: 2019/12/20
// Creator: Xie Wenzhao

module glb_2_lb_tb();

localparam TRUE  = 1,
           FALSE = 0;

reg          clock;
reg          rst_n;
reg          test_go;
initial begin
    clock = 0;
    forever #5 clock = ~clock;
end
initial begin
    rst_n     = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
    test_go   = TRUE;
end

//reg  trans_start;
wire trans_end;

reg  [14:0]  base_addr;
reg  [7:0]   big_length;
reg  [5:0]   length;
reg  [5:0]   height;

wire         rd_en;
wire [14:0]  rd_addr;
reg  [127:0] data_in;

wire         wr_en;
wire [9:0]   wr_addr;
wire [127:0] data_out;

glb_2_lb glb_2_lb_inst(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(test_go),
    .trans_end(trans_end),

    .base_addr(base_addr),
    .big_length(big_length),
    .length(length),
    .height(height),

    .rd_en(rd_en),
    .rd_addr(rd_addr),
    .data_in(data_in),

    .wr_en(wr_en),
    .wr_addr(wr_addr),
    .data_out(data_out)
);

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        base_addr  <= 0;
        big_length <= 3;
        length     <= 3;
        height     <= 3;
    end
    else if(test_go) begin
        if(trans_end == TRUE) test_go <= FALSE;
    end
end

endmodule