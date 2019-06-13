`timescale 1ns / 1ps

module gray2binary
    #(parameter length = 6)
    (
    input       [length-1:0]  GRAY,
    output  reg [length-1:0]  BINARY
    );
    
integer i;    
    
always@(GRAY) begin
    BINARY[length - 1] = GRAY[length - 1];
    for(i = length - 2; i >= 0; i = i-1) BINARY[i] = GRAY[i] ^ BINARY[i+1];
end
    
endmodule

