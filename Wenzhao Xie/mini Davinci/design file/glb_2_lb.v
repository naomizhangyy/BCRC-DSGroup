//Created date: 2019/12/20
//Creator: Xie Wenzhao

module glb_2_lb
#(parameter RD_ADDR_WID=16, WR_ADDR_WID=10, DATA_WID=128)
    (
    input                        clock,
    input                        rst_n,

    input                        trans_start,
    output reg                   trans_end,

    input      [RD_ADDR_WID-1:0] base_addr,
    input      [7:0]             big_length,    // maximum is 256
    input      [5:0]             length,        // maximum is 32
    input      [5:0]             height,        // maximum is 32

    output reg                   rd_en,
    output reg [RD_ADDR_WID-1:0] rd_addr,
    input      [DATA_WID-1:0]    data_in,

    output reg                   wr_en,
    output reg [WR_ADDR_WID-1:0] wr_addr,
    output     [DATA_WID-1:0]    data_out
);

localparam TRUE      = 1,
           FALSE     = 0;
localparam DELAY_R2W = 2;
localparam IDLE      = 'b0001,
           RUN       = 'b0010,
           END_0     = 'b0100,
           END_1     = 'b1000;

reg [3:0]  state;
reg [5:0]  cnt_h;
reg [5:0]  cnt_v;
reg [10:0] trans_cnt;

assign data_out = data_in;

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        state     <= IDLE;
        rd_en     <= FALSE;
        wr_en     <= FALSE;
        trans_cnt <= 'b0;
        rd_addr   <= 'b0;
        wr_addr   <= 'b0;
        cnt_v     <= 'b0;
        cnt_h     <= 'b0;
        trans_end <= TRUE;
    end
    else begin
        case(state)
            IDLE: begin
                if(trans_start == TRUE) begin
                    state <= RUN;
                    trans_end <= FALSE;
                end
            end
            RUN: begin
                trans_cnt <= trans_cnt + 1;
                if(trans_cnt < length*height) begin
                    rd_addr  <= base_addr + cnt_v*big_length + cnt_h;
                    if(cnt_h < length-1) cnt_h <= cnt_h + 1;
                    else if(cnt_v < height-1) begin
                        cnt_v <= cnt_v + 1;
                        cnt_h <= 'b0;
                    end
                end
                if(trans_cnt < length*height + DELAY_R2W) rd_en <= TRUE;
                else rd_en <= FALSE;
                if((trans_cnt > 1)&&(trans_cnt < length*height + DELAY_R2W)) begin
                    wr_en   <= TRUE;
                    wr_addr <= trans_cnt - DELAY_R2W;
                end
                else if(trans_cnt == length*height + DELAY_R2W) begin
                    wr_en <= FALSE;
                    state <= END_0;
                end
            end
            END_0: begin
                state     <= END_1;
                rd_en     <= FALSE;
                wr_en     <= FALSE;
                trans_cnt <= 'b0;
                rd_addr   <= 'b0;
                wr_addr   <= 'b0;
                cnt_v     <= 'b0;
                cnt_h     <= 'b0;
                trans_end <= TRUE;
            end
            END_1: state <= IDLE;
            default:;
        endcase
    end
end

endmodule