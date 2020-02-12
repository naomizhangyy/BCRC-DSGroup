// Created date: 2019/12/19
// Creator: Xie Wenzhao

module pool_mem
#(parameter SIZE=8, DATA_WID=16, POOL_SIZE=2)
    (
    input          clock,
    input          rst_n,

    input  [5:0]   tile_length_to_qtf,
    input  [5:0]   tile_height_to_qtf,
    input  [2:0]   ksize,
    input  [2:0]   stride,

    input  [2:0]   pad_size,
    input  [3:0]   pad_mod_sel,

    input  [127:0] res_pool,
    input          res_valid,

    input              tile_dump,
    output reg         tile_valid,
    output reg [127:0] tile_pixel,
    output reg         dump_end,

    // to lb_2_glb
    output reg [4:0]   dump_height,
    output reg [4:0]   dump_length,
    output reg         pad_end
);

localparam TRUE  = 1,
           FALSE = 0;

localparam IDLE    = 'b01,
           DATA_IN = 'b10;

reg [9:0] dump_cnt_h;
reg [9:0] dump_cnt_v;
reg [1:0] dump_state;
localparam DUMP_IDLE = 2'b01,
           DUMP_BUSY = 2'b10;

reg  [127:0] pad_mem [1295:0];    // maximum is (32+4)*(32+4) = 1296
reg  [8:0]   cnt_h;
reg  [8:0]   cnt_v;
reg  [4:0]   length;
reg  [4:0]   height;
reg  [1:0]   current_state;
wire [127:0] res_comb_wire;
wire signed [15:0] res_pool_wire [SIZE-1:0];

genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        assign res_pool_wire[gv_i] = res_pool[gv_i*DATA_WID+15:gv_i*DATA_WID]; 
    end
endgenerate

assign res_comb_wire = {res_pool_wire[7],res_pool_wire[6],res_pool_wire[5],res_pool_wire[4],
                        res_pool_wire[3],res_pool_wire[2],res_pool_wire[1],res_pool_wire[0]};

generate 
    for(gv_i=0;gv_i<1296;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n) begin
            if(!rst_n) pad_mem[gv_i] <= 'b0;
            else if(dump_end == TRUE) pad_mem[gv_i] <= 'b0; 
        end
    end
endgenerate

always@(posedge clock or negedge rst_n) begin   // data input block
    if(!rst_n) begin
        current_state <= IDLE;
        cnt_h         <= 'b0;
        cnt_v         <= 'b0;
        length        <= 'b0;
        height        <= 'b0;
        pad_end       <= FALSE;
    end
    else begin
        case(current_state)
            IDLE: begin
                pad_end <= FALSE;
                if(res_valid == TRUE) begin
                    cnt_v         <= 'b0;
                    cnt_h         <= 'b0;
                    length        <= ((tile_length_to_qtf-ksize)/stride+1)/POOL_SIZE;
                    height        <= ((tile_height_to_qtf-ksize)/stride+1)/POOL_SIZE;
                    current_state <= DATA_IN;
                end
            end
            DATA_IN: begin
                if(res_valid == FALSE) current_state <= IDLE;
                else begin
                    if(cnt_h < length-1) cnt_h <= cnt_h + 1;
                    else begin
                        cnt_h <= 'b0;
                        if(cnt_v < height-1) cnt_v <= cnt_v + 1;
                        else begin
                            current_state <= IDLE;
                            pad_end       <= TRUE;
                        end
                    end
                    case(pad_mod_sel)
                        'd1: pad_mem[(cnt_v+pad_size)*(length+pad_size)+(cnt_h+pad_size)] <= res_comb_wire;

                        'd2: pad_mem[(cnt_v+pad_size)*length+cnt_h] <= res_comb_wire;

                        'd3: pad_mem[(cnt_v+pad_size)*(length+pad_size)+cnt_h] <= res_comb_wire;

                        'd4: pad_mem[cnt_v*(length+pad_size)+(cnt_h+pad_size)] <= res_comb_wire;

                        'd5: pad_mem[cnt_v*length+cnt_h] <= res_comb_wire;

                        'd6: pad_mem[cnt_v*(length+pad_size)+cnt_h] <= res_comb_wire;

                        'd7: pad_mem[cnt_v*(length+pad_size)+(cnt_h+pad_size)] <= res_comb_wire;

                        'd8: pad_mem[cnt_v*length+cnt_h] <= res_comb_wire;

                        'd9: pad_mem[cnt_v*(length+pad_size)+cnt_h] <= res_comb_wire;
                        default:;
                    endcase
                end
            end
            default:;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin  // data output block
    if(!rst_n) begin
        tile_valid  <= FALSE;
        tile_pixel  <= 'b0;
        dump_cnt_h  <= 'b0;
        dump_cnt_v  <= 'b0;
        dump_length <= 'b0;
        dump_height <= 'b0;
        dump_end    <= FALSE;
        dump_state  <= DUMP_IDLE;
    end
    else begin
        case(dump_state)
            DUMP_IDLE: begin
                dump_end  <= FALSE;
                if(tile_dump == TRUE) begin
                    case(pad_mod_sel)
                        'd1: begin
                            dump_length <= length + pad_size;
                            dump_height <= height + pad_size;
                        end
                        'd2: begin
                            dump_length <= length;
                            dump_height <= height + pad_size;
                        end
                        'd3: begin
                            dump_length <= length + pad_size;
                            dump_height <= height + pad_size;
                        end
                        'd4: begin
                            dump_length <= length + pad_size;
                            dump_height <= height;
                        end
                        'd5: begin
                            dump_length <= length;
                            dump_height <= height;
                        end
                        'd6: begin
                            dump_length <= length + pad_size;
                            dump_height <= height;
                        end
                        'd7: begin
                            dump_length <= length + pad_size;
                            dump_height <= height + pad_size;
                        end
                        'd8: begin
                            dump_length <= length;
                            dump_height <= height + pad_size;
                        end
                        'd9: begin
                            dump_length <= length + pad_size;
                            dump_height <= height + pad_size;
                        end
                        default: begin
                            dump_height <= 'b0;
                            dump_length <= 'b0;
                        end
                    endcase
                    tile_valid    <= TRUE;
                    dump_state    <= DUMP_BUSY;
                end
                else begin
                    tile_valid <= FALSE;
                    tile_pixel <= 'b0;
                end
            end
            DUMP_BUSY: begin
                tile_pixel <= pad_mem[dump_cnt_v*dump_length + dump_cnt_h];
                if(dump_cnt_h < dump_length - 1) dump_cnt_h <= dump_cnt_h + 1;
                else begin
                    dump_cnt_h <= 'b0;
                    if(dump_cnt_v < dump_height - 1) dump_cnt_v <= dump_cnt_v + 1;
                    else begin
                        dump_cnt_v <= 'b0;
                        dump_end   <= TRUE;
                        dump_state <= DUMP_IDLE;
                    end
                end
            end
            default:;
        endcase
    end
end

endmodule