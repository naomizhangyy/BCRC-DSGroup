// Created date: 2019/12/5
// Creator: Xie Wenzhao

module arbitrator
#(parameter SIZE=8)
    (
    input  clock,
    input  rst_n,

    output i2c_ready,
    output buf_empty,
    output tile_continue,
    output i2c_pulse,
    input  i2c_go,

    // img2col unit 0 interface
    output            i2c_ifm_start_0,
    input             i2c_ok_0,
    input             i2c_done_0,
    input             tile_continue_0,

    input  [SIZE-1:0] ifm_wr_enable_0,
    input  [39:0]     ifm_wr_address_0,
    input  [1023:0]   pixels_from_i2c_0,

    // img2col unit 1 interface
    output            i2c_ifm_start_1,
    input             i2c_ok_1,
    input             i2c_done_1,
    input             tile_continue_1,

    input  [SIZE-1:0] ifm_wr_enable_1,
    input  [39:0]     ifm_wr_address_1,
    input  [1023:0]   pixels_from_i2c_1,

    // ifmap buffer 0 interface
    input             buf_empty_0,

    output [SIZE-1:0] ifm_wr_en_0,
    output [39:0]     ifm_wr_addr_0,
    output            i2c_ready_0,
    output            i2c_finish_0,
    output [1023:0]   pixels_to_buffer_0,
    
    // ifmap buffer 1 interface
    input             buf_empty_1,

    output [SIZE-1:0] ifm_wr_en_1,
    output [39:0]     ifm_wr_addr_1,
    output            i2c_ready_1,
    output            i2c_finish_1,
    output [1023:0]   pixels_to_buffer_1,

    // ifmap buffer 2 interface
    input             buf_empty_2,

    output [SIZE-1:0] ifm_wr_en_2,
    output [39:0]     ifm_wr_addr_2,
    output            i2c_ready_2,
    output            i2c_finish_2,
    output [1023:0]   pixels_to_buffer_2
);

localparam TRUE  = 1,
           FALSE = 0;

localparam BOTH_IDLE    = 'b00_0001,    // 01
           UNIT0_BUSY   = 'b00_0010,    // 02
           UNIT0_2_BOTH = 'b00_0100,    // 04
           BOTH_BUSY    = 'b00_1000,    // 08
           UNIT1_BUSY   = 'b01_0000,    // 10
           UNIT1_2_BOTH = 'b10_0000;    // 20
reg [5:0] current_state;

assign i2c_ready       = i2c_ok_0    || i2c_ok_1;
assign buf_empty       = buf_empty_0 || buf_empty_1 || buf_empty_2;

wire   i2c_call;
assign i2c_call = buf_empty && i2c_ready && i2c_go;
assign tile_continue   = tile_continue_0 || tile_continue_1;

reg [1:0] buf_channel_sel_0;
reg [1:0] buf_channel_sel_1;
reg [1:0] buf_channel_sel_2;

assign ifm_wr_en_0        = buf_channel_sel_0[1] ? (buf_channel_sel_0[0] ? ifm_wr_enable_1   : ifm_wr_enable_0)   : 'b0;
assign ifm_wr_addr_0      = buf_channel_sel_0[1] ? (buf_channel_sel_0[0] ? ifm_wr_address_1  : ifm_wr_address_0)  : 'b0;
assign i2c_ready_0        = buf_channel_sel_0[1] ? (buf_channel_sel_0[0] ? i2c_ok_1          : i2c_ok_0)          : 'b0;
assign i2c_finish_0       = buf_channel_sel_0[1] ? (buf_channel_sel_0[0] ? i2c_done_1        : i2c_done_0)        : 'b0;
assign pixels_to_buffer_0 = buf_channel_sel_0[1] ? (buf_channel_sel_0[0] ? pixels_from_i2c_1 : pixels_from_i2c_0) : 'b0;

assign ifm_wr_en_1        = buf_channel_sel_1[1] ? (buf_channel_sel_1[0] ? ifm_wr_enable_1   : ifm_wr_enable_0)   : 'b0;
assign ifm_wr_addr_1      = buf_channel_sel_1[1] ? (buf_channel_sel_1[0] ? ifm_wr_address_1  : ifm_wr_address_0)  : 'b0;
assign i2c_ready_1        = buf_channel_sel_1[1] ? (buf_channel_sel_1[0] ? i2c_ok_1          : i2c_ok_0)          : 'b0;
assign i2c_finish_1       = buf_channel_sel_1[1] ? (buf_channel_sel_1[0] ? i2c_done_1        : i2c_done_0)        : 'b0;
assign pixels_to_buffer_1 = buf_channel_sel_1[1] ? (buf_channel_sel_1[0] ? pixels_from_i2c_1 : pixels_from_i2c_0) : 'b0;

assign ifm_wr_en_2        = buf_channel_sel_2[1] ? (buf_channel_sel_2[0] ? ifm_wr_enable_1   : ifm_wr_enable_0)   : 'b0;
assign ifm_wr_addr_2      = buf_channel_sel_2[1] ? (buf_channel_sel_2[0] ? ifm_wr_address_1  : ifm_wr_address_0)  : 'b0;
assign i2c_ready_2        = buf_channel_sel_2[1] ? (buf_channel_sel_2[0] ? i2c_ok_1          : i2c_ok_0)          : 'b0;
assign i2c_finish_2       = buf_channel_sel_2[1] ? (buf_channel_sel_2[0] ? i2c_done_1        : i2c_done_0)        : 'b0;
assign pixels_to_buffer_2 = buf_channel_sel_2[1] ? (buf_channel_sel_2[0] ? pixels_from_i2c_1 : pixels_from_i2c_0) : 'b0;

reg buf_filling_0;
reg buf_filling_1;
reg buf_filling_2;

reg img2col_0_start_reg_0,img2col_0_start_reg_1;
reg img2col_1_start_reg_0,img2col_1_start_reg_1;
assign i2c_ifm_start_0 = img2col_0_start_reg_0 ^ img2col_0_start_reg_1;
assign i2c_ifm_start_1 = img2col_1_start_reg_0 ^ img2col_1_start_reg_1;
assign i2c_pulse = i2c_ifm_start_0 || i2c_ifm_start_1; // i2c_pulse is used to count the i2c times

always@(posedge clock or negedge rst_n) begin   // start pulse generation
    if(!rst_n) begin
        img2col_0_start_reg_0 <= 0;
        img2col_1_start_reg_0 <= 0;
    end
    else begin
        img2col_0_start_reg_0 <= img2col_0_start_reg_1;
        img2col_1_start_reg_0 <= img2col_1_start_reg_1;
    end
end

always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
        buf_channel_sel_0 <= 'b0;
        buf_channel_sel_1 <= 'b0;
        buf_channel_sel_2 <= 'b0;
        buf_filling_0     <= FALSE;
        buf_filling_1     <= FALSE;
        buf_filling_2     <= FALSE;
        current_state     <= BOTH_IDLE;

        img2col_0_start_reg_1 <= 0;
        img2col_1_start_reg_1 <= 0;
    end
    else begin
        case(current_state)
            BOTH_IDLE: begin    // 01
                if(i2c_call == TRUE) begin
                    if(buf_empty_0 == TRUE) begin
                        buf_channel_sel_0 <= 2'b10;
                        buf_filling_0     <= TRUE;
                    end
                    else if(buf_empty_1 == TRUE) begin
                        buf_channel_sel_1 <= 2'b10;
                        buf_filling_1     <= TRUE;
                    end
                    else if(buf_empty_2 == TRUE) begin
                        buf_channel_sel_2 <= 2'b10;
                        buf_filling_2     <= TRUE;
                    end
                    img2col_0_start_reg_1 <= ~img2col_0_start_reg_1;
                    current_state         <= UNIT0_BUSY;
                end
            end
            UNIT0_BUSY: begin   // 02
                if(i2c_done_0 == TRUE) begin
                    buf_channel_sel_0 <= 2'b00;
                    buf_channel_sel_1 <= 2'b00;
                    buf_channel_sel_2 <= 2'b00;
                    buf_filling_0     <= FALSE;
                    buf_filling_1     <= FALSE;
                    buf_filling_2     <= FALSE;
                    current_state     <= BOTH_IDLE;
                end
                else if(i2c_call==TRUE) begin
                    if((buf_empty_0==TRUE)&&(buf_filling_0==FALSE)) begin
                        buf_channel_sel_0 <= 2'b11;
                        buf_filling_0     <= TRUE;
                        img2col_1_start_reg_1 <= ~img2col_1_start_reg_1;
                        current_state         <= UNIT0_2_BOTH;
                    end
                    else if((buf_empty_1==TRUE)&&(buf_filling_1==FALSE)) begin
                        buf_channel_sel_1 <= 2'b11;
                        buf_filling_1     <= TRUE;
                        img2col_1_start_reg_1 <= ~img2col_1_start_reg_1;
                        current_state         <= UNIT0_2_BOTH;
                    end
                    else if((buf_empty_2==TRUE)&&(buf_filling_2==FALSE)) begin
                        buf_channel_sel_2 <= 2'b11;
                        buf_filling_2     <= TRUE;
                        img2col_1_start_reg_1 <= ~img2col_1_start_reg_1;
                        current_state         <= UNIT0_2_BOTH;
                    end
                end
            end
            UNIT0_2_BOTH: begin // 04
                current_state <= BOTH_BUSY;
            end
            BOTH_BUSY: begin    // 08
                if(i2c_done_0 == TRUE) begin
                    if(buf_channel_sel_0 == 2'b10) begin
                        buf_channel_sel_0 <= 2'b00;
                        buf_filling_0     <= FALSE;
                    end
                    if(buf_channel_sel_1 == 2'b10) begin
                        buf_channel_sel_1 <= 2'b00;
                        buf_filling_1     <= FALSE;
                    end
                    if(buf_channel_sel_2 == 2'b10) begin
                        buf_channel_sel_2 <= 2'b00;
                        buf_filling_2     <= FALSE;
                    end
                    current_state <= UNIT1_BUSY;
                end
                else if(i2c_done_1 == TRUE) begin
                    if(buf_channel_sel_0 == 2'b11) begin
                        buf_channel_sel_0 <= 2'b00;
                        buf_filling_0     <= FALSE;
                    end
                    if(buf_channel_sel_1 == 2'b11) begin
                        buf_channel_sel_1 <= 2'b00;
                        buf_filling_1     <= FALSE;
                    end
                    if(buf_channel_sel_2 == 2'b11) begin
                        buf_channel_sel_2 <= 2'b00;
                        buf_filling_2     <= FALSE;
                    end
                    current_state <= UNIT0_BUSY;
                end
            end
            UNIT1_BUSY: begin   // 10
                if(i2c_done_1 == TRUE) begin
                    buf_channel_sel_0 <= 2'b00;
                    buf_channel_sel_1 <= 2'b00;
                    buf_channel_sel_2 <= 2'b00;
                    buf_filling_0     <= FALSE;
                    buf_filling_1     <= FALSE;
                    buf_filling_2     <= FALSE;
                    current_state     <= BOTH_IDLE;
                end
                else if(i2c_call==TRUE) begin
                    if((buf_empty_0==TRUE)&&(buf_filling_0==FALSE)) begin
                        buf_channel_sel_0 <= 2'b10;
                        buf_filling_0     <= TRUE;
                        img2col_0_start_reg_1 <= ~img2col_0_start_reg_1;
                        current_state         <= UNIT1_2_BOTH;
                    end
                    else if((buf_empty_1==TRUE)&&(buf_filling_1==FALSE)) begin
                        buf_channel_sel_1 <= 2'b10;
                        buf_filling_1     <= TRUE;
                        img2col_0_start_reg_1 <= ~img2col_0_start_reg_1;
                        current_state         <= UNIT1_2_BOTH;
                    end
                    else if((buf_empty_2==TRUE)&&(buf_filling_2==FALSE)) begin
                        buf_channel_sel_2 <= 2'b10;
                        buf_filling_2     <= TRUE;
                        img2col_0_start_reg_1 <= ~img2col_0_start_reg_1;
                        current_state         <= UNIT1_2_BOTH;
                    end
                end
            end
            UNIT1_2_BOTH: begin // 20
                current_state <= BOTH_BUSY;
            end
            default: current_state <= BOTH_IDLE;
        endcase
    end
end

endmodule