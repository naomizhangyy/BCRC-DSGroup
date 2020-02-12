// Created date: 2019/12/31
// Creator: Xie Wenzhao

module lb_2_glb(
    input              clock,
    input              rst_n,
    
    input              pixel_valid,
    input      [15:0]  of_base_addr,
    input      [15:0]  of_page_length,
    input      [4:0]   of_tile_length,
    input      [4:0]   of_tile_height,

    input      [127:0] tile_pixel,
    output reg         wr_en,
    output reg [15:0]  wr_addr,
    output reg [127:0] wr_data
);

localparam TRUE  = 1,
           FALSE = 0;

reg [15:0] of_base_addr_reg;
reg [15:0] of_page_length_reg;
reg [4:0]  of_tile_length_reg;
reg [4:0]  of_tile_height_reg;

reg [4:0] cnt_h;
reg [4:0] cnt_v;
reg [2:0] state; 

localparam IDLE = 'b001,
           BUSY = 'b010,
           WAIT = 'b100;

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        cnt_h   <= 'b0;
        cnt_v   <= 'b0;
        wr_addr <= 'b0;
        wr_data <= 'b0;
        wr_en   <= FALSE;
        state   <= IDLE;
    end
    else begin
        case(state)
            IDLE: begin
                if(pixel_valid == TRUE) begin
                    of_page_length_reg <= of_page_length;
                    of_tile_height_reg <= of_tile_height;
                    of_tile_length_reg <= of_tile_length;

                    of_base_addr_reg   <= of_base_addr;
                    state              <= BUSY;
                end
            end
            BUSY: begin
                wr_en   <= TRUE;
                wr_data <= tile_pixel;
                wr_addr <= of_base_addr_reg + cnt_v*of_page_length_reg + cnt_h;

                if(cnt_h != of_tile_length_reg - 1) cnt_h <= cnt_h + 1;
                else begin
                    cnt_h <= 'b0;
                    if(cnt_v != of_tile_height_reg - 1) cnt_v <= cnt_v + 1;
                    else begin
                        cnt_v <= 'b0;
                        state <= WAIT;
                    end
                end
            end
            WAIT: begin
                wr_en   <= FALSE;
                wr_data <= 'b0;
                wr_addr <= 'b0;
                state   <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule