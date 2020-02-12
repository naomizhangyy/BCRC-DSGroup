// Created date: 2019/12/19
// Creator: Xie Wenzhao

module dla_pool
#(parameter DATA_WID = 16)
    (
    input                        clock,
    input                        rst_n,
    input                        pool_unit_en,
    input                        pool_mod_sel,
    input  signed [DATA_WID-1:0] dat_0,
    input  signed [DATA_WID-1:0] dat_1,
    input  signed [DATA_WID-1:0] dat_2,
    input  signed [DATA_WID-1:0] dat_3,
    output                       res_valid,
    output signed [DATA_WID-1:0] res_pool
);

localparam TRUE  = 1,
           FALSE = 0;

localparam IDLE      = 'b001,
           MAX_POOL  = 'b010,
           AVER_POOL = 'b100;

reg        [2:0]          pool_state;
reg                       valid_delay_0,valid_delay_1;
reg signed [DATA_WID+1:0] aver_reg;
reg signed [DATA_WID-1:0] max_result;
reg signed [DATA_WID-1:0] aver_result;

assign res_pool  = pool_mod_sel ? aver_result : max_result;
assign res_valid = (pool_mod_sel==1) ? valid_delay_1 : valid_delay_0;

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        max_result   <= 'b0;
        aver_result  <= 'b0;
        aver_reg     <= 'b0;
        pool_state   <= IDLE;
    end
    else begin 
        case(pool_state)
            IDLE: begin
                max_result   <= 'b0;
                aver_result  <= 'b0;
                aver_reg     <= 'b0;
                if(pool_unit_en == TRUE) begin
                    if(pool_mod_sel == 1) pool_state <= AVER_POOL;
                    else pool_state <= MAX_POOL;
                end
            end
            MAX_POOL: begin
                if     ((dat_0 >= dat_1)&&(dat_0 >= dat_2)&&(dat_0 >= dat_3)) max_result <= dat_0;
                else if((dat_1 >= dat_0)&&(dat_1 >= dat_2)&&(dat_1 >= dat_3)) max_result <= dat_1;
                else if((dat_2 >= dat_0)&&(dat_2 >= dat_1)&&(dat_2 >= dat_3)) max_result <= dat_2;
                else if((dat_3 >= dat_0)&&(dat_3 >= dat_1)&&(dat_3 >= dat_2)) max_result <= dat_3;
                if(valid_delay_0 == FALSE) begin
                    pool_state    <= IDLE;
                end
                // TODO: verification max pool
            end
            AVER_POOL: begin
                aver_reg    <= dat_0 + dat_1 + dat_2 + dat_3;
                aver_result <= aver_reg[17 -: 16];
                if((valid_delay_1 == TRUE)&&(valid_delay_0 == FALSE)) begin
                    pool_state    <= IDLE;
                end
            end
            default:;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        valid_delay_0 <= FALSE;
        valid_delay_1 <= FALSE;
    end
    else begin
        valid_delay_0 <= pool_unit_en;
        valid_delay_1 <= valid_delay_0;
    end
end

endmodule