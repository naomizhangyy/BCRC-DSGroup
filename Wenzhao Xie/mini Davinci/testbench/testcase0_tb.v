`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2020/2/1 15:40:01
// Design Name: sDavinci
// Module Name: testcase0_tb
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description:
//
//////////////////////////////////////////////////////////////////////////////////
// blk_mem_gen_0: kernel_buffer.v  depth:25  address width: 5
// blk_mem_gen_1: tile_buffer.v  depth:1024  address width: 10 
// blk_mem_gen_2: global_wgt_buffer  depth:800(25*256/8) address width: 10
// blk_mem_gen_3: global_ifm_buffer  depth:65536(128*128*32/8) address width: 16

// global weight buffer depth:
// depth = ksize^2 * if_layer_number/8 * of_layer_number/8
// depth = 3^2 * 32/8 * 32/8 = 144
// blk_mem_gen_4 ~ blk_mem_gen_11 
//////////////////////////////////////////////

module testcase0_tb();

localparam TRUE  = 1,
           FALSE = 0;

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
          CONV_END         = 32'h0000_001e;

reg clock;
reg rst_n;
reg conv_go;
reg [31:0] ctrl_cnt;

// dla_ctrl
reg  [31:0] reg_addr_wr;
reg  [31:0] reg_data_wr;
reg         reg_en_wr;

reg  [31:0] reg_addr_rd;
wire [31:0] reg_data_rd;
reg         reg_en_rd;

// dla_logic
wire         of_wr_en;
wire [15:0]  of_wr_addr;
wire [127:0] of_wr_data;

// glb_2_lb ifmap
wire         rd_en_glb_ifm;
wire [15:0]  rd_addr_glb_ifm;
wire [127:0] rd_data_glb_ifm;

// glb_2_lb weight
wire         rd_en_glb_wgt;
wire [7:0]   rd_addr_glb_wgt;

wire [127:0] rd_data_glb_wgt_0;
wire [127:0] rd_data_glb_wgt_1;
wire [127:0] rd_data_glb_wgt_2;
wire [127:0] rd_data_glb_wgt_3;
wire [127:0] rd_data_glb_wgt_4;
wire [127:0] rd_data_glb_wgt_5;
wire [127:0] rd_data_glb_wgt_6;
wire [127:0] rd_data_glb_wgt_7;

dla_top dla_top_inst(
    .clock(clock),
    .rst_n(rst_n),

    // dla_ctrl
    .reg_addr_wr(reg_addr_wr),
    .reg_data_wr(reg_data_wr),
    .reg_en_wr  (reg_en_wr),

    .reg_addr_rd(reg_addr_rd),
    .reg_data_rd(reg_data_rd),
    .reg_en_rd  (reg_en_rd),

    // dla_logic
    .of_wr_addr (of_wr_addr),
    .of_wr_data (of_wr_data),
    .of_wr_en   (of_wr_en),

    // glb_2_lb ifmap
    .rd_addr_glb_ifm(rd_addr_glb_ifm),
    .rd_data_glb_ifm(rd_data_glb_ifm),
    .rd_en_glb_ifm  (rd_en_glb_ifm),

    // glb_2_lb weight
    .rd_en_glb_wgt  (rd_en_glb_wgt),
    .rd_addr_glb_wgt(rd_addr_glb_wgt),

    .rd_data_glb_wgt_0(rd_data_glb_wgt_0),
    .rd_data_glb_wgt_1(rd_data_glb_wgt_1),
    .rd_data_glb_wgt_2(rd_data_glb_wgt_2),
    .rd_data_glb_wgt_3(rd_data_glb_wgt_3),
    .rd_data_glb_wgt_4(rd_data_glb_wgt_4),
    .rd_data_glb_wgt_5(rd_data_glb_wgt_5),
    .rd_data_glb_wgt_6(rd_data_glb_wgt_6),
    .rd_data_glb_wgt_7(rd_data_glb_wgt_7)
);

blk_mem_gen_3 glb_if_buf(
    .clkb  (clock),
    .enb   (rd_en_glb_ifm),
    .addrb (rd_addr_glb_ifm),
    .doutb (rd_data_glb_ifm)
);

blk_mem_gen_4 glb_wgt_buf_0(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_0)
);

blk_mem_gen_5 glb_wgt_buf_1(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_1)
);

blk_mem_gen_6 glb_wgt_buf_2(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_2)
);

blk_mem_gen_7 glb_wgt_buf_3(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_3)
);

blk_mem_gen_8 glb_wgt_buf_4(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_4)
);

blk_mem_gen_9 glb_wgt_buf_5(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_5)
);

blk_mem_gen_10 glb_wgt_buf_6(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_6)
);

blk_mem_gen_11 glb_wgt_buf_7(
    .clkb  (clock),
    .enb   (rd_en_glb_wgt),
    .addrb (rd_addr_glb_wgt),
    .doutb (rd_data_glb_wgt_7)
);


initial begin
    #5 clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    conv_go = FALSE;
    #50 rst_n = 0;
    #50 rst_n = 1;
    conv_go = TRUE;
end

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        ctrl_cnt    <= 'b0;
        reg_addr_wr <= 'b0;
        reg_data_wr <= 'b0;
        reg_en_wr   <= FALSE;

        reg_addr_rd <= 'b0;
        reg_en_rd   <= FALSE;
    end
    else begin
        case(ctrl_cnt)
            'd0: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= REG_INIT;
                reg_data_wr <= 'b1;
                reg_en_wr   <= TRUE;
            end
            'd1: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= REG_INIT;
                reg_data_wr <= 'b0;
                reg_en_wr   <= TRUE;
            end
            'd2: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= KERNEL_SIZE;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd3: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= STRIDE;
                reg_data_wr <= 1;
                reg_en_wr   <= TRUE;
            end
            'd4: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= PAD_SIZE;
                reg_data_wr <= 1;
                reg_en_wr   <= TRUE;
            end
            'd5: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= POOL_SIZE;
                reg_data_wr <= 2;
                reg_en_wr   <= TRUE;
            end
            'd6: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= VALID_NUM;
                reg_data_wr <= 8;
                reg_en_wr   <= TRUE;
            end
            'd7: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_LAYER_NUM;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd8: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IFMAP_LENGTH;
                reg_data_wr <= 114;
                reg_en_wr   <= TRUE;
            end
            'd9: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IFMAP_SIZE;
                reg_data_wr <= 114*114;
                reg_en_wr   <= TRUE;
            end
            'd10: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= OFMAP_SIZE;
                reg_data_wr <= 58*58;
                reg_en_wr   <= TRUE;
            end
            'd11: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= QTF_MODE;
                reg_data_wr <= 30;
                reg_en_wr   <= TRUE;
            end
            'd12: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= POOL_MODE;
                reg_data_wr <= 1;           // average mode
                reg_en_wr   <= TRUE;
            end
            'd13: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= WGT_INIT_ADDR;
                reg_data_wr <= 0;
                reg_en_wr   <= TRUE;
            end
            'd14: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= OF_LAYER_NUM;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd15: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_0;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd16: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_1;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd17: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_2;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd18: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_3;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd19: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_0;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd20: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_1;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd21: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_2;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd22: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_3;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd23: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_0;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd24: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_1;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd25: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_2;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd26: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_3;
                reg_data_wr <= 1;
                reg_en_wr   <= TRUE;
            end
            'd27: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= OFMAP_LENGTH;
                reg_data_wr <= 58;
                reg_en_wr   <= TRUE;
            end
            'd28: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0000;
                reg_data_wr <= 32'h0000_ca79;
                reg_en_wr   <= TRUE;
            end
            'd29: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0001;
                reg_data_wr <= 32'h0000_da81;
                reg_en_wr   <= TRUE;
            end
            'd30: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0002;
                reg_data_wr <= 32'h0000_b60f;
                reg_en_wr   <= TRUE;
            end
            'd31: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0003;
                reg_data_wr <= 32'h0000_fab5;
                reg_en_wr   <= TRUE;
            end
            'd32: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0004;
                reg_data_wr <= 32'h0000_3779;
                reg_en_wr   <= TRUE;
            end
            'd33: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0005;
                reg_data_wr <= 32'h0000_2558;
                reg_en_wr   <= TRUE;
            end
            'd34: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0006;
                reg_data_wr <= 32'h0000_e68b;
                reg_en_wr   <= TRUE;
            end
            'd35: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0007;
                reg_data_wr <= 32'h0000_a06d;
                reg_en_wr   <= TRUE;
            end
            'd36: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0008;
                reg_data_wr <= 32'h0000_fcdb;
                reg_en_wr   <= TRUE;
            end
            'd37: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0009;
                reg_data_wr <= 32'h0000_a23d;
                reg_en_wr   <= TRUE;
            end
            'd38: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_000a;
                reg_data_wr <= 32'h0000_11fc;
                reg_en_wr   <= TRUE;
            end
            'd39: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_000b;
                reg_data_wr <= 32'h0000_281d;
                reg_en_wr   <= TRUE;
            end
            'd40: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_000c;
                reg_data_wr <= 32'h0000_2675;
                reg_en_wr   <= TRUE;
            end
            'd41: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_000d;
                reg_data_wr <= 32'h0000_df22;
                reg_en_wr   <= TRUE;
            end
            'd42: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_000e;
                reg_data_wr <= 32'h0000_932f;
                reg_en_wr   <= TRUE;
            end
            'd43: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_000f;
                reg_data_wr <= 32'h0000_fb9b;
                reg_en_wr   <= TRUE;
            end
            'd44: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0010;
                reg_data_wr <= 32'h0000_99a7;
                reg_en_wr   <= TRUE;
            end
            'd45: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0011;
                reg_data_wr <= 32'h0000_30b0;
                reg_en_wr   <= TRUE;
            end
            'd46: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0012;
                reg_data_wr <= 32'h0000_0254;
                reg_en_wr   <= TRUE;
            end
            'd47: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0013;
                reg_data_wr <= 32'h0000_6498;
                reg_en_wr   <= TRUE;
            end
            'd48: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0014;
                reg_data_wr <= 32'h0000_2a97;
                reg_en_wr   <= TRUE;
            end
            'd49: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0015;
                reg_data_wr <= 32'h0000_9eef;
                reg_en_wr   <= TRUE;
            end
            'd50: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0016;
                reg_data_wr <= 32'h0000_b613;
                reg_en_wr   <= TRUE;
            end
            'd51: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0017;
                reg_data_wr <= 32'h0000_257b;
                reg_en_wr   <= TRUE;
            end
            'd52: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0018;
                reg_data_wr <= 32'h0000_78d0;
                reg_en_wr   <= TRUE;
            end
            'd53: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_0019;
                reg_data_wr <= 32'h0000_e792;
                reg_en_wr   <= TRUE;
            end
            'd54: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_001a;
                reg_data_wr <= 32'h0000_9438;
                reg_en_wr   <= TRUE;
            end
            'd55: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_001b;
                reg_data_wr <= 32'h0000_24aa;
                reg_en_wr   <= TRUE;
            end
            'd56: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_001c;
                reg_data_wr <= 32'h0000_2a73;
                reg_en_wr   <= TRUE;
            end
            'd57: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_001d;
                reg_data_wr <= 32'h0000_e072;
                reg_en_wr   <= TRUE;
            end
            'd58: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_001e;
                reg_data_wr <= 32'h0000_52f9;
                reg_en_wr   <= TRUE;
            end
            'd59: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 32'h0001_001f;
                reg_data_wr <= 32'h0000_4a61;
                reg_en_wr   <= TRUE;
            end

            'd60: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= SHEET_GEN_START;
                reg_data_wr <= 'b1;
                reg_en_wr   <= TRUE;
            end
            'd61: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= SHEET_GEN_START;
                reg_data_wr <= 'b0;
                reg_en_wr   <= TRUE;
            end
            'd62: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= 'b0;
                reg_data_wr <= 'b0;
                reg_en_wr   <= FALSE;

                reg_addr_rd <= SHEET_GEN_FINISH;
                reg_en_rd   <= TRUE;
            end
            'd63: begin
                if(reg_data_rd != 'b0) begin
                    reg_addr_rd <= 'b0;
                    reg_en_rd   <= FALSE;
                    ctrl_cnt    <= ctrl_cnt + 1;

                    reg_addr_wr <= CONV_START;
                    reg_data_wr <= 'b1;
                    reg_en_wr   <= TRUE;
                end
            end
            'd64: begin
                ctrl_cnt    <= ctrl_cnt + 1;
                reg_addr_wr <= CONV_START;
                reg_data_wr <= 'b0;
                reg_en_wr   <= TRUE;
            end
            'd65: begin
                reg_addr_wr <= 'b0;
                reg_data_wr <= 'b0;
                reg_en_wr   <= FALSE;

                reg_addr_rd <= CONV_END;
                reg_en_rd   <= TRUE;
                ctrl_cnt    <= ctrl_cnt + 1;
            end
            'd66: begin
                if(reg_data_rd != 'b0) begin
                    reg_en_rd   <= FALSE;
                    reg_addr_rd <= 'b0;
                    ctrl_cnt    <= ctrl_cnt + 1;
                end
            end
            'd67: begin

            end
            default: begin
                reg_addr_wr <= 'b0;
                reg_data_wr <= 'b0;
                reg_en_wr   <= FALSE;
            end
        endcase
    end
end

endmodule