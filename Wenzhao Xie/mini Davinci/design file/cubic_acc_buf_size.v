// Created date: 2019/12/1
// Creator: Xie Wenzhao

module cubic_acc_buf_size
#(parameter SIZE = 8, DATA_WID = 16)
    (
    input                      clock,
    input                      rst_n,

    input  [1:0]               pool_size,
    input  [5:0]               tile_height,
    input  [5:0]               tile_length,
    input  [2:0]               ksize,
    input  [2:0]               stride,
    input  [4:0]               qtf_mod_sel,
    input                      pooling_mod_sel,
 
    input                      new_tile,
    input                      qtf_start,
    input                      pooling_start,
    input                      psums_valid,
    input  [2239:0]            psums,        // 256*8
    input                      one_buf_end,

    input  [127:0]             eight_bias,
    output                     res_valid,
    output [DATA_WID*SIZE-1:0] res_pool
);

wire [279:0] psums_wire        [SIZE-1:0];
wire         valid_wire        [SIZE-1:0];

genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        assign psums_wire[gv_i] = psums[gv_i*280+279:gv_i*280];
    end
endgenerate

generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        cubic_acc_buf cubic_acc_buf_inst(
            .clock(clock),
            .rst_n(rst_n),

            .pool_size(pool_size),
            .tile_height(tile_height),
            .tile_length(tile_length),
            .ksize(ksize),
            .stride(stride),
            .qtf_mod_sel(qtf_mod_sel),
            .pooling_mod_sel(pooling_mod_sel),

            .new_tile(new_tile),
            .qtf_start(qtf_start),
            .pooling_start(pooling_start),
            .psums_valid(psums_valid),
            .psums(psums_wire[gv_i]),
            .one_buf_end(one_buf_end),

            .bias(eight_bias[gv_i*DATA_WID+15:gv_i*DATA_WID]),
            .res_valid(valid_wire[gv_i]),
            .res_pool(res_pool[gv_i*DATA_WID+15:gv_i*DATA_WID])
        );
    end
endgenerate

assign res_valid    = valid_wire[0];

endmodule