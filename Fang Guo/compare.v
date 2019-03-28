`timescale 1ns/1ps
module compare(
    input [7 : 0]  a,b,
	output  equal
	);
	assign equal=(a>b)?1:0;
endmodule