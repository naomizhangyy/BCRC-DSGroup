// Created date: 2019/10/30
// Creator: Xie Wenzhao
//
// Description: 
//
`timescale 1ns / 1ps

module ifm_addr_gen_tb();

localparam TRUE  = 1,
           FALSE = 0;

reg clock;
reg rst_n;

initial begin
    clock = 0;
    forever #5 clock = ~clock;    
end

initial begin
    rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
end

reg tile_start;
reg tile_continue;

reg [5:0] tile_length;
reg [5:0] tile_height;
reg [2:0] stride;
reg [2:0] ksize;

wire [79:0] base_addr;
wire [7:0] base_addr_valid;
wire addr_gen_done;
wire ifmap_end;

ifm_addr_gen ifm_addr_gen_inst(
    .clock(clock),
    .rst_n(rst_n),
    .tile_start(tile_start),
    .tile_continue(tile_continue),

    .ksize(ksize),
    .stride(stride),
    .tile_length(tile_length),
    .tile_height(tile_height),

    .base_address(base_addr),
    .base_addr_valid(base_addr_valid),
    .addr_gen_done(addr_gen_done),
    .ifmap_end(ifmap_end)
);

reg continue_reg;
initial begin
    tile_start = 0;
    continue_reg = FALSE;
    #150 begin
        tile_start = 1;
        ksize = 3;
        stride = 1;
        tile_height = 28;
        tile_length = 28;
    end
    
    wait(addr_gen_done == TRUE) begin
        tile_start = 0;
        continue_reg = TRUE;
        tile_continue = 0;
    end
end

always@(posedge clock) begin
    if(continue_reg == TRUE) begin
        tile_continue <= ~tile_continue;
        if(ifmap_end == TRUE) begin
            continue_reg <= FALSE;
            tile_continue <= FALSE;
        end
    end
end

endmodule