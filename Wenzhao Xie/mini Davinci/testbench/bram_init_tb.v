`timescale 1ns / 1ps

module bram_init_tb();

reg          enb = 0;
reg  [9:0]   addrb = 'b1111111111;
wire [127:0] doutb;
wire [15:0] big_16;
wire [15:0] small_16;

assign big_16 = doutb[127:112];
assign small_16 = doutb[15:0];

reg clock;
reg start = 0;
initial begin
    #5 clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    #50
    start = 1;
end

blk_mem_gen_2 mem_inst(
    .clkb(clock),
    .enb(enb),
    .doutb(doutb),
    .addrb(addrb)
);

always@(posedge clock) begin
    if(start == 1) begin
        enb   <= 1;
        addrb <= addrb + 1;
    end
end

endmodule