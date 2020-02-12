//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2020/01/20 19:47:32
// Design Name: sDavinci
// Module Name: test_module
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module dla_ctrl
#(parameter SIZE = 8)
    (
    //**** dla - soc begin ****//
    input  clock,
    input  rst_n,

    // dla register write and read
    input      [31:0]  reg_addr_wr,
    input      [31:0]  reg_data_wr,
    input              reg_en_wr,

    input      [31:0]  reg_addr_rd,
    output     [31:0]  reg_data_rd,
    input              reg_en_rd,
    //**** dla - soc end ****//
    

    //**** glb_2_lb begin ****//

    // glb_2_lb_ifm
    output reg        ifm_trans_start,
    input             ifm_trans_end,

    output reg [15:0] ifm_base_addr,
    output reg [7:0]  ifm_big_length,
    output reg [5:0]  ifm_length,
    output reg [5:0]  ifm_height,

    // glb_2_lb_wgt
    output reg        wgt_trans_start,
    input             wgt_trans_end,

    output reg [7:0]  wgt_base_addr,
    output reg [7:0]  wgt_big_length,
    output reg [5:0]  wgt_length,
    output reg [5:0]  wgt_height,

    //**** glb_2_lb end ****//


    //**** dla module interface begin ****//
    // global
    output reg [5:0]  tile_length,
    output reg [5:0]  tile_height,    
    output     [2:0]  stride,
    output     [2:0]  ksize,
    output     [3:0]  valid_num,

    output reg        i2c_go,
    input             i2c_pulse,

    // Ifm_addr_gen
    output reg        tile_start,
    input             addr_gen_done,
    input             ifmap_end,

    // ifm_chn_sel
    output reg        loop_end,
    output reg        buf_in_switch,

    // bridge_i2c_buf
    output reg        buf_i2c_switch,

    // Arbitrator
    input             i2c_ready_ifm,
    input             buf_empty_ifm,

    // img2col_weight_size
    input             i2c_ready_wgt,
    output reg        i2c_wgt_start, 

    // wgt_buffer_size
    input             buf_empty_wgt,

    // matrix fetcher
    output reg        matrix_go,
    input             one_buf_end,

    // cubic_acc_buf_size
    output     [1:0]   pool_size,
    output reg         new_tile,
    output     [4:0]   qtf_mod_sel,
    output             pool_mode,
    output reg         qtf_start,
    output reg         pool_start,
    output reg [127:0] bias,   // TODO: should be configure in loop d

    // pool_mem
    output     [2:0]   pad_size,
    output reg [3:0]   pad_mod_sel,
    output reg         tile_dump,
    input              dump_end,
    output reg [5:0]   tile_height_to_qtf,
    output reg [5:0]   tile_length_to_qtf,
    input              pad_end,

    // lb_2_glb
    output reg [15:0]  of_base_addr,
    output reg [15:0]  of_page_length
    //**** dla module interface end ****//
);

localparam TRUE  = 1,
           FALSE = 0;

genvar gv_i;

//**** dla conf register declaration begin ****//
localparam 
          KERNEL_SIZE      = 32'h0000_0001,    // conf registers
          STRIDE           = 32'h0000_0002,
          PAD_SIZE         = 32'h0000_0003,
          POOL_SIZE        = 32'h0000_0004,
          VALID_NUM        = 32'h0000_0005,
          IF_LAYER_NUM     = 32'h0000_0006,
          IFMAP_LENGTH     = 32'h0000_0007,
          IFMAP_SIZE       = 32'h0000_0008,
          OFMAP_SIZE       = 32'h0000_0009,
          QTF_MODE         = 32'h0000_000a,
          POOL_MODE        = 32'h0000_000b,
          WGT_INIT_ADDR    = 32'h0000_000c,
          OF_LAYER_NUM     = 32'h0000_000e,
          IF_TILE_LENGTH_0 = 32'h0000_000f,
          IF_TILE_LENGTH_1 = 32'h0000_0010,
          IF_TILE_LENGTH_2 = 32'h0000_0011,
          IF_TILE_LENGTH_3 = 32'h0000_0012,
          IF_TILE_HEIGHT_0 = 32'h0000_0013,
          IF_TILE_HEIGHT_1 = 32'h0000_0014,
          IF_TILE_HEIGHT_2 = 32'h0000_0015,
          IF_TILE_HEIGHT_3 = 32'h0000_0016,
          IF_TILE_NUMBER_0 = 32'h0000_0017,
          IF_TILE_NUMBER_1 = 32'h0000_0018,
          IF_TILE_NUMBER_2 = 32'h0000_0019,
          IF_TILE_NUMBER_3 = 32'h0000_001a,
          OFMAP_LENGTH     = 32'h0000_001e,

          REG_INIT         = 32'h0000_001b,    // control registers
          SHEET_GEN_START  = 32'h0000_001c,
          CONV_START       = 32'h0000_001d,

          SHEET_GEN_FINISH = 32'h0000_001d,    // status registers
          CONV_END         = 32'H0000_001e;

reg [31:0] reg_kernel_size  ;   // conf registers
reg [31:0] reg_stride       ;
reg [31:0] reg_pad_size     ;
reg [31:0] reg_pool_size    ;
reg [31:0] reg_valid_num    ;
reg [31:0] reg_if_layer_num ;
reg [31:0] reg_ifmap_length ;
reg [31:0] reg_ifmap_size   ;
reg [31:0] reg_ofmap_size   ;
reg [31:0] reg_qtf_mode     ;
reg [31:0] reg_pool_mode    ;
reg [31:0] reg_of_layer_num ;
reg [31:0] reg_wgt_init_addr;
reg [31:0] reg_if_tile_length_0;
reg [31:0] reg_if_tile_length_1;
reg [31:0] reg_if_tile_length_2;
reg [31:0] reg_if_tile_length_3;
reg [31:0] reg_if_tile_height_0;
reg [31:0] reg_if_tile_height_1;
reg [31:0] reg_if_tile_height_2;
reg [31:0] reg_if_tile_height_3;
reg [31:0] reg_if_tile_number_0;
reg [31:0] reg_if_tile_number_1;
reg [31:0] reg_if_tile_number_2;
reg [31:0] reg_if_tile_number_3;
reg [31:0] reg_ofmap_length;

reg [31:0] reg_reg_init;
reg [31:0] reg_sheet_gen_start;
reg [31:0] reg_conv_start;

reg [31:0] reg_sheet_gen_finish;
reg [31:0] reg_conv_end;

reg [31:0] reg_data_out;
assign reg_data_rd = reg_data_out;

assign stride      = reg_stride[2:0];
assign pad_size    = reg_pad_size[2:0];
assign valid_num   = reg_valid_num[3:0];
assign ksize       = reg_kernel_size[2:0];
assign pool_size   = reg_pool_size[1:0];
assign qtf_mod_sel = reg_qtf_mode[4:0];
assign pool_mode   = reg_pool_mode[0];
//**** dla conf register declaration end ****//


//**** dla bias register declaration begin ****//
localparam BIAS = 32'h0001_0000;

reg  [15:0] bias_mem [255:0];
wire [7:0]  bias_index;
assign bias_index = reg_addr_wr[7:0];

generate
    for(gv_i=0;gv_i<256;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n) begin
            if(!rst_n) bias_mem[gv_i] <= 'b0;
        end
    end
endgenerate
//**** dla bias register declaration end ****//


//**** ifmap base address sheet generation declaration begin ****//
localparam SHEET_IDLE     = 'b00001,
           SHEET_GEN_0    = 'b00010,
           SHEET_GEN_1    = 'b00100,
           SHEET_GEN_DONE = 'b01000,
           SHEET_GEN_WAIT = 'b10000;

reg        if_base_addr_gen_en;
reg        if_base_addr_gen_done;
reg [15:0] fetch_addr_reg;
reg [15:0] fetch_addr        [63:0];
reg [1:0]  if_tile_order     [63:0];
reg [9:0]  cnt_size_0;
reg [9:0]  cnt_size_1;
reg [9:0]  cnt_size_2;
reg [9:0]  ifm_cnt;
reg [4:0]  if_sheet_gen_state;

generate
    for(gv_i=0;gv_i<64;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n) begin
            if(!rst_n) fetch_addr[gv_i] <= 'b0;
        end
    end
endgenerate

generate
    for(gv_i=0;gv_i<64;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n) begin
            if(!rst_n) if_tile_order[gv_i] <= 'b0;
        end
    end
endgenerate
//**** ifmap base address sheet generation declaration end ****//


//**** ofmap padding mode sheet generation declaration begin ****//
localparam MODE_IDLE  = 'b00001,
           FIRST_LINE = 'b00010,
           MID_LINE   = 'b00100,
           LAST_LINE  = 'b01000,
           MODE_WAIT  = 'b10000;

reg       mode_gen_en;
reg       mode_gen_done;
reg [9:0] pad_cnt_v;
reg [9:0] pad_cnt_h;
reg [4:0] mode_state;
reg [3:0] pad_mod_sheet [63:0];

generate
    for(gv_i=0;gv_i<32;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n) begin
            if(!rst_n) pad_mod_sheet[gv_i] <= 'b0;
        end
    end
endgenerate
//**** ofmap padding mode sheet generation declaration end ****//


//**** ofmap base address sheet generation declaration begin ****//
localparam DUMP_IDLE      = 'b00001,
           DUMP_1ST_LINE  = 'b00010,
           DUMP_MID_LINE  = 'b00100,
           DUMP_LAST_LINE = 'b01000,
           DUMP_WAIT      = 'b10000; 

reg [15:0] dump_addr    [63:0];
reg [15:0] dump_address       ;

reg [4:0] of_tile_length_0;
reg [4:0] of_tile_length_1;
reg [4:0] of_tile_length_2;
reg [4:0] of_tile_length_3;

reg [4:0] of_tile_height_0;
reg [4:0] of_tile_height_1;
reg [4:0] of_tile_height_2;
reg [4:0] of_tile_height_3;

reg [4:0] of_tile_number_0;
reg [4:0] of_tile_number_1;
reg [4:0] of_tile_number_2;
reg [4:0] of_tile_number_3;

reg [9:0] pad_page_length;

reg       dump_addr_gen_en;
reg       dump_addr_gen_done;
reg [9:0] dump_cnt_v;
reg [9:0] dump_cnt_h;
reg [4:0] dump_state;

generate
    for(gv_i=0;gv_i<32;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n)
            if(!rst_n) dump_addr[gv_i] <= 'b0;
    end
endgenerate
//**** ofmap base address sheet generation declaration end ****//


//**** loop D registers declaration begin ****//
localparam LOOPD_IDLE     = 'b0001,
           LOOPC_CONF     = 'b0010,
           WAIT_LOOPC_END = 'b0100,
           LOOPD_END      = 'b1000;

reg        loopd_end;
reg        loopc_end;
reg [5:0]  loopc_cnt;
reg [4:0]  loopd_state;
reg [8:0]  of_layer_number;
reg [15:0] wgt_trans_init_addr_loopc;
//**** loop D registers declaration begin ****//


//**** loop C registers declaration begin ****//
localparam LOOPC_IDLE     = 'b000_0001,
           LOOPC_START    = 'b000_0100,
           LOOPB_CONF     = 'b000_1000,
           LOOPB_START    = 'b001_0000,
           WAIT_LOOPB_END = 'b010_0000,
           LOOPC_END      = 'b100_0000;

reg [6:0] loopc_state;
reg       loopc_go;
reg       loopb_go;
reg       loopb_end;

reg [8:0]  if_layer_number;
reg [15:0] fetch_base_addr;
reg [9:0]  loopa_total_conv_time;
reg [9:0]  total_loopb_times;
reg [9:0]  current_loopb_order;
//**** loop C registers declaration end ****//


//**** loop B registers declaration begin ****//
localparam LOOPB_IDLE        = 'b00_0000_0001,  // 001
           TRANS_START       = 'b00_0000_0010,  // 002
           FILL_1ST_BUF      = 'b00_0000_0100,  // 004
           FILL_2ND_BUF      = 'b00_0000_1000,  // 008
           LOOPA_START       = 'b00_0001_0000,  // 010
           WAIT_LOOPA_END    = 'b00_0010_0000,  // 020
           IF_TRANS_END      = 'b00_0100_0000,  // 040
           START_TRANS       = 'b00_1000_0000,  // 080
           WAIT_WGT_TRANS    = 'b01_0000_0000,  // 100
           QTF               = 'b10_0000_0000;  // 200

reg [9:0]  loopb_state;
reg        loopa_start;
reg [5:0]  loopa_cnt;
reg [1:0]  tmp_cnt;
reg        loopa_end;
reg        qtf_hello;
reg        qtf_shitting;
//**** loop B registers declaration end ****//


//**** loop b qtf and pooling control declaration begin ****//
localparam QTF_IDLE           = 'b0_0001,
           POOL_START         = 'b0_0010,
           WAIT_POOL_END      = 'b0_0100,
           OF_TILE_DUMP_START = 'b0_1000,
           OF_TILE_DUMP_WAIT  = 'b1_0000;

reg [4:0] qtf_state;
reg [1:0] qtf_cnt;
reg       qtf_end;
//**** loop b qtf and pooling control declaration end ****//


//**** loop A registers declaration begin ****//
localparam IDLE              = 'b00001, // 01
           START_ADDR        = 'b00010, // 02
           START_I2C         = 'b00100, // 04
           START_FETCHER     = 'b01000, // 08
           WAIT_LOOP_END     = 'b10000;

localparam WGT_IDLE          = 'b001,   // img2col_wgt control
           WGT_START         = 'b010,
           WGT_WAIT          = 'b100;

reg [9:0] i2c_cnt;
reg [2:0] wgt_state;
reg [4:0] loopa_state;
reg [9:0] conv_times_cnt;
//**** loop A registers declaration end ****//


//**** other registers begin ****//
reg       flag_sheet_gen;
reg [2:0] sheet_gen_state;
//**** other registers end ****//


always@(posedge clock or negedge rst_n) begin   // dla conf register write in block
    if(!rst_n) begin
        reg_kernel_size      <= 'b0;
        reg_stride           <= 'b0;
        reg_pad_size         <= 'b0;
        reg_pool_size        <= 'b0;
        reg_valid_num        <= 'b0;
        reg_if_layer_num     <= 'b0;
        reg_ifmap_length     <= 'b0;
        reg_ifmap_size       <= 'b0;
        reg_ofmap_size       <= 'b0;
        reg_qtf_mode         <= 'b0;
        reg_pool_mode        <= 'b0;
        reg_of_layer_num     <= 'b0;
        reg_wgt_init_addr    <= 'b0;
        reg_if_tile_length_0 <= 'b0;
        reg_if_tile_length_1 <= 'b0;
        reg_if_tile_length_2 <= 'b0;
        reg_if_tile_length_3 <= 'b0;
        reg_if_tile_height_0 <= 'b0;
        reg_if_tile_height_1 <= 'b0;
        reg_if_tile_height_2 <= 'b0;
        reg_if_tile_height_3 <= 'b0;
        reg_if_tile_number_0 <= 'b0;
        reg_if_tile_number_1 <= 'b0;
        reg_if_tile_number_2 <= 'b0;
        reg_if_tile_number_3 <= 'b0;
        reg_ofmap_length     <= 'b0;
        reg_reg_init         <= 'b0;
        reg_sheet_gen_start  <= 'b0;
        reg_conv_start       <= 'b0;
    end
    else if(reg_en_wr) begin
        if(reg_addr_wr >= 32'h0001_0000) begin
            bias_mem[bias_index] <= reg_data_wr[15:0];
        end
        else begin
            case(reg_addr_wr)
                KERNEL_SIZE:      reg_kernel_size      <= reg_data_wr;
                STRIDE:           reg_stride           <= reg_data_wr;
                PAD_SIZE:         reg_pad_size         <= reg_data_wr;
                POOL_SIZE:        reg_pool_size        <= reg_data_wr;
                VALID_NUM:        reg_valid_num        <= reg_data_wr;
                IF_LAYER_NUM:     reg_if_layer_num     <= reg_data_wr;
                IFMAP_LENGTH:     reg_ifmap_length     <= reg_data_wr;
                IFMAP_SIZE:       reg_ifmap_size       <= reg_data_wr;
                OFMAP_SIZE:       reg_ofmap_size       <= reg_data_wr;
                QTF_MODE:         reg_qtf_mode         <= reg_data_wr;
                POOL_MODE:        reg_pool_mode        <= reg_data_wr;
                OF_LAYER_NUM:     reg_of_layer_num     <= reg_data_wr;
                WGT_INIT_ADDR:    reg_wgt_init_addr    <= reg_data_wr;
                IF_TILE_LENGTH_0: reg_if_tile_length_0 <= reg_data_wr;
                IF_TILE_LENGTH_1: reg_if_tile_length_1 <= reg_data_wr;
                IF_TILE_LENGTH_2: reg_if_tile_length_2 <= reg_data_wr;
                IF_TILE_LENGTH_3: reg_if_tile_length_3 <= reg_data_wr;
                IF_TILE_HEIGHT_0: reg_if_tile_height_0 <= reg_data_wr;
                IF_TILE_HEIGHT_1: reg_if_tile_height_1 <= reg_data_wr;
                IF_TILE_HEIGHT_2: reg_if_tile_height_2 <= reg_data_wr;
                IF_TILE_HEIGHT_3: reg_if_tile_height_3 <= reg_data_wr;
                IF_TILE_NUMBER_0: reg_if_tile_number_0 <= reg_data_wr;
                IF_TILE_NUMBER_1: reg_if_tile_number_1 <= reg_data_wr;
                IF_TILE_NUMBER_2: reg_if_tile_number_2 <= reg_data_wr;
                IF_TILE_NUMBER_3: reg_if_tile_number_3 <= reg_data_wr;
                OFMAP_LENGTH:     reg_ofmap_length     <= reg_data_wr;
                REG_INIT:         reg_reg_init         <= reg_data_wr;
                SHEET_GEN_START:  reg_sheet_gen_start  <= reg_data_wr;
                CONV_START:       reg_conv_start       <= reg_data_wr;
                default:;
            endcase
        end
    end
end

always@(posedge clock or negedge rst_n) begin   // dla conf register read out block
    if(!rst_n) begin
        reg_data_out <= 'b0;
    end
    else if(reg_en_rd) begin
        case(reg_addr_rd)
            KERNEL_SIZE:      reg_data_out <= reg_kernel_size;
            STRIDE:           reg_data_out <= reg_stride;
            PAD_SIZE:         reg_data_out <= reg_pad_size;
            POOL_SIZE:        reg_data_out <= reg_pool_size;
            VALID_NUM:        reg_data_out <= reg_valid_num;
            IF_LAYER_NUM:     reg_data_out <= reg_if_layer_num;
            IFMAP_LENGTH:     reg_data_out <= reg_ifmap_length;
            IFMAP_SIZE:       reg_data_out <= reg_ifmap_size;
            OFMAP_SIZE:       reg_data_out <= reg_ofmap_size;
            QTF_MODE:         reg_data_out <= reg_qtf_mode;
            POOL_MODE:        reg_data_out <= reg_pool_mode;
            OF_LAYER_NUM:     reg_data_out <= reg_of_layer_num;
            IF_TILE_LENGTH_0: reg_data_out <= reg_if_tile_length_0;
            IF_TILE_LENGTH_1: reg_data_out <= reg_if_tile_length_1;
            IF_TILE_LENGTH_2: reg_data_out <= reg_if_tile_length_2;
            IF_TILE_LENGTH_3: reg_data_out <= reg_if_tile_length_3;
            IF_TILE_HEIGHT_0: reg_data_out <= reg_if_tile_height_0;
            IF_TILE_HEIGHT_1: reg_data_out <= reg_if_tile_height_1;
            IF_TILE_HEIGHT_2: reg_data_out <= reg_if_tile_height_2;
            IF_TILE_HEIGHT_3: reg_data_out <= reg_if_tile_height_3;
            IF_TILE_NUMBER_0: reg_data_out <= reg_if_tile_number_0;
            IF_TILE_NUMBER_1: reg_data_out <= reg_if_tile_number_1;
            IF_TILE_NUMBER_2: reg_data_out <= reg_if_tile_number_2;
            IF_TILE_NUMBER_3: reg_data_out <= reg_if_tile_number_3;
            OFMAP_LENGTH:     reg_data_out <= reg_ofmap_length;
            REG_INIT:         reg_data_out <= reg_reg_init;
            SHEET_GEN_START:  reg_data_out <= reg_sheet_gen_start;
            SHEET_GEN_FINISH: reg_data_out <= reg_sheet_gen_finish;
            CONV_END:         reg_data_out <= reg_conv_end;
            default:          reg_data_out <= 'b0;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin   // dla status register block
    if(!rst_n) begin
        reg_sheet_gen_finish <= 'b0;
        reg_conv_end         <= 'b0;
    end
    else begin
        if(reg_reg_init == 'b0) begin
            if(flag_sheet_gen == TRUE)
                reg_sheet_gen_finish <= 'b1;
            if(loopd_end == TRUE)
                reg_conv_end <= 'b1;
        end
        else begin
            reg_sheet_gen_finish <= 'b0;
            reg_conv_end         <= 'b0;
        end
    end
end


//------------ifmap base address sheet generation block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        cnt_size_0    <= 'b0;
        cnt_size_1    <= 'b0;
        cnt_size_2    <= 'b0;
        ifm_cnt       <= 'b0;
        if_base_addr_gen_done <= FALSE;
        if_sheet_gen_state <= SHEET_IDLE;
    end
    else begin
        case(if_sheet_gen_state)
            SHEET_IDLE: begin
                if(if_base_addr_gen_en == TRUE) begin
                    fetch_addr_reg     <= 'b0;
                    if_sheet_gen_state <= SHEET_GEN_0;
                end
                else if_base_addr_gen_done <= FALSE;
            end
            SHEET_GEN_0: begin
                ifm_cnt <= ifm_cnt + 1;
                fetch_addr[cnt_size_1*(reg_if_tile_number_0+1) + cnt_size_0] <= fetch_addr_reg;
                if(cnt_size_0 < reg_if_tile_number_0) begin
                    cnt_size_0             <= cnt_size_0 + 1;
                    if_tile_order[ifm_cnt] <= 0; 
                    fetch_addr_reg         <= fetch_addr_reg + reg_if_tile_length_0 - ksize + 1;
                end
                else begin
                    cnt_size_0             <= 'b0;
                    if_tile_order[ifm_cnt] <= 1;
                    if(cnt_size_1 < reg_if_tile_number_1 - 1) begin
                        cnt_size_1  <= cnt_size_1 + 1;
                        fetch_addr_reg <= (cnt_size_1 + 1) * ((reg_if_tile_height_0-ksize+1)*reg_ifmap_length); 
                    end
                    else begin
                        if_sheet_gen_state <= SHEET_GEN_1;
                        fetch_addr_reg <= reg_if_tile_number_1 * ((reg_if_tile_height_0-ksize+1)*reg_ifmap_length); 
                    end
                end
            end
            SHEET_GEN_1: begin
                ifm_cnt <= ifm_cnt + 1;
                fetch_addr[reg_if_tile_number_0*reg_if_tile_number_1+reg_if_tile_number_1 + cnt_size_2] <= fetch_addr_reg;
                if(cnt_size_2 < reg_if_tile_number_2) begin
                    cnt_size_2             <= cnt_size_2 + 1;
                    if_tile_order[ifm_cnt] <= 2;
                    fetch_addr_reg         <= fetch_addr_reg + reg_if_tile_length_2 - ksize + 1;
                end
                else begin
                    if_tile_order[ifm_cnt] <= 3;
                    if_sheet_gen_state <= SHEET_GEN_DONE;
                    if_base_addr_gen_en <= FALSE;
                end
            end
            SHEET_GEN_DONE: begin
                cnt_size_0      <= 'b0;
                cnt_size_1      <= 'b0;
                cnt_size_2      <= 'b0;
                ifm_cnt         <= 'b0;
                if_base_addr_gen_done   <= TRUE;
                if_sheet_gen_state <= SHEET_GEN_WAIT;
            end
            SHEET_GEN_WAIT: begin
                if(reg_sheet_gen_finish != 'b0) if_sheet_gen_state <= SHEET_IDLE;
            end
            default:if_sheet_gen_state <= SHEET_IDLE;
        endcase
    end
end
//------------ifmap base address sheet generation block------------//


//------------ofmap padding mode sheet generation block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        pad_cnt_h     <= 'b0;
        pad_cnt_v     <= 'b0; 
        mode_state    <= MODE_IDLE;
        mode_gen_done <= FALSE;
    end
    else begin
        case(mode_state)
            MODE_IDLE: begin
                if(mode_gen_en) begin
                    mode_state <= FIRST_LINE;
                end
                else mode_gen_done <= FALSE;
            end
            FIRST_LINE: begin
                if(pad_cnt_h == 0) begin
                    pad_cnt_h <= pad_cnt_h + 1;
                    pad_mod_sheet[pad_cnt_h] <= 1;
                end
                else if(pad_cnt_h < reg_if_tile_number_0) begin
                    pad_cnt_h <= pad_cnt_h + 1;
                    pad_mod_sheet[pad_cnt_h] <= 2;
                end
                else if(pad_cnt_h == reg_if_tile_number_0) begin
                    pad_cnt_h  <= 'b0;
                    pad_cnt_v  <= pad_cnt_v + 1;
                    pad_mod_sheet[pad_cnt_h] <= 3;
                    mode_state <= MID_LINE;
                end
            end
            MID_LINE: begin
                if(pad_cnt_h == 0) begin
                    pad_cnt_h <= pad_cnt_h + 1;
                    pad_mod_sheet[pad_cnt_v*(reg_if_tile_number_0+1)] <= 4;
                end
                else if(pad_cnt_h < reg_if_tile_number_0) begin
                    pad_cnt_h <= pad_cnt_h + 1;
                    pad_mod_sheet[pad_cnt_v*(reg_if_tile_number_0+1)+pad_cnt_h] <= 5;
                end
                else if(pad_cnt_h == reg_if_tile_number_0) begin
                    pad_cnt_h <= 'b0;
                    pad_cnt_v <= pad_cnt_v + 1;
                    pad_mod_sheet[pad_cnt_v*(reg_if_tile_number_0+1)+pad_cnt_h] <= 6;
                    if(pad_cnt_v == reg_if_tile_number_1 - 1) begin
                        mode_state <= LAST_LINE;
                    end
                end
            end
            LAST_LINE: begin
                if(pad_cnt_h == 0) begin
                    pad_cnt_h <= pad_cnt_h + 1;
                    pad_mod_sheet[pad_cnt_v*(reg_if_tile_number_0+1)] <= 7;
                end
                else if(pad_cnt_h < reg_if_tile_number_2) begin
                    pad_cnt_h <= pad_cnt_h + 1;
                    pad_mod_sheet[pad_cnt_v*(reg_if_tile_number_0+1)+pad_cnt_h] <= 8;
                end
                else if(pad_cnt_h == reg_if_tile_number_2) begin
                    pad_cnt_h <= 'b0;
                    pad_cnt_v <= 'b0;
                    pad_mod_sheet[pad_cnt_v*(reg_if_tile_number_0+1)+pad_cnt_h] <= 9;
                    mode_state <= MODE_WAIT;
                    mode_gen_done <= TRUE;
                end
            end
            MODE_WAIT: begin
                if(reg_sheet_gen_finish != 'b0) mode_state <= MODE_IDLE;
            end
            default:;
        endcase
    end
end
//------------ofmap padding mode sheet generation block------------//


//------------ofmap base address sheet generation block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        dump_cnt_h   <= 'b0;
        dump_cnt_v   <= 'b0;
        dump_address <= 'b0;
        dump_addr_gen_done  <= FALSE;
        dump_state   <= DUMP_IDLE;
    end
    else begin
        case(dump_state)
            DUMP_IDLE: begin
                if(dump_addr_gen_en == TRUE) begin
                    dump_cnt_h   <= 'b0;
                    dump_cnt_v   <= 'b0;
                    dump_address <= 'b0;
                    dump_state   <= DUMP_1ST_LINE;

                    of_tile_length_0 <= ((reg_if_tile_length_0-ksize)/stride+1)/2;
                    of_tile_length_1 <= ((reg_if_tile_length_1-ksize)/stride+1)/2;
                    of_tile_length_2 <= ((reg_if_tile_length_2-ksize)/stride+1)/2;
                    of_tile_length_3 <= ((reg_if_tile_length_3-ksize)/stride+1)/2;

                    of_tile_height_0 <= ((reg_if_tile_height_0-ksize)/stride+1)/2;
                    of_tile_height_1 <= ((reg_if_tile_height_1-ksize)/stride+1)/2;
                    of_tile_height_2 <= ((reg_if_tile_height_2-ksize)/stride+1)/2;
                    of_tile_height_3 <= ((reg_if_tile_height_3-ksize)/stride+1)/2;
                
                    of_tile_number_0 <= reg_if_tile_number_0;
                    of_tile_number_1 <= reg_if_tile_number_1;
                    of_tile_number_2 <= reg_if_tile_number_2;
                    of_tile_number_3 <= reg_if_tile_number_3;
                
                    pad_page_length <= (((reg_ifmap_length-ksize)/stride+1)/reg_pool_size)+2*pad_size;
                end
                else dump_addr_gen_done <= FALSE;
            end
            DUMP_1ST_LINE: begin
                dump_addr[dump_cnt_h] <= dump_address;
                if(dump_cnt_h == 0) begin
                    dump_cnt_h   <= dump_cnt_h + 1;
                    dump_address <= dump_address + of_tile_length_0 + pad_size;
                end
                else if(dump_cnt_h != of_tile_number_0) begin
                    dump_cnt_h   <= dump_cnt_h + 1;
                    dump_address <= dump_address + of_tile_length_0;
                end
                else begin
                    dump_cnt_h   <= 'b0;
                    dump_cnt_v   <= dump_cnt_v + 1;
                    dump_address <= (dump_cnt_v+1)*(of_tile_height_0+pad_size)*pad_page_length;
                    dump_state   <= DUMP_MID_LINE;
                end
            end
            DUMP_MID_LINE: begin
                dump_addr[dump_cnt_v*(of_tile_number_0+1)+dump_cnt_h] <= dump_address;
                if(dump_cnt_h == 0) begin
                    dump_cnt_h   <= dump_cnt_h + 1;
                    dump_address <= dump_address + of_tile_length_0 + pad_size;
                end
                else if(dump_cnt_h != of_tile_number_0) begin
                    dump_cnt_h   <= dump_cnt_h + 1;
                    dump_address <= dump_address + of_tile_length_0;
                end
                else begin
                    dump_cnt_h   <= 'b0;
                    dump_cnt_v   <= dump_cnt_v + 1;
                    dump_address <= dump_cnt_v*of_tile_height_0*pad_page_length + (of_tile_height_0+pad_size)*pad_page_length;
                    if(dump_cnt_v == of_tile_number_1 - 1) dump_state <= DUMP_LAST_LINE;
                end
            end
            DUMP_LAST_LINE: begin
                dump_addr[dump_cnt_v*(of_tile_number_0+1)+dump_cnt_h] <= dump_address;
                if(dump_cnt_h == 0) begin
                    dump_cnt_h   <= dump_cnt_h + 1;
                    dump_address <= dump_address + of_tile_length_2 + pad_size; 
                end
                else if(dump_cnt_h != of_tile_number_2) begin
                    dump_cnt_h   <= dump_cnt_h + 1;
                    dump_address <= dump_address + of_tile_length_2;
                end
                else begin
                    dump_addr_gen_done <= TRUE;
                    dump_state  <= DUMP_WAIT;
                end
            end
            DUMP_WAIT: begin
                if(reg_sheet_gen_finish != 'b0) dump_state <= DUMP_IDLE;
            end
            default: dump_state <= DUMP_IDLE;
        endcase
    end
end
//------------ofmap base address sheet generation block------------//


//------------sheet generation flag block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        if_base_addr_gen_en <= FALSE;
        dump_addr_gen_en    <= FALSE;
        mode_gen_en         <= FALSE;
        flag_sheet_gen      <= FALSE;
        sheet_gen_state     <= 'b0;
    end
    else begin
        case(sheet_gen_state)
            'd0: begin
                if(reg_sheet_gen_start != 'b0) begin
                    if_base_addr_gen_en <= TRUE;
                    dump_addr_gen_en    <= TRUE;
                    mode_gen_en         <= TRUE;
                    sheet_gen_state     <= 'd1;
                end
            end
            'd1: begin
                if_base_addr_gen_en <= FALSE;
                dump_addr_gen_en    <= FALSE;
                mode_gen_en         <= FALSE;
                if(if_base_addr_gen_done && dump_addr_gen_done && mode_gen_done) begin
                    flag_sheet_gen  <= TRUE;
                    sheet_gen_state <= 'd2;
                end
            end
            'd2: begin
                if(reg_sheet_gen_finish != 'b0) begin
                    flag_sheet_gen  <= FALSE;
                    sheet_gen_state <= 'd0;
                end
            end
            default: begin
                flag_sheet_gen  <= FALSE;
                sheet_gen_state <= 'd0;
            end
        endcase
    end
end
//------------sheet generation flag block------------//


//------------loop D control block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        of_layer_number           <= 'b0;
        loopc_cnt                 <= 'b0;
        loopd_end                 <= FALSE;
        loopd_state               <= LOOPD_IDLE;
        wgt_trans_init_addr_loopc <= 'b0;
    end
    else begin
        case(loopd_state)
            LOOPD_IDLE: begin
                if(reg_conv_start != 'b0) begin
                    loopc_cnt       <= 'b0;
                    loopd_state     <= LOOPC_CONF;
                    of_layer_number <= reg_of_layer_num[8:0];
                end
                else begin
                    loopd_end <= FALSE;
                end
            end
            LOOPC_CONF: begin
                wgt_trans_init_addr_loopc <= reg_wgt_init_addr + loopc_cnt*ksize*ksize*reg_if_layer_num[31:3];
                loopc_go <= TRUE;
                loopd_state <= WAIT_LOOPC_END;
            end
            WAIT_LOOPC_END: begin
                loopc_go <= FALSE;
                if(loopc_end == TRUE) begin
                    if(loopc_cnt != of_layer_number[8:3] - 1) begin
                        loopc_cnt   <= loopc_cnt + 1;
                        loopd_state <= LOOPC_CONF;
                    end
                    else loopd_state <= LOOPD_END;
                end
            end
            LOOPD_END: begin
                of_layer_number           <= 'b0;
                loopc_cnt                 <= 'b0;
                wgt_trans_init_addr_loopc <= 'b0;
                loopd_end                 <= TRUE;
                loopd_state               <= LOOPD_IDLE;
            end
            default:loopd_state <= LOOPD_IDLE;
        endcase
    end
end
//------------loop D control block------------//


//------------loop C control block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        loopc_state    <= LOOPC_IDLE;
        loopb_go       <= FALSE;
        loopc_end      <= FALSE;
    end
    else begin
        case(loopc_state)
            LOOPC_IDLE: begin       // 01
                if(loopc_go) begin
                    loopc_state <= LOOPC_START;
                end
                else begin
                    loopc_end <= FALSE;
                end
            end
            LOOPC_START: begin      // 04
                current_loopb_order <= 'b0;
                total_loopb_times   <= reg_if_tile_number_0*reg_if_tile_number_1 + reg_if_tile_number_1 + reg_if_tile_number_2 + reg_if_tile_number_3;
                loopc_state         <= LOOPB_CONF;
            end
            LOOPB_CONF: begin       // 08 loopb parameters configuration
                current_loopb_order <= current_loopb_order + 1;
                fetch_base_addr     <= fetch_addr[current_loopb_order];
                if_layer_number     <= reg_if_layer_num[8:0];

                if(if_tile_order[current_loopb_order] == 0) begin
                    tile_length <= reg_if_tile_length_0;
                    tile_height <= reg_if_tile_height_0;
                    loopa_total_conv_time <= ((reg_if_tile_length_0-reg_kernel_size)/reg_stride + 1)*((reg_if_tile_height_0-reg_kernel_size)/reg_stride + 1);
                end
                else if(if_tile_order[current_loopb_order] == 1) begin
                    tile_length <= reg_if_tile_length_1;
                    tile_height <= reg_if_tile_height_1;
                    loopa_total_conv_time <= ((reg_if_tile_length_1-reg_kernel_size)/reg_stride + 1)*((reg_if_tile_height_1-reg_kernel_size)/reg_stride + 1);
                end
                else if(if_tile_order[current_loopb_order] == 2) begin
                    tile_length <= reg_if_tile_length_2;
                    tile_height <= reg_if_tile_height_2;
                    loopa_total_conv_time <= ((reg_if_tile_length_2-reg_kernel_size)/reg_stride + 1)*((reg_if_tile_height_2-reg_kernel_size)/reg_stride + 1);
                end
                else if(if_tile_order[current_loopb_order] == 3) begin
                    tile_length <= reg_if_tile_length_3;
                    tile_height <= reg_if_tile_height_3;
                    loopa_total_conv_time <= ((reg_if_tile_length_3-reg_kernel_size)/reg_stride + 1)*((reg_if_tile_height_3-reg_kernel_size)/reg_stride + 1);
                end
                loopc_state <= LOOPB_START;

                bias <= {bias_mem[loopc_cnt*8+7],bias_mem[loopc_cnt*8+6],bias_mem[loopc_cnt*8+5],bias_mem[loopc_cnt*8+4],bias_mem[loopc_cnt*8+3],bias_mem[loopc_cnt*8+2],bias_mem[loopc_cnt*8+1],bias_mem[loopc_cnt*8+0]};
            end
            LOOPB_START: begin      // 10
                loopb_go    <= TRUE;
                loopc_state <= WAIT_LOOPB_END;
            end
            WAIT_LOOPB_END: begin   // 20
                loopb_go <= FALSE;
                if(loopb_end == TRUE) begin
                    if(current_loopb_order == total_loopb_times) loopc_state <= LOOPC_END;
                    else loopc_state <= LOOPB_CONF;
                end
            end
            LOOPC_END: begin        // 40
                loopc_end   <= TRUE;
                loopc_state <= LOOPC_IDLE;
            end
            default: loopc_state <= LOOPC_IDLE;
        endcase
    end
end
//------------loop C control block------------//


//------------loop B control block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        loopb_state    <= LOOPB_IDLE;
        loopa_cnt      <= 'b0;
        loopa_start    <= FALSE;

        loop_end       <= FALSE;
        buf_i2c_switch <= FALSE;
        buf_in_switch  <= FALSE;
        qtf_hello      <= FALSE;
        loopb_end      <= FALSE;
        new_tile       <= TRUE;
    end
    else begin
        case(loopb_state)
            LOOPB_IDLE: begin       // 01
                if(loopb_go == TRUE) begin
                    new_tile        <= TRUE;
                    loopb_state     <= TRANS_START;
                    tmp_cnt         <= 'b0;
                end
                else begin
                    new_tile       <= FALSE;
                    loopa_cnt      <= 'b0;

                    buf_i2c_switch <= FALSE;
                    buf_in_switch  <= FALSE;
                    qtf_hello      <= FALSE;
                    loopb_end      <= FALSE;
                end
            end
            TRANS_START: begin      // 02
                new_tile        <= FALSE;

                wgt_trans_start <= TRUE;
                wgt_base_addr   <= wgt_trans_init_addr_loopc;
                wgt_big_length  <= ksize;
                wgt_length      <= ksize;
                wgt_height      <= ksize;

                ifm_trans_start <= TRUE;
                ifm_base_addr   <= fetch_base_addr;
                ifm_big_length  <= reg_ifmap_length;
                ifm_length      <= tile_length;
                ifm_height      <= tile_height;

                if(loopa_total_conv_time[2:0] != 0) loopa_total_conv_time <= loopa_total_conv_time[9:3] + 1;
                else loopa_total_conv_time <= loopa_total_conv_time[9:3];
                loopa_cnt       <= 'b0;
                loopb_state     <= FILL_1ST_BUF;
            end
            FILL_1ST_BUF: begin    // 04
                wgt_trans_start <= FALSE;
                ifm_trans_start <= FALSE;
                if(tmp_cnt < 2'b10) tmp_cnt <= tmp_cnt + 1; 
                else if(ifm_trans_end == TRUE) begin
                    tmp_cnt     <= 2'b00;
                    if(if_layer_number[8:3] != 1) loopb_state <= FILL_2ND_BUF;
                    else loopb_state <= LOOPA_START;
                end
            end
            // TODO: the first layer fill only one buffer
            FILL_2ND_BUF: begin     // 08
                ifm_trans_start <= TRUE;
                ifm_base_addr   <= ifm_base_addr + reg_ifmap_size;
                buf_in_switch   <= TRUE;
                loopb_state     <= LOOPA_START;
            end
            LOOPA_START: begin      // 10
                ifm_trans_start <= FALSE;
                buf_in_switch   <= FALSE;
                loopa_start     <= TRUE;       // start reading ifmap buffer
                loopb_state     <= WAIT_LOOPA_END;
            end
            WAIT_LOOPA_END: begin   // 20
                loopa_start  <= FALSE;
                if(loopa_end == TRUE) begin
                    if(loopa_cnt == if_layer_number[8:3] - 1) begin
                        loop_end    <= TRUE;
                        loopb_state <= QTF;
                    end
                    else begin
                        buf_i2c_switch <= TRUE;
                        loopa_cnt      <= loopa_cnt + 1;
                        loopb_state    <= IF_TRANS_END;
                    end
                end
            end
            IF_TRANS_END: begin     // 40
                buf_i2c_switch  <= FALSE;    
                if(ifm_trans_end == TRUE) begin
                    loopb_state <= START_TRANS; 
                end
            end 
            START_TRANS: begin      // 80
                wgt_trans_start <= TRUE;
                wgt_base_addr   <= wgt_base_addr + ksize*ksize;
                if(loopa_cnt != if_layer_number[8:3] - 1) begin
                    ifm_trans_start <= TRUE;
                    ifm_base_addr   <= ifm_base_addr + reg_ifmap_size;
                    buf_in_switch   <= TRUE;
                end
                else begin  // prepare to start next loop b
                    //loopb_conf_change <= TRUE;

                end
                loopb_state <= WAIT_WGT_TRANS;
            end
            WAIT_WGT_TRANS: begin   // 100
                ifm_trans_start <= FALSE;
                wgt_trans_start <= FALSE;
                buf_in_switch   <= FALSE;
                if(tmp_cnt < 2'b10) tmp_cnt <= tmp_cnt + 1;
                else if(wgt_trans_end == TRUE) begin
                    tmp_cnt      <= 'b0;
                    loopb_state  <= LOOPA_START;
                end
            end
            QTF: begin              // 200
                qtf_hello    <= TRUE;
                loop_end     <= FALSE;
                if(qtf_shitting == TRUE) begin
                    loopb_end    <= TRUE;
                    loopb_state  <= LOOPB_IDLE;
                end
            end
            default: loopb_state <= LOOPB_IDLE;
        endcase
    end
end
//------------loop B control block------------//


//------------loop B qtf and pooling control block------------//
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        qtf_start     <= FALSE;
        pool_start <= FALSE;
        tile_dump     <= FALSE;
        qtf_end       <= FALSE;
        qtf_state     <= QTF_IDLE;
        qtf_cnt       <= 'b0;
        qtf_shitting  <= FALSE;
    end
    else begin
        case(qtf_state)
            QTF_IDLE: begin
                if(qtf_hello == TRUE) begin
                    qtf_start <= TRUE;
                    qtf_state <= POOL_START;
                    of_page_length      <= reg_ofmap_length;     // should be configure in loopd
                    pad_mod_sel         <= pad_mod_sheet[current_loopb_order - 1];
                    of_base_addr        <= loopc_cnt*reg_ofmap_size + dump_addr[current_loopb_order - 1];
                    tile_height_to_qtf  <= tile_height;
                    tile_length_to_qtf  <= tile_length;
                    qtf_shitting        <= TRUE;
                end
                else qtf_end <= FALSE;
            end
            POOL_START: begin
                qtf_start     <= FALSE;
                pool_start    <= TRUE;
                qtf_shitting  <= FALSE;
                if(qtf_cnt < 2'b10) qtf_cnt <= qtf_cnt + 1;
                else begin
                    qtf_cnt   <= 'b0;
                    qtf_state <= WAIT_POOL_END;
                end
            end
            WAIT_POOL_END: begin
                pool_start <= FALSE;
                if(pad_end == TRUE) begin
                    tile_dump <= TRUE;
                    qtf_state <= OF_TILE_DUMP_START;
                end
            end
            OF_TILE_DUMP_START: begin
                tile_dump <= FALSE;
                if(qtf_cnt < 2'b10) qtf_cnt <= qtf_cnt + 1;
                else begin
                    qtf_cnt   <= 'b0;
                    qtf_state <= OF_TILE_DUMP_WAIT;
                end
            end
            OF_TILE_DUMP_WAIT: begin
                if(dump_end == TRUE) begin
                    qtf_end   <= TRUE; 
                    qtf_state <= QTF_IDLE;
                end
            end
            default: qtf_state <= QTF_IDLE;
        endcase
    end
end
//------------loop B qtf and pooling control block------------//


//------------loop A control block------------//
always@(posedge clock) begin
    if(!rst_n) begin
        loopa_state   <= IDLE;
        tile_start    <= FALSE;
        matrix_go     <= FALSE;
        loopa_end     <= FALSE;
        i2c_go        <= FALSE;
    end
    else begin
        case(loopa_state)
            IDLE: begin           // 01
                loopa_end <= FALSE;
                if(loopa_start == TRUE) begin
                    loopa_state    <= START_ADDR;
                    i2c_go         <= FALSE;
                    i2c_cnt        <= 'b0;
                    conv_times_cnt <= 'b0;
                end
            end
            START_ADDR: begin     // 02
                if(addr_gen_done == FALSE) tile_start <= TRUE;
                else begin
                    tile_start  <= FALSE;
                    loopa_state <= START_I2C;
                end
            end
            START_I2C: begin      // 04
                i2c_go  <= TRUE;
                i2c_cnt <= 3;
                if((buf_empty_ifm==TRUE)&&(i2c_ready_ifm==TRUE));
                else if((buf_empty_ifm==TRUE)&&(i2c_ready_ifm==FALSE));              
                else if(buf_empty_ifm==FALSE) loopa_state <= START_FETCHER;
            end
            START_FETCHER: begin  // 08
                matrix_go   <= TRUE;
                loopa_state <= WAIT_LOOP_END;
            end
            WAIT_LOOP_END: begin // 10
                if((i2c_pulse==TRUE)&&(i2c_go==TRUE)) begin
                    if(i2c_cnt != loopa_total_conv_time - 1) i2c_cnt <= i2c_cnt + 1;
                    else begin
                        i2c_cnt <= 'b0;
                        i2c_go  <= FALSE;
                    end
                end
                if(one_buf_end == TRUE) begin
                    if(conv_times_cnt == loopa_total_conv_time-1) begin
                        conv_times_cnt <= 'b0;
                        matrix_go      <= FALSE;
                        loopa_end      <= TRUE;     // one pulse
                        loopa_state    <= IDLE;
                    end
                    else conv_times_cnt <= conv_times_cnt + 1;
                end
            end
            default: loopa_state <= IDLE;
        endcase
    end
end

always@(posedge clock) begin
    if(!rst_n) begin
        wgt_state     <= WGT_IDLE;
        i2c_wgt_start <= FALSE;
    end
    else begin
        case(wgt_state)
            WGT_IDLE: begin
                if(loopa_start == TRUE) wgt_state <= WGT_START;
            end
            WGT_START: begin
                if(i2c_ready_wgt == TRUE) begin
                    i2c_wgt_start <= TRUE;
                    wgt_state     <= WGT_WAIT;
                end
            end
            WGT_WAIT: begin
                i2c_wgt_start <= FALSE;
                if(buf_empty_wgt == FALSE) wgt_state <= WGT_IDLE;
            end
            default: wgt_state <= WGT_IDLE;
        endcase
    end
end
//------------loop A control block------------//

endmodule