// Create data: 2019/10/24
// Creator: Xie Wenzhao

module cmp_layer_tb();

reg clock;
reg rst_n;

initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
end

integer i;
wire [127:0] weights;
wire [127:0] pixels;
wire [2047:0] psums_out;

cmp_layer cmp_layer_inst(
    .clock(clock),
    .rst_n(rst_n),
    .weights(weights),
    .pixels(pixels),
    .psums_out(psums_out));

reg  [15:0] wgt_reg  [7:0];
reg  [15:0] ifm_reg  [7:0];
wire [31:0] mul_wire [63:0];

genvar gv_i,gv_j;
generate
    for(gv_i=0;gv_i<8;gv_i=gv_i+1)
    begin
        assign weights[gv_i*16+15:gv_i*16] = wgt_reg[gv_i];
        assign pixels[gv_i*16+15:gv_i*16]  = ifm_reg[gv_i];
    end
endgenerate

generate
    for(gv_i=0;gv_i<8;gv_i=gv_i+1)
    begin
        for(gv_j=0;gv_j<8;gv_j=gv_j+1)
        begin
            assign mul_wire[gv_i*8+gv_j] = psums_out[gv_i*8*32+gv_j*32+31:gv_i*8*32+gv_j*32];
        end
    end
endgenerate

reg test_go;
reg [2:0] test_cnt;
initial begin
    test_cnt = 'b0;
    test_go = 0;
    for(i=0;i<8;i=i+1) wgt_reg[i] = 'b0;
    for(i=0;i<8;i=i+1) ifm_reg[i] = 'b0;
    #150 test_go = 1;
end

always@(posedge clock) begin
    if(test_go && test_cnt<=3'b011) begin
        test_cnt <= test_cnt + 1;
        case(test_cnt)
            3'b000: begin
                for(i=0;i<8;i=i+1) wgt_reg[i] <= i;
                for(i=0;i<8;i=i+1) ifm_reg[i]  <= i + 1;
            end
            3'b001: begin
                for(i=0;i<8;i=i+1) wgt_reg[i] <= i + 16;
                for(i=0;i<8;i=i+1) ifm_reg[i]  <= i + 16;
            end
            3'b010: begin
                for(i=0;i<8;i=i+1) wgt_reg[i] <= -1 * (i*16);
                for(i=0;i<8;i=i+1) ifm_reg[i]  <= i*16;
            end
            3'b011: begin
                for(i=0;i<8;i=i+1) wgt_reg[i] <= -1 * (i+32);
                for(i=0;i<8;i=i+1) ifm_reg[i]  <= -1 * (i+64);
            end
        endcase
    end
end

endmodule