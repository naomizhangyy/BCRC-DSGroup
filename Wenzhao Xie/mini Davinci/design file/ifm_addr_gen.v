`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// 
// Create Date: 2019/10/30 16:17:46
// Design Name: sDavinci
// Module Name: ifm_addr_gen_tb
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module ifm_addr_gen
#(parameter SIZE=8)
    (
    input                   clock,
    input                   rst_n,
    input                   tile_start,                // 命令启动新一次tile的卷积首地址传输操作
    input                   tile_continue,

    input        [5:0]      tile_length,               // 实数据
    input        [5:0]      tile_height,               // 实数据
    input        [2:0]      stride,
    input        [2:0]      ksize,                     // Max ksize is 5
    
    output wire  [79:0]     base_address,
    output reg   [SIZE-1:0] base_addr_valid,
    output reg              addr_gen_done,
    output reg              ifmap_end                  // 所有地址已经输出完毕
);

integer i,j;
localparam TRUE  = 1,
           FALSE = 0;

reg [4:0] state;
localparam IDLE  = 'b00001,
           START = 'b00010,
           WAIT  = 'b00100,
           LAST  = 'b01000,
           END   = 'b10000;

wire [6:0] size_times;
wire [2:0] size_left;
reg [9:0] total_times;
reg [6:0] size_cnt;             // 用来记录当前已进行的8的整数倍次数                    

reg [9:0] addr_mem [1023:0];    // 这里以32*32，ksize=1, stride=1计算，此时地址需求最大
reg [5:0] length_num;
reg [5:0] height_num;

reg [4:0] wait_cnt;
reg [9:0] base_addr [SIZE-1:0];
assign base_address = {base_addr[7],base_addr[6],base_addr[5],base_addr[4],base_addr[3],base_addr[2],base_addr[1],base_addr[0]};

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
        ifmap_end <= TRUE;
        addr_gen_done <= FALSE;
        for(i=0;i<=1023;i=i+1) addr_mem[i] <= 'b0;                      // 地址列表初始化
        for(i=0;i<SIZE;i=i+1) base_addr[i] <= 'b0;
    end
    else begin
        case(state)
            IDLE: begin
                if(tile_start == TRUE) begin
                    length_num <= (tile_length - ksize)/stride + 1;     // 行方向上的卷积次数
                    height_num <= (tile_height - ksize)/stride + 1;     // 列方向上的卷积次数
                    for(i=0;i<=1023;i=i+1) addr_mem[i] <= 'b0;          // 地址列表初始化
                    size_cnt <= 'b0;
                    state <= START;                                     // 对一次tile的卷积首地址传输操作开始
                end
                addr_gen_done <= FALSE;
            end
            START: begin
                for(i=0;i<height_num;i=i+1) begin
                    for(j=0;j<length_num;j=j+1) begin
                        addr_mem[i*length_num + j] <= i*stride*tile_length + j*stride;      // 地址列表填入数据
                    end
                end
                for(i=0;i<8;i=i+1) base_addr_valid[i] <= TRUE;          // 8个i2c全部开启，一般认为对一个tile的卷积次数必然不小于8
                total_times <= length_num * height_num;                 // 总的卷积次数(实数据) // TODO: check
                addr_gen_done <= TRUE;
                ifmap_end <= FALSE;                                     // end信号置零, 不然将维持TRUE
                state <= WAIT;
            end
            WAIT: begin
                if(size_cnt == 0) begin
                    for(i=0;i<SIZE;i=i+1) base_addr[i] <= addr_mem[size_cnt*SIZE+i];
                    size_cnt <= size_cnt + 1;
                end
                if(tile_continue == TRUE) begin                         // TODO:注意，tile_continue每持续一个周期便换一组输出地址
                    for(i=0;i<SIZE;i=i+1) base_addr[i] <= addr_mem[size_cnt*SIZE+i];
                    if(size_cnt != size_times-1) begin                  // 未运行完最后一次8的整数倍，回到WAIT继续等待tile_continue信号
                        size_cnt <= size_cnt + 1;
                        state <= WAIT;
                    end
                    else if(size_left != 'b0) begin                     // 运行完最后一次8的整数倍，但还有0< <8次卷积需要进行
                        state <= LAST;
                        size_cnt <= size_cnt + 1;
                    end
                    else begin                                          // 运行完最后一次8的整数倍，已无卷积需要进行
                        wait_cnt <= 'b0;
                        state <= END;
                        ifmap_end <= TRUE;
                    end
                end
            end
            LAST: begin
                if(tile_continue == TRUE) begin
                    
                    case(size_left)
                        'd1: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= 'b0;
                            base_addr[2]       <= 'b0;
                            base_addr[3]       <= 'b0;
                            base_addr[4]       <= 'b0;
                            base_addr[5]       <= 'b0;
                            base_addr[6]       <= 'b0;
                            base_addr[7]       <= 'b0;
                            base_addr_valid[1] <= FALSE;
                            base_addr_valid[2] <= FALSE;
                            base_addr_valid[3] <= FALSE;
                            base_addr_valid[4] <= FALSE;
                            base_addr_valid[5] <= FALSE;
                            base_addr_valid[6] <= FALSE;
                            base_addr_valid[7] <= FALSE;
                        end
                        'd2: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= addr_mem[size_cnt*8 + 1];
                            base_addr[2]       <= 'b0;
                            base_addr[3]       <= 'b0;
                            base_addr[4]       <= 'b0;
                            base_addr[5]       <= 'b0;
                            base_addr[6]       <= 'b0;
                            base_addr[7]       <= 'b0;
                            base_addr_valid[2] <= FALSE;
                            base_addr_valid[3] <= FALSE;
                            base_addr_valid[4] <= FALSE;
                            base_addr_valid[5] <= FALSE;
                            base_addr_valid[6] <= FALSE;
                            base_addr_valid[7] <= FALSE;
                        end
                        'd3: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= addr_mem[size_cnt*8 + 1];
                            base_addr[2]       <= addr_mem[size_cnt*8 + 2];
                            base_addr[3]       <= 'b0;
                            base_addr[4]       <= 'b0;
                            base_addr[5]       <= 'b0;
                            base_addr[6]       <= 'b0;
                            base_addr[7]       <= 'b0;
                            base_addr_valid[3] <= FALSE;
                            base_addr_valid[4] <= FALSE;
                            base_addr_valid[5] <= FALSE;
                            base_addr_valid[6] <= FALSE;
                            base_addr_valid[7] <= FALSE;
                        end
                        'd4: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= addr_mem[size_cnt*8 + 1];
                            base_addr[2]       <= addr_mem[size_cnt*8 + 2];
                            base_addr[3]       <= addr_mem[size_cnt*8 + 3];
                            base_addr[4]       <= 'b0;
                            base_addr[5]       <= 'b0;
                            base_addr[6]       <= 'b0;
                            base_addr[7]       <= 'b0;
                            base_addr_valid[4] <= FALSE;
                            base_addr_valid[5] <= FALSE;
                            base_addr_valid[6] <= FALSE;
                            base_addr_valid[7] <= FALSE;
                        end
                        'd5: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= addr_mem[size_cnt*8 + 1];
                            base_addr[2]       <= addr_mem[size_cnt*8 + 2];
                            base_addr[3]       <= addr_mem[size_cnt*8 + 3];
                            base_addr[4]       <= addr_mem[size_cnt*8 + 4];
                            base_addr[5]       <= 'b0;
                            base_addr[6]       <= 'b0;
                            base_addr[7]       <= 'b0;
                            base_addr_valid[5] <= FALSE;
                            base_addr_valid[6] <= FALSE;
                            base_addr_valid[7] <= FALSE;
                        end
                        'd6: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= addr_mem[size_cnt*8 + 1];
                            base_addr[2]       <= addr_mem[size_cnt*8 + 2];
                            base_addr[3]       <= addr_mem[size_cnt*8 + 3];
                            base_addr[4]       <= addr_mem[size_cnt*8 + 4];
                            base_addr[5]       <= addr_mem[size_cnt*8 + 5];
                            base_addr[6]       <= 'b0;
                            base_addr[7]       <= 'b0;
                            base_addr_valid[6] <= FALSE;
                            base_addr_valid[7] <= FALSE;
                        end
                        'd7: begin
                            base_addr[0]       <= addr_mem[size_cnt*8 + 0];
                            base_addr[1]       <= addr_mem[size_cnt*8 + 1];
                            base_addr[2]       <= addr_mem[size_cnt*8 + 2];
                            base_addr[3]       <= addr_mem[size_cnt*8 + 3];
                            base_addr[4]       <= addr_mem[size_cnt*8 + 4];
                            base_addr[5]       <= addr_mem[size_cnt*8 + 5];
                            base_addr[6]       <= addr_mem[size_cnt*8 + 6];
                            base_addr[7]       <= 'b0;
                            base_addr_valid[7] <= FALSE;
                        end
                        default:;
                    endcase
                    
                    ifmap_end <= TRUE;
                    state <= END;
                    wait_cnt <= 'b0;
                    size_cnt <= 'b0;
                end
            end
            END: begin
                if(wait_cnt != ksize*ksize + 2) wait_cnt <= wait_cnt + 1;
                else begin
                    //for(i=0;i<SIZE;i=i+1) base_addr_valid[i] <= FALSE;
                    //for(i=0;i<SIZE;i=i+1) base_addr[i] = 'b0;
                    addr_gen_done <= FALSE;
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign size_times = total_times[9:3];                         // size=8, size_time为总次数对8的倍数
assign size_left  = total_times[2:0];                         // size=8, size_left为总次数对8的余数

endmodule