`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/24 21:14:50
// Design Name: 
// Module Name: tbadder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tbadder;
    reg [3 : 0] a,b;
    wire [3 : 0] sum;
    reg Cin;
    wire Cout;
    reg [4 : 0] check;
    //logic [2 : 0] t,i,j;
    adder adder1(.X(a),.Y(b),.Cin(Cin),.sum(sum),.Cout(Cout));
    /*for( t = 0;t < 2;t = t + 1)
        Cin = t;
        for( i = 0;i < 16;i = i + 1)
            a = i;
            for( j = 0;j < 16;j = j + 1)
                begin
                b = j;
                check = a + b + Cin;
                #10 $display ($time, " %d + %d + %d = %d (%d)",a,b,Cin,{Cout,sum},check);
                end
    */
    initial repeat(50) begin
    a = {$random}%16;b = {$random}%16;Cin ={$random}%2;
    check = a + b + Cin;
    #10 $display($time," %d + %d + %d = %d(%d)",a,b,Cin,{Cout,sum},check);
    end
endmodule
