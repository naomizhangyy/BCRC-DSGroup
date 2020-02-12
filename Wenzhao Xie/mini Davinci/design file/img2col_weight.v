// Created date: 2019/10/19
// Creator: Xie Wenzhao
//
// Description: 
// kernel的存储格式应该为，一个bram buffer存储一个kernel set的kernels。一个地址空间为128bits，可存储8个
// INT16的weights，这8个应为某一kernel pixel位置8个深度下的pixel，下一个地址为次一位置的8个深度下的pixel。
// 如此往复，直到遍历ksize?个位置，此即应为本模块一次img2col_go操作中应当转换的kernel数据。
// 

module img2col_weight
#(parameter DATA_WID=16, SIZE=8)
    (
    input                               clock,
    input                               rst_n,
    input                               i2c_wgt_start,      // img2col开始信号

    input             [2:0]             kernel_size,        // 可为1,3,5
    input             [127:0]           wgt_in,             // INT16*8
    input             [3:0]             valid_num,          // 128位中有几个16位有效
    
    output    reg                       i2c_ready,          // img2col单元已准备好，ctrl模块可以暂时撤去控制信号

    output    reg     [4:0]             wgt_rd_addr,        // 每个地址存8个16位数
    output    reg                       wgt_rd_en,          // 读kernel数据使能信号

    output    reg     [4:0]             wgt_wr_addr,        // 写kernel数据地址
    output    wire                      wgt_wr_en,          // 写kernel数据使能信号
    output    wire    [127:0]           wgt_out             // INT16*8
);

localparam TRUE  = 1,
           FALSE = 0,
           rd2wr_delay = 2;

localparam IDLE     =  3'b001,      // main state
           START    =  3'b010,
           WAIT     =  3'b100;

reg [2:0] state;
reg [2:0] next_state;

reg [2:0] ksize;                    // kernel size
reg [4:0] kernel_cnt;               // 计算当前已完成传输的kernel pixel数

reg img2col_go;

reg [4:0] wr_addr_delay_reg0;
reg [127:0] wr_data_delay_reg0;

assign wgt_out = wgt_in;
assign num_valid = valid_num;

always@(posedge clock or negedge rst_n) begin       // state状态转换
    if(!rst_n) state <= IDLE;
    else state <= next_state;
end

always@(*) begin                                    // next_state状态转换
    case(state)
        IDLE: 
            if(i2c_wgt_start==TRUE) next_state = START;
            else next_state = IDLE;
        START: 
            if(i2c_ready == TRUE) next_state = WAIT;
            else next_state = START;
        WAIT: begin
            if(kernel_cnt == ksize**2 + rd2wr_delay) next_state = IDLE;
            else next_state = WAIT;
        end
        default: next_state = IDLE;
    endcase
end

always@(posedge clock or negedge rst_n) begin       // state状态行为
    if(!rst_n) begin
        i2c_ready <= TRUE;
        img2col_go <= FALSE;
    end
    else begin
        case(state)
            IDLE:;
            START: begin
                i2c_ready <= FALSE;
                img2col_go <= TRUE;
                ksize <= kernel_size;               // store kernel size
            end
            WAIT: begin
                if(kernel_cnt == ksize**2 + rd2wr_delay) begin
                    img2col_go <= FALSE;
                    i2c_ready <= TRUE;
                end
            end
            default:;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin       // This block generates the rd signals.
    if(!rst_n) begin
        wgt_rd_addr <= 'b0;
        kernel_cnt <= 'b0;
        wgt_rd_en <= FALSE;
    end
    else begin
        if(img2col_go) begin
            if(kernel_cnt != ksize**2 + rd2wr_delay) begin
                kernel_cnt <= kernel_cnt + 1;
                wgt_rd_en <= TRUE;
            end
            else begin
                wgt_rd_en <= FALSE;
                kernel_cnt <= 'b0;
            end
            
            if(kernel_cnt < ksize**2) wgt_rd_addr <= kernel_cnt;
            else wgt_rd_addr <= 'b0;
        end
        else begin
            wgt_rd_addr <= 'b0;
            kernel_cnt <= 'b0;
            wgt_rd_en <= FALSE;
        end
    end
end

always@(posedge clock or negedge rst_n) begin       // wr address and enable signal generate
    if(!rst_n) begin
        wr_addr_delay_reg0 <= 'b0;
        wgt_wr_addr <= 'b0;
    end
    else begin
        wr_addr_delay_reg0 <= wgt_rd_addr;
        wgt_wr_addr <= wr_addr_delay_reg0;
    end
end
assign wgt_wr_en = (kernel_cnt > rd2wr_delay) ? wgt_rd_en : FALSE;

endmodule