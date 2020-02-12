`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 2019/11/14 14:16:28
// Last Modified: 2019/11/14
// Design Name: 
// Module Name: ifm_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module ifm_buffer
#(parameter DATA_WID = 16, SIZE = 8)
    (
    input         clock,
    input         rst_n,

    input [2:0]   ksize,
    input         ifm_wr_en,
    input [4:0]   ifm_wr_addr,
    input         i2c_ready,
    input         i2c_done,
    input [127:0] pixels_in,
    input [3:0]   valid_num,        // 实数据

    output        buf_empty,
    //------------------------------
    input          cubic_fetch_en,
    input  [4:0]   fetch_num,
    output [127:0] pixels_to_cubic
);

localparam TRUE  = 1,
           FALSE = 0;

integer i;

reg [2:0] current_state;
localparam IDLE    = 3'b001,
           HOLD    = 3'b010,
           DATA_IN = 3'b100;

reg [4:0]          total_pixels;
reg [DATA_WID-1:0] ifm_mem [199:0];

reg [15:0] pixels_out [SIZE-1:0];

reg write_flag;
reg read_flag;

always@(posedge clock or negedge rst_n) begin       // main_state block
    if(!rst_n) begin
        write_flag                      <= 0;
        current_state                   <= IDLE;
        for(i=0;i<200;i=i+1) ifm_mem[i] <= 'b0;
    end
    else begin
        case(current_state)
            IDLE: begin
                if(i2c_ready == FALSE) begin
                    current_state <= HOLD;
                    total_pixels  <= 'b0;
                end
            end
            HOLD: begin
                current_state <= DATA_IN;
            end
            DATA_IN: begin
                if(ifm_wr_en == TRUE) begin
                    case(valid_num)
                        4'b0011: begin
                            ifm_mem[ifm_wr_addr*SIZE+0] <= pixels_in[15:0];
                            ifm_mem[ifm_wr_addr*SIZE+1] <= pixels_in[31:16];
                            ifm_mem[ifm_wr_addr*SIZE+2] <= pixels_in[47:32];
                            ifm_mem[ifm_wr_addr*SIZE+3] <= 'b0;
                            ifm_mem[ifm_wr_addr*SIZE+4] <= 'b0;
                            ifm_mem[ifm_wr_addr*SIZE+5] <= 'b0;
                            ifm_mem[ifm_wr_addr*SIZE+6] <= 'b0;
                            ifm_mem[ifm_wr_addr*SIZE+7] <= 'b0;
                        end
                        4'b1000: begin
                            ifm_mem[ifm_wr_addr*SIZE+0] <= pixels_in[15:0];
                            ifm_mem[ifm_wr_addr*SIZE+1] <= pixels_in[31:16];
                            ifm_mem[ifm_wr_addr*SIZE+2] <= pixels_in[47:32];
                            ifm_mem[ifm_wr_addr*SIZE+3] <= pixels_in[63:48];
                            ifm_mem[ifm_wr_addr*SIZE+4] <= pixels_in[79:64];
                            ifm_mem[ifm_wr_addr*SIZE+5] <= pixels_in[95:80];
                            ifm_mem[ifm_wr_addr*SIZE+6] <= pixels_in[111:96];
                            ifm_mem[ifm_wr_addr*SIZE+7] <= pixels_in[127:112];
                        end
                        default:;
                    endcase
                end
                if(i2c_done == TRUE) begin
                    current_state <= IDLE;
                    write_flag    <= !write_flag;
                end
            end
            default:;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        read_flag <= 0;
        for(i=0;i<SIZE;i=i+1) pixels_out[i] <= 'b0;
    end
    else begin
        if(cubic_fetch_en == TRUE) begin
            for(i=0;i<SIZE;i=i+1) pixels_out[i] <= ifm_mem[fetch_num*SIZE+i];
            if(fetch_num == ksize*ksize-1) read_flag <= !read_flag;
        end
        else for(i=0;i<SIZE;i=i+1) pixels_out[i] <= 'b0;
    end
end
assign pixels_to_cubic = {pixels_out[7],pixels_out[6],pixels_out[5],pixels_out[4],pixels_out[3],pixels_out[2],pixels_out[1],pixels_out[0]};
assign buf_empty = read_flag ^~ write_flag;

endmodule