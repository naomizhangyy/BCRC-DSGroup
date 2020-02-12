//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2020/01/27 12:17:32
// Design Name: sDavinci
// Module Name: test_module
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module dla_logic
#(parameter SIZE=8, DATA_WID=16)
    (
    input clock,
    input rst_n,

    // Global
    input [5:0] tile_length,
    input [5:0] tile_height,
    input [2:0] stride,
    input [2:0] ksize,
    input [3:0] valid_num,

    input       i2c_go,
    output      i2c_pulse,

    // Ifm_addr_gen
    input            tile_start,
    output           addr_gen_done,
    output           ifmap_end,

    // global ifmap buffer to local ifmap buffer
    input            ifm_wr_en,
    input [9:0]      ifm_wr_addr,
    input [127:0]    ifm_in,

    // ifm_chn_sel
    input            buf_in_switch,
    input            loop_end,

    // bridge_i2c_buf
    input            buf_switch,
    //input            loop_end,

    // kernel buffer
    input            wgt_wr_en,
    input [4:0]      wgt_wr_addr,
    input [127:0]    wgt_in_0,
    input [127:0]    wgt_in_1,
    input [127:0]    wgt_in_2,
    input [127:0]    wgt_in_3,
    input [127:0]    wgt_in_4,
    input [127:0]    wgt_in_5,
    input [127:0]    wgt_in_6,
    input [127:0]    wgt_in_7,

    // Arbitrator
    output         i2c_ready,
    output         buf_empty_ifm,

    // Img2col_weight_size
    input          i2c_wgt_start,
    output         i2c_ready_wgt,

    // Wgt_buffer_size
    output         buf_empty_wgt,

    // Matrix fetcher
    input          matrix_go,
    output         one_buf_end,
    
    // cubic_acc_buf
    input [1:0]    pool_size,
    input          new_tile,
    input [4:0]    qtf_mod_sel,
    input          pooling_mod_sel,
    input          qtf_start,
    input          pooling_start,
    input [127:0]  bias,
     
    // pool_mem
    input  [2:0]   pad_size,
    input  [3:0]   pad_mod_sel,
    input          tile_dump,
    output         dump_end,
    input  [5:0]   tile_height_to_qtf,
    input  [5:0]   tile_length_to_qtf,
    output         pad_end,
    
    // lb_2_glb
    input  [15:0]  of_base_addr,
    input  [15:0]  of_page_length,
    output         of_wr_en,
    output [15:0]  of_wr_addr,
    output [127:0] of_wr_data
);

// ifmap buffers of part 0 share the same input interface
wire            tile_ifm_wr_en_0;
wire [9:0]      tile_ifm_wr_addr_0;
wire [127:0]    ifm_in_0;

wire [SIZE-1:0] ifm_rd_en_part0_0;
wire [79:0]     ifm_rd_addr_part0_0;
wire [1023:0]   ifm_out_part0_0;
tile_buffer tile_buffer_inst_part0_0(
    .clock  (clock),

    .wea    (tile_ifm_wr_en_0),
    .addra  (tile_ifm_wr_addr_0),
    .dina   (ifm_in_0),

    .enb    (ifm_rd_en_part0_0),
    .addrb  (ifm_rd_addr_part0_0),
    .doutb  (ifm_out_part0_0)
);

wire [SIZE-1:0] ifm_rd_en_part0_1;
wire [79:0]     ifm_rd_addr_part0_1;
wire [1023:0]   ifm_out_part0_1;
tile_buffer tile_buffer_inst_part0_1(
    .clock  (clock),

    .wea    (tile_ifm_wr_en_0),
    .addra  (tile_ifm_wr_addr_0),
    .dina   (ifm_in_0),

    .enb    (ifm_rd_en_part0_1),
    .addrb  (ifm_rd_addr_part0_1),
    .doutb  (ifm_out_part0_1)
);

// ifmap buffers of part 1 share the same input interface
wire            tile_ifm_wr_en_1;
wire [9:0]      tile_ifm_wr_addr_1;
wire [127:0]    ifm_in_1;

wire [SIZE-1:0] ifm_rd_en_part1_0;
wire [79:0]     ifm_rd_addr_part1_0;
wire [1023:0]   ifm_out_part1_0;
tile_buffer tile_buffer_inst_part1_0(
    .clock  (clock),

    .wea    (tile_ifm_wr_en_1),
    .addra  (tile_ifm_wr_addr_1),
    .dina   (ifm_in_1),

    .enb    (ifm_rd_en_part1_0),
    .addrb  (ifm_rd_addr_part1_0),
    .doutb  (ifm_out_part1_0)
);


wire [SIZE-1:0] ifm_rd_en_part1_1;
wire [79:0]     ifm_rd_addr_part1_1;
wire [1023:0]   ifm_out_part1_1;
tile_buffer tile_buffer_inst_part1_1(
    .clock  (clock),

    .wea    (tile_ifm_wr_en_1),
    .addra  (tile_ifm_wr_addr_1),
    .dina   (ifm_in_1),

    .enb    (ifm_rd_en_part1_1),
    .addrb  (ifm_rd_addr_part1_1),
    .doutb  (ifm_out_part1_1)
);

ifm_chn_sel ifm_chn_sel_inst(
    .clock(clock),
    .rst_n(rst_n),
    .loop_end(loop_end),
    .buf_in_switch(buf_in_switch),

    .ifm_wr_en(ifm_wr_en),
    .ifm_wr_addr(ifm_wr_addr),
    .ifm_in(ifm_in),

    .ifm_wr_en_0(tile_ifm_wr_en_0),
    .ifm_wr_addr_0(tile_ifm_wr_addr_0),
    .ifm_in_0(ifm_in_0),

    .ifm_wr_en_1(tile_ifm_wr_en_1),
    .ifm_wr_addr_1(tile_ifm_wr_addr_1),
    .ifm_in_1(ifm_in_1)
);

wire [SIZE-1:0] wgt_rd_en;
wire [39:0]     wgt_rd_addr;
wire [1023:0]   wgt_2_i2c;
kernel_buffer kernel_buffer_inst(
    .clock  (clock),

    .wea    (wgt_wr_en),
    .addra  (wgt_wr_addr),
    .dina_0 (wgt_in_0),
    .dina_1 (wgt_in_1),
    .dina_2 (wgt_in_2),
    .dina_3 (wgt_in_3),
    .dina_4 (wgt_in_4),
    .dina_5 (wgt_in_5),
    .dina_6 (wgt_in_6),
    .dina_7 (wgt_in_7),

    .enb    (wgt_rd_en),
    .addrb  (wgt_rd_addr),
    .doutb  (wgt_2_i2c));

wire            tile_continue;
wire [79:0]     base_addr;
wire [SIZE-1:0] base_addr_valid;
ifm_addr_gen ifm_addr_gen_inst(
    .clock          (clock),
    .rst_n          (rst_n),
    .tile_start     (tile_start),
    .tile_continue  (tile_continue),

    .tile_length    (tile_length),
    .tile_height    (tile_height),
    .stride         (stride),
    .ksize          (ksize),
    .addr_gen_done  (addr_gen_done),
    .ifmap_end      (ifmap_end),

    // Internal side
    .base_address   (base_addr),
    .base_addr_valid(base_addr_valid)
);

wire            i2c_ifm_start_0;
wire            i2c_ok_0;
wire            i2c_done_0;
wire            tile_continue_0;
wire [SIZE-1:0] ifm_wr_enable_0;
wire [39:0]     ifm_wr_address_0;
wire [1023:0]   pixels_from_i2c_0;

wire [1023:0]   pixel_2_i2c_0;
wire [SIZE-1:0] ifm_rd_en_i2c_0;
wire [79:0]     ifm_rd_addr_i2c_0;

img2col_ifm_size img2col_ifm_size_inst_0(
    .clock          (clock),
    .rst_n          (rst_n),
    .i2c_ifm_start  (i2c_ifm_start_0),

    .ksize          (ksize),
    .tile_height    (tile_height),
    .tile_length    (tile_length),
    .valid_num      (valid_num),

    .tile_continue  (tile_continue_0),
    .i2c_ready      (i2c_ok_0),
    .i2c_done       (i2c_done_0),

    .pixels_in      (pixel_2_i2c_0),
    .ifm_rd_en      (ifm_rd_en_i2c_0),
    .ifm_rd_addr    (ifm_rd_addr_i2c_0),

    // Internal side
    .addr_valid     (base_addr_valid),
    .base_addr      (base_addr),
    .ifm_wr_en      (ifm_wr_enable_0),
    .ifm_wr_addr    (ifm_wr_address_0),
    .pixels_out     (pixels_from_i2c_0)
);

wire            i2c_ifm_start_1;
wire            i2c_ok_1;
wire            i2c_done_1;
wire            tile_continue_1;
wire [SIZE-1:0] ifm_wr_enable_1;
wire [39:0]     ifm_wr_address_1;
wire [1023:0]   pixels_from_i2c_1;

wire [1023:0]   pixel_2_i2c_1;
wire [SIZE-1:0] ifm_rd_en_i2c_1;
wire [79:0]     ifm_rd_addr_i2c_1;

img2col_ifm_size img2col_ifm_size_inst_1(
    .clock          (clock),
    .rst_n          (rst_n),
    .i2c_ifm_start  (i2c_ifm_start_1),

    .ksize          (ksize),
    .tile_height    (tile_height),
    .tile_length    (tile_length),
    .valid_num      (valid_num),

    .tile_continue  (tile_continue_1),
    .i2c_ready      (i2c_ok_1),
    .i2c_done       (i2c_done_1),

    .pixels_in      (pixel_2_i2c_1),
    .ifm_rd_en      (ifm_rd_en_i2c_1),
    .ifm_rd_addr    (ifm_rd_addr_i2c_1),

    // Internal side
    .addr_valid     (base_addr_valid),
    .base_addr      (base_addr),
    .ifm_wr_en      (ifm_wr_enable_1),
    .ifm_wr_addr    (ifm_wr_address_1),
    .pixels_out     (pixels_from_i2c_1)
);

bridge_i2c_buf bridge_i2c_buf_inst(
    .clock                (clock),
    .rst_n                (rst_n),
    .loop_end             (loop_end),
    .buf_switch           (buf_switch),

    .ifm_rd_en_part0_0    (ifm_rd_en_part0_0),
    .ifm_rd_addr_part0_0  (ifm_rd_addr_part0_0),
    .ifm_out_part0_0      (ifm_out_part0_0),

    .ifm_rd_en_part0_1    (ifm_rd_en_part0_1),
    .ifm_rd_addr_part0_1  (ifm_rd_addr_part0_1),
    .ifm_out_part0_1      (ifm_out_part0_1),

    .ifm_rd_en_part1_0    (ifm_rd_en_part1_0),
    .ifm_rd_addr_part1_0  (ifm_rd_addr_part1_0),
    .ifm_out_part1_0      (ifm_out_part1_0),

    .ifm_rd_en_part1_1    (ifm_rd_en_part1_1),
    .ifm_rd_addr_part1_1  (ifm_rd_addr_part1_1),
    .ifm_out_part1_1      (ifm_out_part1_1),

    .pixel_2_i2c_0        (pixel_2_i2c_0),
    .ifm_rd_en_i2c_0      (ifm_rd_en_i2c_0),
    .ifm_rd_addr_i2c_0    (ifm_rd_addr_i2c_0),

    .pixel_2_i2c_1        (pixel_2_i2c_1),
    .ifm_rd_en_i2c_1      (ifm_rd_en_i2c_1),
    .ifm_rd_addr_i2c_1    (ifm_rd_addr_i2c_1)
);

wire [4:0]      fetch_num;
wire            buf_empty_0;
wire            buf_empty_1;
wire            buf_empty_2;
wire [SIZE-1:0] ifm_wr_en_0;
wire [SIZE-1:0] ifm_wr_en_1;
wire [SIZE-1:0] ifm_wr_en_2;
wire [39:0]     ifm_wr_addr_0;
wire [39:0]     ifm_wr_addr_1;
wire [39:0]     ifm_wr_addr_2;
wire            i2c_ready_0;
wire            i2c_ready_1;
wire            i2c_ready_2;
wire            i2c_finish_0;
wire            i2c_finish_1;
wire            i2c_finish_2;
wire [1023:0]   pixels_to_buffer_0;
wire [1023:0]   pixels_to_buffer_1;
wire [1023:0]   pixels_to_buffer_2;
wire            fetch_en_0;
wire            fetch_en_1;
wire            fetch_en_2;
wire [1023:0]   pixels_to_cubic_0;
wire [1023:0]   pixels_to_cubic_1;
wire [1023:0]   pixels_to_cubic_2;

ifm_buffer_size ifm_buffer_size_inst_0(
    .clock          (clock),
    .rst_n          (rst_n),
    .ksize          (ksize),
    .buf_empty      (buf_empty_0),
    .valid_num      (valid_num),

    // Internal side
    .ifm_wr_en      (ifm_wr_en_0),
    .ifm_wr_addr    (ifm_wr_addr_0),
    .i2c_ready      (i2c_ready_0),
    .i2c_done       (i2c_finish_0),
    .pixels_in      (pixels_to_buffer_0),

    .cubic_fetch_en   (fetch_en_0),
    .fetch_num        (fetch_num),
    .pixels_to_cubic  (pixels_to_cubic_0)
);

ifm_buffer_size ifm_buffer_size_inst_1(
    .clock          (clock),
    .rst_n          (rst_n),
    .ksize          (ksize),
    .buf_empty      (buf_empty_1),
    .valid_num      (valid_num),

    // Internal side
    .ifm_wr_en      (ifm_wr_en_1),
    .ifm_wr_addr    (ifm_wr_addr_1),
    .i2c_ready      (i2c_ready_1),
    .i2c_done       (i2c_finish_1),
    .pixels_in      (pixels_to_buffer_1),

    .cubic_fetch_en   (fetch_en_1),
    .fetch_num        (fetch_num),
    .pixels_to_cubic  (pixels_to_cubic_1)
);

ifm_buffer_size ifm_buffer_size_inst_2(
    .clock          (clock),
    .rst_n          (rst_n),
    .ksize          (ksize),
    .buf_empty      (buf_empty_2),
    .valid_num      (valid_num),

    // Internal side
    .ifm_wr_en      (ifm_wr_en_2),
    .ifm_wr_addr    (ifm_wr_addr_2),
    .i2c_ready      (i2c_ready_2),
    .i2c_done       (i2c_finish_2),
    .pixels_in      (pixels_to_buffer_2),

    .cubic_fetch_en   (fetch_en_2),
    .fetch_num        (fetch_num),
    .pixels_to_cubic  (pixels_to_cubic_2)
);

arbitrator arbitrator_inst(
    .clock(clock),
    .rst_n(rst_n),

    .tile_continue(tile_continue),
    .i2c_ready(i2c_ready),
    .buf_empty(buf_empty_ifm),
    .i2c_pulse(i2c_pulse),
    .i2c_go(i2c_go),

    // img2col unit 0 interface
    .i2c_ifm_start_0(i2c_ifm_start_0),
    .i2c_ok_0       (i2c_ok_0),
    .i2c_done_0     (i2c_done_0),
    .tile_continue_0(tile_continue_0),
    .ifm_wr_enable_0(ifm_wr_enable_0),
    .ifm_wr_address_0(ifm_wr_address_0),
    .pixels_from_i2c_0(pixels_from_i2c_0),

    // img2col unit 1 interface
    .i2c_ifm_start_1(i2c_ifm_start_1),
    .i2c_ok_1       (i2c_ok_1),
    .i2c_done_1     (i2c_done_1),
    .tile_continue_1(tile_continue_1),
    .ifm_wr_enable_1(ifm_wr_enable_1),
    .ifm_wr_address_1(ifm_wr_address_1),
    .pixels_from_i2c_1(pixels_from_i2c_1),

    // ifmap buffer 0 interface
    .buf_empty_0(buf_empty_0),
    .ifm_wr_en_0(ifm_wr_en_0),
    .ifm_wr_addr_0(ifm_wr_addr_0),
    .i2c_ready_0(i2c_ready_0),
    .i2c_finish_0(i2c_finish_0),
    .pixels_to_buffer_0(pixels_to_buffer_0),

    // ifmap buffer 1 interface
    .buf_empty_1(buf_empty_1),
    .ifm_wr_en_1(ifm_wr_en_1),
    .ifm_wr_addr_1(ifm_wr_addr_1),
    .i2c_ready_1(i2c_ready_1),
    .i2c_finish_1(i2c_finish_1),
    .pixels_to_buffer_1(pixels_to_buffer_1),

    // ifmap buffer 2 interface
    .buf_empty_2(buf_empty_2),
    .ifm_wr_en_2(ifm_wr_en_2),
    .ifm_wr_addr_2(ifm_wr_addr_2),
    .i2c_ready_2(i2c_ready_2),
    .i2c_finish_2(i2c_finish_2),
    .pixels_to_buffer_2(pixels_to_buffer_2)
);

wire            i2c_ready_wgt_to_buffer;
wire [39:0]     wgt_wr_addr_2buf;
wire [SIZE-1:0] wgt_wr_en_2buf;
wire [1023:0]   wgt_out;
img2col_weight_size img2col_weight_size_inst(
    .clock          (clock),
    .rst_n          (rst_n),
    .i2c_wgt_start  (i2c_wgt_start),

    .kernel_size    (ksize),
    .wgt_in         (wgt_2_i2c),
    .valid_num      (valid_num),

    .i2c_ready      (i2c_ready_wgt_to_buffer),
    .wgt_rd_addr    (wgt_rd_addr),
    .wgt_rd_en      (wgt_rd_en),

    // Internal side
    .wgt_wr_addr    (wgt_wr_addr_2buf),
    .wgt_wr_en      (wgt_wr_en_2buf),
    .wgt_out        (wgt_out)
);
assign i2c_ready_wgt = i2c_ready_wgt_to_buffer;

wire [1023:0] weights_to_cubic;
wire wgt_fetch_en;
assign wgt_fetch_en = fetch_en_0 || fetch_en_1 || fetch_en_2;
wgt_buffer_size wgt_buffer_size_inst(
    .clock          (clock),
    .rst_n          (rst_n),
    .ksize          (ksize),

    .wgt_wr_en      (wgt_wr_en_2buf),
    .wgt_wr_addr    (wgt_wr_addr_2buf),
    .i2c_ready      (i2c_ready_wgt_to_buffer),
    .weights_in     (wgt_out),
    .valid_num      (valid_num),
    .buf_empty_wgt  (buf_empty_wgt),

    .cubic_fetch_en   (wgt_fetch_en),
    .fetch_num        (fetch_num),
    .weights_to_cubic (weights_to_cubic)
);

wire matrix_valid;
wire [1023:0] ifm_matrix_out;
wire [1023:0] wgt_matrix_out;
matrix_fetcher matrix_fetcher_inst(
    .clock          (clock),
    .rst_n          (rst_n),
    .matrix_go      (matrix_go),
    .ksize          (ksize),

    .ifm_buf_empty_0(buf_empty_0),
    .ifm_buf_empty_1(buf_empty_1),
    .ifm_buf_empty_2(buf_empty_2),
    .ifm_matrix_in_0(pixels_to_cubic_0),
    .ifm_matrix_in_1(pixels_to_cubic_1),
    .ifm_matrix_in_2(pixels_to_cubic_2),
    .wgt_matrix_in  (weights_to_cubic),

    .matrix_valid   (matrix_valid),
    .one_buf_end    (one_buf_end),

    .fetch_en_0     (fetch_en_0),
    .fetch_en_1     (fetch_en_1),
    .fetch_en_2     (fetch_en_2),
    .fetch_num      (fetch_num),
    .ifm_matrix_out (ifm_matrix_out),
    .wgt_matrix_out (wgt_matrix_out)
);

wire [2239:0] acc_out;
cmp_cubic cmp_cubic_inst(
    .clock      (clock),
    .rst_n      (rst_n),

    .weights    (wgt_matrix_out),
    .pixels     (ifm_matrix_out),
    .acc_out    (acc_out)
);

wire         res_valid;
wire [127:0] res_pool;
cubic_acc_buf_size cubic_acc_buf_size_inst(
    .clock              (clock),
    .rst_n              (rst_n),

    .pool_size          (pool_size),
    .tile_height        (tile_height),
    .tile_length        (tile_length),
    .ksize              (ksize),
    .stride             (stride),
    .qtf_mod_sel        (qtf_mod_sel),
    .pooling_mod_sel    (pooling_mod_sel),

    .new_tile           (new_tile),
    .qtf_start          (qtf_start),
    .pooling_start      (pooling_start),
    .psums_valid        (matrix_valid),
    .psums              (acc_out),
    .one_buf_end        (one_buf_end),

    .eight_bias         (bias),
    .res_valid          (res_valid),
    .res_pool           (res_pool)
);
wire         tile_valid;
wire [127:0] tile_pixel;
wire [4:0]   dump_height;
wire [4:0]   dump_length;
pool_mem pool_mem_inst(
    .clock          (clock),
    .rst_n          (rst_n),
    
    .ksize          (ksize),
    .stride         (stride),

    .pad_size       (pad_size),
    .pad_mod_sel    (pad_mod_sel),
    .res_pool       (res_pool),
    .res_valid      (res_valid),

    .tile_dump      (tile_dump),
    .tile_valid     (tile_valid),
    .tile_pixel     (tile_pixel),
    .dump_end       (dump_end),

    .dump_length    (dump_length),
    .dump_height    (dump_height),
    
    .tile_length_to_qtf(tile_length_to_qtf),
    .tile_height_to_qtf(tile_height_to_qtf),
    .pad_end           (pad_end)
);

lb_2_glb lb_2_glb_inst(
    .clock              (clock),
    .rst_n              (rst_n),
    .pixel_valid        (tile_valid),
    .of_base_addr       (of_base_addr),
    .of_page_length     (of_page_length),
    .of_tile_length     (dump_length),
    .of_tile_height     (dump_height),
    .tile_pixel         (tile_pixel),
    .wr_en              (of_wr_en),
    .wr_data            (of_wr_data),
    .wr_addr            (of_wr_addr)
);

endmodule