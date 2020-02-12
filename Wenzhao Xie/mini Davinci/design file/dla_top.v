//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2020/01/27 14:20:32
// Design Name: sDavinci
// Module Name: test_module
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module dla_top(
    input clock,
    input rst_n,


    //**** dla_ctrl ****//
    input  [31:0] reg_addr_wr,
    input  [31:0] reg_data_wr,
    input         reg_en_wr,

    input  [31:0] reg_addr_rd,
    output [31:0] reg_data_rd,
    input         reg_en_rd,
    //**** dla_ctrl ****//


    // dla_logic
    output         of_wr_en,
    output [15:0]  of_wr_addr,
    output [127:0] of_wr_data,


    //**** glb_2_lb ifmap ****//
    output             rd_en_glb_ifm,
    output     [15:0]  rd_addr_glb_ifm,
    input      [127:0] rd_data_glb_ifm,
    //**** glb_2_lb ifmap ****//


    //**** glb_2_lb weight ****//
    output             rd_en_glb_wgt,
    output     [7:0]   rd_addr_glb_wgt,

    input      [127:0] rd_data_glb_wgt_0,
    input      [127:0] rd_data_glb_wgt_1,
    input      [127:0] rd_data_glb_wgt_2,
    input      [127:0] rd_data_glb_wgt_3,
    input      [127:0] rd_data_glb_wgt_4,
    input      [127:0] rd_data_glb_wgt_5,
    input      [127:0] rd_data_glb_wgt_6,
    input      [127:0] rd_data_glb_wgt_7
    //**** glb_2_lb weight ****//
);


//---- interface between dla_ctrl and glb_2_lb_ifm ----//
wire        ifm_trans_start;
wire        ifm_trans_end;
wire [15:0] ifm_base_addr;
wire [7:0]  ifm_big_length;
wire [5:0]  ifm_length;
wire [5:0]  ifm_height;
//---- interface between dla_ctrl and glb_2_lb_ifm ----//


//---- interface between tile buffer and glb_2_lb_ifm ----//
wire         wr_en_ifm;
wire [9:0]   wr_addr_ifm;
wire [127:0] data_out_ifm;
//---- interface between tile buffer and glb_2_lb_ifm ----//


//---- interface between dla_ctrl and glb_2_lb_wgt ----//
wire        wgt_trans_start;
wire        wgt_trans_end;
wire [7:0]  wgt_base_addr;      //TODO: check wire width
wire [7:0]  wgt_big_length;
wire [5:0]  wgt_length;
wire [5:0]  wgt_height;
//---- interface between dla_ctrl and glb_2_lb_wgt ----//


//---- the read out interface of glb_2_lb_wgt 0~7 ----//
wire         wr_en_wgt;
wire [4:0]   wr_addr_wgt;

wire [127:0] data_out_wgt_0;
wire [127:0] data_out_wgt_1;
wire [127:0] data_out_wgt_2;
wire [127:0] data_out_wgt_3;
wire [127:0] data_out_wgt_4;
wire [127:0] data_out_wgt_5;
wire [127:0] data_out_wgt_6;
wire [127:0] data_out_wgt_7;
//---- the read out interface of glb_2_lb_wgt ----//


//---- interface between dla_ctrl and dla_logic ----//
// global
wire [5:0]  tile_length;
wire [5:0]  tile_height;
wire [2:0]  stride;
wire [2:0]  ksize;
wire [3:0]  valid_num;
wire        i2c_go;
wire        i2c_pulse;
// ifm_addr_gen
wire        tile_start;
wire        addr_gen_done;
wire        ifmap_end;
// ifm_chn_sel
wire        loop_end;
wire        buf_in_switch;
// bridge_i2c_buf
wire        buf_i2c_switch;
// arbitrator
wire        i2c_ready_ifm;
wire        buf_empty_ifm;
// img2col_weight_size
wire        i2c_ready_wgt;
wire        i2c_wgt_start;
// wgt_buffer_size
wire        buf_empty_wgt;
// matrix fetcher
wire        matrix_go;
wire        one_buf_end;
// cubic_acc_buf_size
wire [1:0]   pool_size;
wire         new_tile;
wire [4:0]   qtf_mod_sel;
wire         pool_mode;
wire         qtf_start;
wire         pool_start;
wire [127:0] bias;
// pool_mem
wire [2:0] pad_size;
wire [3:0] pad_mod_sel;
wire       tile_dump;
wire       dump_end;
wire [5:0] tile_height_to_qtf;
wire [5:0] tile_length_to_qtf;
wire       pad_end;
// lb_2_glb
wire [15:0]  of_base_addr;
wire [15:0]  of_page_length;
//---- interface between dla_ctrl and dla_logic ----//


dla_ctrl dla_ctrl_inst(
    //**** dla - soc begin ****//
    .clock          (clock),
    .rst_n          (rst_n),

    .reg_addr_wr    (reg_addr_wr),
    .reg_data_wr    (reg_data_wr),
    .reg_en_wr      (reg_en_wr),
    .reg_addr_rd    (reg_addr_rd),
    .reg_data_rd    (reg_data_rd),
    .reg_en_rd      (reg_en_rd),
    //**** dla - soc end ****//

    //**** glb_2_lb begin ****//
    // glb_2_lb_ifm
    .ifm_trans_start(ifm_trans_start),
    .ifm_trans_end  (ifm_trans_end),

    .ifm_base_addr  (ifm_base_addr),
    .ifm_big_length (ifm_big_length),
    .ifm_length     (ifm_length),
    .ifm_height     (ifm_height),

    // glb_2_lb_wgt
    .wgt_trans_start(wgt_trans_start),
    .wgt_trans_end  (wgt_trans_end),

    .wgt_base_addr  (wgt_base_addr),
    .wgt_big_length (wgt_big_length),
    .wgt_length     (wgt_length),
    .wgt_height     (wgt_height),
    //**** glb_2_lb end ****//

    //**** dla module interface begin ****//
    // global
    .tile_height    (tile_height),
    .tile_length    (tile_length),
    .stride         (stride),
    .ksize          (ksize),
    .valid_num      (valid_num),

    .i2c_go         (i2c_go),
    .i2c_pulse      (i2c_pulse),

    // ifm_addr_gen
    .tile_start     (tile_start),
    .addr_gen_done  (addr_gen_done),
    .ifmap_end      (ifmap_end),

    // ifm_chn_sel
    .loop_end       (loop_end),
    .buf_in_switch  (buf_in_switch),

    // bridge_i2c_buf
    .buf_i2c_switch (buf_i2c_switch),

    // arbitrator
    .i2c_ready_ifm  (i2c_ready_ifm),
    .buf_empty_ifm  (buf_empty_ifm),

    // img2col_weight_size
    .i2c_ready_wgt  (i2c_ready_wgt),
    .i2c_wgt_start  (i2c_wgt_start),

    // wgt_buffer_size
    .buf_empty_wgt  (buf_empty_wgt),

    // matrix fetcher
    .matrix_go      (matrix_go),
    .one_buf_end    (one_buf_end),

    // cubic_acc_buf_size
    .pool_size      (pool_size),
    .new_tile       (new_tile),
    .qtf_mod_sel    (qtf_mod_sel),
    .pool_mode      (pool_mode),
    .qtf_start      (qtf_start),
    .pool_start     (pool_start),
    .bias           (bias),

    // pool_mem
    .pad_size          (pad_size),
    .pad_mod_sel       (pad_mod_sel),
    .tile_dump         (tile_dump),
    .dump_end          (dump_end),
    .tile_height_to_qtf(tile_height_to_qtf),
    .tile_length_to_qtf(tile_length_to_qtf),
    .pad_end            (pad_end),

    // lb_2_glb
    .of_base_addr       (of_base_addr),
    .of_page_length     (of_page_length)
    //**** dla module interface end ****//
);


dla_logic dla_logic_inst(
    .clock(clock),
    .rst_n(rst_n),

    // global
    .tile_length(tile_length),
    .tile_height(tile_height),
    .stride     (stride),
    .ksize      (ksize),
    .valid_num  (valid_num),

    .i2c_go     (i2c_go),
    .i2c_pulse  (i2c_pulse),

    // ifm_addr_gen
    .tile_start    (tile_start),
    .addr_gen_done (addr_gen_done),
    .ifmap_end     (ifmap_end),

    // global ifmap buffer to local ifmap buffer
    .ifm_wr_en     (wr_en_ifm),
    .ifm_wr_addr   (wr_addr_ifm),
    .ifm_in        (data_out_ifm),

    // ifm_chn_sel
    .buf_in_switch (buf_in_switch),

    // bridge_i2c_buf
    .loop_end      (loop_end),
    .buf_switch    (buf_i2c_switch),

    // kernel buffer
    .wgt_wr_en     (wr_en_wgt),
    .wgt_wr_addr   (wr_addr_wgt),
    .wgt_in_0      (data_out_wgt_0),
    .wgt_in_1      (data_out_wgt_1),
    .wgt_in_2      (data_out_wgt_2),
    .wgt_in_3      (data_out_wgt_3),
    .wgt_in_4      (data_out_wgt_4),
    .wgt_in_5      (data_out_wgt_5),
    .wgt_in_6      (data_out_wgt_6),
    .wgt_in_7      (data_out_wgt_7),

    // arbitrator
    .i2c_ready    (i2c_ready_ifm),
    .buf_empty_ifm(buf_empty_ifm),

    // img2col_weight_size
    .i2c_wgt_start(i2c_wgt_start),
    .i2c_ready_wgt(i2c_ready_wgt),

    // matrix fetcher
    .matrix_go    (matrix_go),
    .one_buf_end  (one_buf_end),

    // wgt_buffer_size
    .buf_empty_wgt(buf_empty_wgt),

    // cubic_acc_buf
    .pool_size       (pool_size),
    .new_tile        (new_tile),
    .qtf_mod_sel     (qtf_mod_sel),
    .pooling_mod_sel (pool_mode),
    .qtf_start       (qtf_start),
    .pooling_start   (pool_start),
    .bias            (bias),

    // pool_mem
    .pad_size     (pad_size),
    .pad_mod_sel  (pad_mod_sel),
    .tile_dump    (tile_dump),
    .dump_end     (dump_end),
    .tile_height_to_qtf(tile_height_to_qtf),
    .tile_length_to_qtf(tile_length_to_qtf),
    .pad_end           (pad_end),

    // lb_2_glb
    .of_base_addr  (of_base_addr),
    .of_page_length(of_page_length),
    .of_wr_en      (of_wr_en),
    .of_wr_addr    (of_wr_addr),
    .of_wr_data    (of_wr_data) 
);


glb_2_lb #(.RD_ADDR_WID(16), .WR_ADDR_WID(10)) 
glb_2_lb_inst_ifm(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(ifm_trans_start),
    .trans_end  (ifm_trans_end),

    .base_addr  (ifm_base_addr),
    .big_length (ifm_big_length),
    .length     (ifm_length),
    .height     (ifm_height),

    .rd_en      (rd_en_glb_ifm),
    .rd_addr    (rd_addr_glb_ifm),
    .data_in    (rd_data_glb_ifm),

    .wr_en      (wr_en_ifm),
    .wr_addr    (wr_addr_ifm),
    .data_out   (data_out_ifm)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_0(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_0),

    .wr_en      (wr_en_wgt),
    .wr_addr    (wr_addr_wgt),
    .data_out   (data_out_wgt_0)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_1(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_1),

    .data_out   (data_out_wgt_1)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_2(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_2),

    .data_out   (data_out_wgt_2)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_3(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_3),

    .data_out   (data_out_wgt_3)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_4(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_4),

    .wr_en      (wr_en_wgt),
    .wr_addr    (wr_addr_wgt),
    .data_out   (data_out_wgt_4)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_5(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_5),

    .data_out   (data_out_wgt_5)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_6(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_6),

    .data_out   (data_out_wgt_6)
);


glb_2_lb #(.RD_ADDR_WID(8), .WR_ADDR_WID(5))
glb_2_lb_inst_wgt_7(
    .clock(clock),
    .rst_n(rst_n),

    .trans_start(wgt_trans_start),
    .trans_end  (wgt_trans_end),

    .base_addr  (wgt_base_addr),
    .big_length (wgt_big_length),
    .length     (wgt_length),
    .height     (wgt_height),

    .rd_en      (rd_en_glb_wgt),
    .rd_addr    (rd_addr_glb_wgt),
    .data_in    (rd_data_glb_wgt_7),

    .data_out   (data_out_wgt_7)
);

endmodule