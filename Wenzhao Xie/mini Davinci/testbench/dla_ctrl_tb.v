`timescale 1ns/1ps

module dla_ctrl_tb();

localparam TRUE  = 1,
           FALSE = 0,
           SIZE  = 8;

parameter KERNEL_SIZE      = 32'h0000_0001,    // conf registers
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
          BIAS             = 32'h0000_000c,
          BIAS_CHN         = 32'h0000_000d,
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

          REG_INIT         = 32'h0000_001b,    // control registers
          SHEET_GEN_START  = 32'h0000_001c,

          SHEET_GEN_FINISH = 32'h0000_001d;    // status registers

reg clock;
reg rst_n;
reg sheet_gen_start;

reg [31:0] reg_addr_wr;
reg [31:0] reg_data_wr;
reg        reg_en_wr;

reg  [31:0] reg_addr_rd;
wire [31:0] reg_data_rd;
reg         reg_en_rd;

dla_ctrl dla_ctrl_inst(
    .clock(clock),
    .rst_n(rst_n),

    .reg_data_wr(reg_data_wr),
    .reg_addr_wr(reg_addr_wr),
    .reg_en_wr(reg_en_wr),

    .reg_data_rd(reg_data_rd),
    .reg_addr_rd(reg_addr_rd),
    .reg_en_rd(reg_en_rd),

    .init_begin(sheet_gen_start)
);

initial begin
    #5 clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
end

reg [5:0] init_cnt;

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        init_cnt    <= 'b0;
        reg_addr_wr <= 'b0;
        reg_data_wr <= 'b0;
        reg_en_wr   <= FALSE;
        sheet_gen_start <= FALSE;

        reg_addr_rd <= 'b0;
        reg_en_rd   <= FALSE;
    end
    else begin
        case(init_cnt)
            'd0: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= REG_INIT;
                reg_data_wr <= 'b1;
                reg_en_wr   <= TRUE;
            end
            'd1: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= REG_INIT;
                reg_data_wr <= 'b0;
                reg_en_wr   <= TRUE;
            end
            'd19: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= KERNEL_SIZE;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd20: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= STRIDE;
                reg_data_wr <= 1;
                reg_en_wr   <= TRUE;
            end
            'd2: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IFMAP_SIZE;
                reg_data_wr <= 114*114;
                reg_en_wr   <= TRUE;
            end
            'd3: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IFMAP_LENGTH;
                reg_data_wr <= 114;
                reg_en_wr   <= TRUE;
            end
            'd4: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= PAD_SIZE;
                reg_data_wr <= 1;
                reg_en_wr   <= TRUE;
            end
            'd5: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= POOL_SIZE;
                reg_data_wr <= 2;
                reg_en_wr   <= TRUE;
            end
            'd6: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= OFMAP_SIZE;
                reg_data_wr <= 58*58;
                reg_en_wr   <= TRUE;
            end
            'd7: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_0;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd8: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_1;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd9: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_2;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd10: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_LENGTH_3;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd11: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_0;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd12: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_1;
                reg_data_wr <= 32;
                reg_en_wr   <= TRUE;
            end
            'd13: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_2;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd14: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_HEIGHT_3;
                reg_data_wr <= 24;
                reg_en_wr   <= TRUE;
            end
            'd15: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_0;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd16: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_1;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd17: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_2;
                reg_data_wr <= 3;
                reg_en_wr   <= TRUE;
            end
            'd18: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= IF_TILE_NUMBER_3;
                reg_data_wr <= 1;
                reg_en_wr   <= TRUE;
                sheet_gen_start <= TRUE;
            end
            'd21: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= SHEET_GEN_START;
                reg_data_wr <= 'b1;
                reg_en_wr   <= TRUE;
            end
            'd22: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= SHEET_GEN_START;
                reg_data_wr <= 'b0;
                reg_en_wr   <= TRUE;
            end
            'd23: begin
                init_cnt    <= init_cnt + 1;
                reg_addr_wr <= 'b0;
                reg_data_wr <= 'b0;
                reg_en_wr   <= FALSE;
            end
            'd24: begin
                init_cnt    <= init_cnt + 1;
                reg_en_rd   <= TRUE;
                reg_addr_rd <= SHEET_GEN_FINISH;
            end
            'd25: begin
                if(reg_data_rd != 'b0) begin
                    reg_en_rd   <= FALSE;
                    reg_addr_rd <= 'b0;
                    init_cnt    <= init_cnt + 1;
                end
            end
            default: begin
                sheet_gen_start <= FALSE;
                reg_addr_wr <= 'b0;
                reg_data_wr <= 'b0;
                reg_en_wr   <= FALSE;
            end
        endcase
    end
end

endmodule