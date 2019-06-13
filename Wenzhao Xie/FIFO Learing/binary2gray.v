`timescale 1ns / 1ps

module binary2gray
    #(parameter length = 6)
    (
    input      [length-1:0] BINARY,
    output reg [length-1:0] GRAY
    );

integer i;
    
always@(BINARY) begin
    GRAY[length-1] = BINARY[length-1];
    for(i=0;i<=length-2;i=i+1) GRAY[i] = BINARY[i] ^ BINARY[i+1];
end
    
endmodule
