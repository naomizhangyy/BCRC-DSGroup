// Create Date: 2019/10/24
// Creator: Xie Wenzhao

module cmp_unit_tb();

localparam TRUE  = 1,
           FALSE = 0;

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

reg [15:0] pixel;
reg [15:0] weight;

wire [31:0] psum_out;

cmp_unit cmp_unit_inst(
    .clock(clock),
    .rst_n(rst_n),
    .weight(weight),
    .pixel(pixel),
    .psum_out(psum_out));

reg test_go;
reg [2:0] test_cnt;

initial begin
    test_cnt = 'b0;
    test_go = FALSE;
    #150 test_go = TRUE;
end

always@(posedge clock) begin
    if(test_go && (test_cnt<=3'b101)) begin
        test_cnt <= test_cnt + 1;
        case(test_cnt)
            3'b000: begin
                weight <= 16;
                pixel <= 32;
            end
            3'b001: begin
                weight <= 0;
                pixel <= 255;
            end
            3'b010: begin
                weight <= -25;
                pixel <= 255;
            end
            3'b011: begin
                weight <= -256;
                pixel <= -1024;
            end
            3'b100: begin
                weight <= 32767;
                pixel <= 32767;
            end
            3'b101: begin
                weight <= -32768;
                pixel <= -32768;
            end
        endcase
    end
end

endmodule