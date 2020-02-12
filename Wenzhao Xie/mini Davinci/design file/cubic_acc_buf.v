// Created date: 2019/11/28
// Creator: Xie Wenzhao

// 224x224 --> padding --> 226x226 --> conv --> 224x224

module cubic_acc_buf
#(parameter SIZE = 8, DATA_WID = 16)
    (
    input                     clock,
    input                     rst_n,

    input      [1:0]          pool_size,
    input      [5:0]          tile_length,
    input      [5:0]          tile_height,
    input      [2:0]          ksize,
    input      [2:0]          stride,
    input      [4:0]          qtf_mod_sel,        // choose the quantification mode
    input                     pooling_mod_sel,    // 0:max pooling  1:average pooling(only support 2)
 
    input                     new_tile,
    input                     qtf_start,
    input                     pooling_start,
    input                     psums_valid,        // psum data is valid to input
    input      [279:0]        psums,              // 35bits * 8
    input                     one_buf_end,        // storage address shift

    input signed [DATA_WID-1:0] bias,
    output                      res_valid,
    output       [DATA_WID-1:0] res_pool
);

localparam TRUE  = 1,
           FALSE = 0;
localparam IDLE           = 'b0001, // 01
           DATA_IN        = 'b0010, // 02
           ADD_BIAS       = 'b0100, // 04
           QTF            = 'b1000; // 08

localparam pooling_size   = 2;
integer i,j;

reg [3:0] state;
reg       add_bias;

//------------DATA_IN definition---------------//
reg         [6:0]  psums_cnt;                       // 8*128 = 1024
reg  signed [45:0] psums_mem [1023:0];              // 2^15 * 2^15 * 25 * 2^10 = 2^45, 加上符号
reg                psums_valid_delay0,psums_valid_delay1;
reg                one_buf_end_delay0,one_buf_end_delay1;

wire signed [34:0] psum [SIZE-1:0];
genvar gv_i;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        assign psum[gv_i] = psums[35*gv_i+34:35*gv_i];
    end
endgenerate
//------------DATA_IN definition---------------//

//------------POOLING definition--------------//
reg [4:0]  pooling_tile_length;                 // maximum is 16
reg [4:0]  pooling_tile_height;
reg signed [15:0] qtf_mem [1023:0];

wire signed [45:0] bias_46bits;
assign bias_46bits = bias;

generate
     for(gv_i=0;gv_i<1024;gv_i=gv_i+1)
     begin
          always@(posedge clock or negedge rst_n) begin
               if(!rst_n) qtf_mem[gv_i] <= 'b0;
               else if(state == QTF) begin
                    case(qtf_mod_sel)
                    'd0: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][44 -: 15]};
                    'd1: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][43 -: 15]};
                    'd2: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][42 -: 15]};
                    'd3: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][41 -: 15]};
                    'd4: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][40 -: 15]};
                    'd5: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][39 -: 15]};
                    'd6: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][38 -: 15]};
                    'd7: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][37 -: 15]};
                    'd8: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][36 -: 15]};
                    'd9: qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][35 -: 15]};
                    'd10:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][34 -: 15]};
                    'd11:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][33 -: 15]};
                    'd12:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][32 -: 15]};
                    'd13:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][31 -: 15]};
                    'd14:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][30 -: 15]};
                    'd15:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][29 -: 15]};
                    'd16:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][28 -: 15]};
                    'd17:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][27 -: 15]};
                    'd18:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][26 -: 15]};
                    'd19:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][25 -: 15]};
                    'd20:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][24 -: 15]};
                    'd21:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][23 -: 15]};
                    'd22:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][22 -: 15]};
                    'd23:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][21 -: 15]};
                    'd24:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][20 -: 15]};
                    'd25:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][19 -: 15]};
                    'd26:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][18 -: 15]};
                    'd27:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][17 -: 15]};
                    'd28:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][16 -: 15]};
                    'd29:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][15 -: 15]};
                    'd30:qtf_mem[gv_i] <= {psums_mem[gv_i][45],psums_mem[gv_i][14 -: 15]};
                    default:;
                endcase
               end
          end
     end 
endgenerate

generate
    for(gv_i=0;gv_i<1024;gv_i=gv_i+1)
    begin
        always@(posedge clock or negedge rst_n) begin
            if(!rst_n) psums_mem[gv_i] <= 'b0;
            else begin
                if(new_tile == TRUE) psums_mem[gv_i] <= 'b0;
                else if(add_bias == TRUE) psums_mem[gv_i] <= psums_mem[gv_i] + bias_46bits;
            end
        end
    end
endgenerate

reg [4:0] pool_h_cnt;
reg [4:0] pool_v_cnt;

reg                       pool_unit_en;
reg signed [DATA_WID-1:0] dat_0;
reg signed [DATA_WID-1:0] dat_1;
reg signed [DATA_WID-1:0] dat_2;
reg signed [DATA_WID-1:0] dat_3;

dla_pool dla_pool_inst(
     .clock(clock),
     .rst_n(rst_n),
     .pool_unit_en(pool_unit_en),
     .pool_mod_sel(pooling_mod_sel),
     .dat_0(dat_0),
     .dat_1(dat_1),
     .dat_2(dat_2),
     .dat_3(dat_3),
     .res_valid(res_valid),
     .res_pool(res_pool)
);

reg       pool_init_done;
reg [1:0] pool_state;
localparam POOL_IDLE = 2'b01,
           POOL_RUN  = 2'b10;
//------------POOLING definition--------------//

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        state      <= IDLE;
        psums_cnt  <= 'b0;
        add_bias   <= FALSE;
        pool_init_done <= FALSE;
        pooling_tile_height <= 'b0;
        pooling_tile_length <= 'b0;
    end
    else begin
        case(state)
            IDLE: begin
                pool_init_done      <= FALSE;
                if(new_tile == TRUE) begin
                    state <= DATA_IN;
                end
            end
            DATA_IN: begin
                if(psums_valid_delay1 == FALSE) psums_cnt <= 'b0;
                if(psums_valid_delay1 == TRUE) begin
                    if(one_buf_end_delay1 == TRUE) psums_cnt <= psums_cnt + 1;
                    psums_mem[psums_cnt*SIZE+0] <= psums_mem[psums_cnt*SIZE+0] + psum[0];
                    psums_mem[psums_cnt*SIZE+1] <= psums_mem[psums_cnt*SIZE+1] + psum[1];
                    psums_mem[psums_cnt*SIZE+2] <= psums_mem[psums_cnt*SIZE+2] + psum[2];
                    psums_mem[psums_cnt*SIZE+3] <= psums_mem[psums_cnt*SIZE+3] + psum[3];
                    psums_mem[psums_cnt*SIZE+4] <= psums_mem[psums_cnt*SIZE+4] + psum[4];
                    psums_mem[psums_cnt*SIZE+5] <= psums_mem[psums_cnt*SIZE+5] + psum[5];
                    psums_mem[psums_cnt*SIZE+6] <= psums_mem[psums_cnt*SIZE+6] + psum[6];
                    psums_mem[psums_cnt*SIZE+7] <= psums_mem[psums_cnt*SIZE+7] + psum[7];
                end
                else if(qtf_start == TRUE) begin
                    add_bias <= TRUE;
                    state    <= ADD_BIAS;
                end
            end
            ADD_BIAS: begin
                add_bias <= FALSE;
                state    <= QTF;
            end
            QTF: begin
                // qtf at the generate part
                if(pooling_start == TRUE) begin
                    state               <= IDLE;
                    pooling_tile_length <= (tile_length-ksize)/stride+1;
                    pooling_tile_height <= (tile_height-ksize)/stride+1;
                    pool_init_done      <= TRUE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always@(posedge clock or negedge rst_n) begin       // DATA_IN ctrl signal delay control
    if(!rst_n) begin
        psums_valid_delay0 <= FALSE;
        psums_valid_delay1 <= FALSE;
        one_buf_end_delay0 <= FALSE;
        one_buf_end_delay1 <= FALSE;
    end
    else begin
        psums_valid_delay0 <= psums_valid;
        psums_valid_delay1 <= psums_valid_delay0;
        one_buf_end_delay0 <= one_buf_end;
        one_buf_end_delay1 <= one_buf_end_delay0;
    end
end

wire [9:0] dat_0_index;
wire [9:0] dat_1_index;
wire [9:0] dat_2_index; 
wire [9:0] dat_3_index;
assign dat_0_index = pool_v_cnt*pooling_tile_length + pool_h_cnt;
assign dat_1_index = pool_v_cnt*pooling_tile_length + pool_h_cnt + 1;
assign dat_2_index = (pool_v_cnt+1)*pooling_tile_length + pool_h_cnt;
assign dat_3_index = (pool_v_cnt+1)*pooling_tile_length + pool_h_cnt + 1;

always@(posedge clock or negedge rst_n) begin       // pooling control part
    if(!rst_n) begin
        pool_unit_en <= FALSE;
        dat_0        <= 'b0;
        dat_1        <= 'b0;
        dat_2        <= 'b0;
        dat_3        <= 'b0;
        pool_h_cnt   <= 'b0;
        pool_v_cnt   <= 'b0;
        pool_state   <= POOL_IDLE;
    end
    else begin
        case(pool_state)
            POOL_IDLE: begin
                dat_0      <= 'b0;
                dat_1      <= 'b0;
                dat_2      <= 'b0;
                dat_3      <= 'b0;
                pool_h_cnt <= 'b0;
                pool_v_cnt <= 'b0;
                if(pool_init_done == TRUE) begin
                    pool_unit_en    <= TRUE;
                    pool_state      <= POOL_RUN;
                end
                else begin
                    pool_unit_en    <= FALSE;
                end
            end
            POOL_RUN: begin
                if(pool_size == 2) begin
                    //dat_0 <= qtf_mem[pool_v_cnt*pooling_tile_length     + pool_h_cnt    ];
                    //dat_1 <= qtf_mem[pool_v_cnt*pooling_tile_length     + pool_h_cnt + 1];
                    //dat_2 <= qtf_mem[(pool_v_cnt+1)*pooling_tile_length + pool_h_cnt    ];
                    //dat_3 <= qtf_mem[(pool_v_cnt+1)*pooling_tile_length + pool_h_cnt + 1];
                    dat_0 <= qtf_mem[dat_0_index];
                    dat_1 <= qtf_mem[dat_1_index];
                    dat_2 <= qtf_mem[dat_2_index];
                    dat_3 <= qtf_mem[dat_3_index];

                    if(pool_h_cnt < pooling_tile_length-2) pool_h_cnt <= pool_h_cnt + 2;  // pooling_size=2
                    else begin
                        pool_h_cnt <= 'b0;
                        if(pool_v_cnt < pooling_tile_height-2) pool_v_cnt <= pool_v_cnt + 2;
                        else begin
                            pool_v_cnt <= 'b0;
                            pool_state <= POOL_IDLE;
                        end
                    end
                end
                else if(pool_size == 1) begin
                    dat_0 <= qtf_mem[pool_v_cnt*pooling_tile_length + pool_h_cnt];
                    dat_1 <= qtf_mem[pool_v_cnt*pooling_tile_length + pool_h_cnt];
                    dat_2 <= qtf_mem[pool_v_cnt*pooling_tile_length + pool_h_cnt];
                    dat_3 <= qtf_mem[pool_v_cnt*pooling_tile_length + pool_h_cnt];
                
                    if(pool_h_cnt < pooling_tile_length-1) pool_h_cnt <= pool_h_cnt + 1;  // pooling_size=2
                    else begin
                        pool_h_cnt <= 'b0;
                        if(pool_v_cnt < pooling_tile_height-1) pool_v_cnt <= pool_v_cnt + 1;
                        else begin
                            pool_unit_en <= FALSE;
                            pool_v_cnt <= 'b0;
                            pool_state <= POOL_IDLE;
                        end
                    end
                end
            end
            default:;
        endcase
    end
end

endmodule