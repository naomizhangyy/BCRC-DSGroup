`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/11/15 11:15:27
// Design Name: sDavinci
// Module Name: wgt_buffer
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module wgt_buffer
#(parameter DATA_WID = 16, SIZE = 8)
    (
    input         clock,
    input         rst_n,
    //input         wgt_buffer_refresh,

    input [2:0]   ksize,
    input         wgt_wr_en,
    input [4:0]   wgt_wr_addr,
    input         i2c_ready,
    input [127:0] weights_in,
    input [3:0]   valid_num,        // 实数据
    output reg    buf_empty_wgt,

    //------------------------------
    input          cubic_fetch_en,
    input  [4:0]   fetch_num,
    output [127:0] weights_to_cubic  
);

localparam TRUE  = 1,
           FALSE = 0;

integer i;

reg [1:0] current_state;
localparam IDLE    = 2'b01,
           DATA_IN = 2'b10;

reg [4:0]          total_weights;
reg [DATA_WID-1:0] wgt_mem [199:0];     // 5*5*8

reg [15:0] weights_out [SIZE-1:0];

always@(posedge clock or negedge rst_n) begin       // main_state block
    if(!rst_n) begin
        buf_empty_wgt                   <= TRUE;
        current_state                   <= IDLE;
        for(i=0;i<200;i=i+1) wgt_mem[i] <= 'b0;
    end
    else begin
        case(current_state)
            IDLE: begin
                // TODO:refresh信号持续时间短些
                // i2c_ready为FALSE说明此时正在开始一轮传输
                if((i2c_ready==FALSE)) begin 
                    buf_empty_wgt <= TRUE;
                    current_state <= DATA_IN;
                    total_weights <= 'b0;
                end 
            end
            DATA_IN: begin
                if((wgt_wr_en==TRUE)) begin
                    case(valid_num)
                        4'b0011: begin
                            wgt_mem[wgt_wr_addr*SIZE+0] <= weights_in[15:0];
                            wgt_mem[wgt_wr_addr*SIZE+1] <= weights_in[31:16];
                            wgt_mem[wgt_wr_addr*SIZE+2] <= weights_in[47:32];
                            wgt_mem[wgt_wr_addr*SIZE+3] <= 'b0;
                            wgt_mem[wgt_wr_addr*SIZE+4] <= 'b0;
                            wgt_mem[wgt_wr_addr*SIZE+5] <= 'b0;
                            wgt_mem[wgt_wr_addr*SIZE+6] <= 'b0;
                            wgt_mem[wgt_wr_addr*SIZE+7] <= 'b0;
                        end
                        4'b1000: begin
                            wgt_mem[wgt_wr_addr*SIZE+0] <= weights_in[15:0];
                            wgt_mem[wgt_wr_addr*SIZE+1] <= weights_in[31:16];
                            wgt_mem[wgt_wr_addr*SIZE+2] <= weights_in[47:32];
                            wgt_mem[wgt_wr_addr*SIZE+3] <= weights_in[63:48];
                            wgt_mem[wgt_wr_addr*SIZE+4] <= weights_in[79:64];
                            wgt_mem[wgt_wr_addr*SIZE+5] <= weights_in[95:80];
                            wgt_mem[wgt_wr_addr*SIZE+6] <= weights_in[111:96];
                            wgt_mem[wgt_wr_addr*SIZE+7] <= weights_in[127:112];
                        end
                        default:;
                    endcase
                end
                if(i2c_ready == TRUE) begin
                    buf_empty_wgt <= FALSE;
                    current_state <= IDLE;
                end
            end
            default: current_state <= IDLE;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0;i<SIZE;i=i+1) weights_out[i] <= 'b0;
    end
    else begin
        if(cubic_fetch_en == TRUE) for(i=0;i<SIZE;i=i+1) weights_out[i] <= wgt_mem[i+fetch_num*SIZE];
        else for(i=0;i<SIZE;i=i+1) weights_out[i] <= 'b0;
    end
end
assign weights_to_cubic = {weights_out[7],weights_out[6],weights_out[5],weights_out[4],weights_out[3],weights_out[2],weights_out[1],weights_out[0]};

endmodule