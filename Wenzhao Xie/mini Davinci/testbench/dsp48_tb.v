`timescale 1ns / 1ps
// Created date: 2019/12/12
// Creator: Xie Wenzhao

module dsp48_tb();

localparam TRUE     = 1,
           FALSE    = 0,
           SIZE     = 8,
           DATA_WID = 16;

reg clock;
reg rst_n;
reg start_flag;

initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    rst_n = 1;
    #50 rst_n = 0;
    #50 rst_n = 1;
    start_flag = TRUE;
end

///////////////////////////////////////////////////

reg  [DATA_WID-1:0]   a_in;
reg  [DATA_WID-1:0]   b_in;
wire [2*DATA_WID-1:0] c_out;

mult_gen_0 mult16(
    .CLK(clock),
    .A(a_in),
    .B(b_in),
    .P(c_out)
);

reg [2:0] test_cnt;
always@(posedge clock or negedge rst_n) begin
    if(!rst_n) begin
       test_cnt <= 'b0; 
    end
    else begin
        if(start_flag == TRUE) begin
            case(test_cnt)
                3'b000: begin
                    test_cnt <= test_cnt + 1;
                    a_in <= 16'b1111_1111_1111_1111;
                    b_in <= 16'b1111_1111_1111_1001;
                end
                3'b001: begin
                    test_cnt <= test_cnt + 1;
                    a_in <= 16'b1111_1111_1111_1101;
                    b_in <= 16'b1111_1111_1111_1010;
                end
                default:;
            endcase
        end
    end
end

endmodule