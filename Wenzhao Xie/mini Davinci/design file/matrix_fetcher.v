// Created date: 2019/11/24
// Creator: Xie Wenzhao

module matrix_fetcher
#(parameter SIZE = 8)
    (
    input clock,
    input rst_n,
    input matrix_go,
    input [2:0] ksize,

    input          ifm_buf_empty_0,
    input          ifm_buf_empty_1,
    input          ifm_buf_empty_2,
    input [1023:0] ifm_matrix_in_0,
    input [1023:0] ifm_matrix_in_1,
    input [1023:0] ifm_matrix_in_2,
    input [1023:0] wgt_matrix_in,

    output         matrix_valid,    // 告诉cubic单元，矩阵数据有效
    output reg     one_buf_end,

    output              fetch_en_0,
    output              fetch_en_1,
    output              fetch_en_2,
    output reg [4:0]    fetch_num,
    output     [1023:0] ifm_matrix_out,
    output     [1023:0] wgt_matrix_out
);

localparam TRUE  = 1,
           FALSE = 0;
localparam IDLE     = 'b0001,
           WAIT_BUF = 'b0010,
           FETCH    = 'b0100,
           WAIT     = 'b1000;
                 
assign ifm_matrix_out = matrix_valid ? (matrix_valid0 ? ifm_matrix_in_0 : (matrix_valid1 ? ifm_matrix_in_1 : (matrix_valid2 ? ifm_matrix_in_2 : 'b0))) : 'b0;
assign wgt_matrix_out = matrix_valid ? wgt_matrix_in : 'b0;

assign matrix_valid = matrix_valid0 || matrix_valid1 || matrix_valid2;

reg       fetch_en;
reg [2:0] fetch_order;   
assign fetch_en_0 = fetch_order[0] ? fetch_en : FALSE;
assign fetch_en_1 = fetch_order[1] ? fetch_en : FALSE;
assign fetch_en_2 = fetch_order[2] ? fetch_en : FALSE;

wire   ifm_buf_valid;
assign ifm_buf_valid = (!ifm_buf_empty_0 && fetch_order[0]) ||
                       (!ifm_buf_empty_1 && fetch_order[1]) ||
                       (!ifm_buf_empty_2 && fetch_order[2]) ;

reg [3:0] current_state;
reg [1:0] tmp_cnt;

always@(posedge clock or negedge rst_n) begin   // ifm_matrix control
    if(!rst_n) begin
        current_state <= IDLE;
        fetch_en      <= FALSE;
        fetch_num     <= 'b0;
        fetch_order   <= 3'b001;
    end
    else begin
        case(current_state)
            IDLE: begin
                one_buf_end  <= FALSE;
                fetch_en     <= FALSE;
                tmp_cnt      <= 'b0;
                if(matrix_go == TRUE) begin     // 希望是一次matrix_go信号做完1个Loop A
                    current_state <= WAIT_BUF;
                    fetch_order  <= 3'b001;
                end
            end
            WAIT_BUF: begin
                one_buf_end  <= FALSE;
                if(ifm_buf_valid == TRUE) begin
                    current_state <= FETCH;
                    fetch_en      <= TRUE;
                    fetch_num     <= 'b0;
                end
                else fetch_en <= FALSE;
            end
            FETCH: begin
                if(fetch_num != ksize*ksize-1) begin
                    one_buf_end  <= FALSE;
                    fetch_num    <= fetch_num + 1;
                end
                else begin
                    fetch_num   <= 'b0;
                    one_buf_end <= TRUE;
                    if(fetch_order == 3'b001) fetch_order <= 3'b010;
                    else if(fetch_order == 3'b010) fetch_order <= 3'b100;
                    else fetch_order <= 3'b001;

                    if(matrix_go == FALSE) begin
                        current_state <= IDLE;
                        fetch_order   <= 'b0;
                    end
                    else begin
                        case(fetch_order)
                            3'b001:
                                if(ifm_buf_empty_1 == FALSE) current_state <= FETCH;
                                else begin
                                    fetch_en      <= FALSE;
                                    current_state <= WAIT;
                                    //current_state <= WAIT_BUF;
                                end
                            3'b010:
                                if(ifm_buf_empty_2 == FALSE) current_state <= FETCH;
                                else begin
                                    fetch_en      <= FALSE;
                                    current_state <= WAIT;
                                end
                            3'b100:
                                if(ifm_buf_empty_0 == FALSE) current_state <= FETCH;
                                else begin
                                    fetch_en      <= FALSE;
                                    current_state <= WAIT;
                                end
                            default:;
                        endcase
                    end
                end
            end
            WAIT: begin
                tmp_cnt <= tmp_cnt + 1;
                if(tmp_cnt == 2'b11) current_state <= IDLE;
            end
            default:current_state <= IDLE;
        endcase
    end
end

reg matrix_valid0,matrix_valid1,matrix_valid2;
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        matrix_valid0 <= FALSE;
        matrix_valid1 <= FALSE;
        matrix_valid2 <= FALSE;
    end
    else begin
        matrix_valid0 <= fetch_en_0;
        matrix_valid1 <= fetch_en_1;
        matrix_valid2 <= fetch_en_2;
    end
end

endmodule