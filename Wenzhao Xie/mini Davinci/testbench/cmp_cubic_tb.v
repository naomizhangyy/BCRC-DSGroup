// Create data: 2019/10/25
// Creator: Xie Wenzhao
// Delay time 1 cycle

module cmp_cubic_tb();

localparam TRUE     = 1,
           FALSE    = 0,
           SIZE     = 8,
           DATA_WID = 16;

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

///////////////////////////////////////////////////

reg  signed [15:0] weights [7:0][7:0];
reg  signed [15:0] pixels  [7:0][7:0];
wire signed [34:0] acc_out [7:0][7:0];

wire signed [DATA_WID*SIZE*SIZE-1:0] weights_wire;
wire signed [DATA_WID*SIZE*SIZE-1:0] pixels_wire;
wire signed [35*SIZE*SIZE-1:0]       acc_out_wire;

genvar gv_i,gv_j;
generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        for(gv_j=0;gv_j<SIZE;gv_j=gv_j+1)
        begin
            assign weights_wire[gv_i*SIZE*DATA_WID+gv_j*DATA_WID+15:gv_i*SIZE*DATA_WID+gv_j*DATA_WID] = weights[gv_i][gv_j];
            assign  pixels_wire[gv_i*SIZE*DATA_WID+gv_j*DATA_WID+15:gv_i*SIZE*DATA_WID+gv_j*DATA_WID] = pixels[gv_i][gv_j];
            assign acc_out[gv_i][gv_j] = acc_out_wire[gv_i*8*35+gv_j*35+34:gv_i*8*35+gv_j*35];
        end
    end
endgenerate

cmp_cubic cmp_cubic_inst(
    .clock(clock),
    .rst_n(rst_n),

    .weights(weights_wire),
    .pixels(pixels_wire),
    .acc_out(acc_out_wire)
);

reg test_go;
reg [2:0] test_cnt;
integer i,j;
initial begin
    test_go = 0;
    test_cnt = 3'b000;
    #200 test_go = 1;
end

always@(posedge clock) begin
    if(test_go && test_cnt <= 3'b000) begin
        test_cnt <= test_cnt + 1;
        case(test_cnt)
            3'b000:
                for(i=0;i<8;i=i+1)
                    for(j=0;j<8;j=j+1) begin
                        weights[i][j] <= (i*8+j); //i*8+j
                        pixels[i][j]  <= (-1)*(i*8+j); //-1
                    end
            default:;            
        endcase
    end
    else begin
        for(i=0;i<8;i=i+1)
            for(j=0;j<8;j=j+1) begin
                weights[i][j] <= 0;
                pixels[i][j]  <= 0;
            end
    end
end

endmodule