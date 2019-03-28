`timescale 1ns/1ps
module t;
    logic [7 : 0] a,b;
	logic clock;
	wire equal;
	initial
	    begin
		  a=0;
		  b=0;
		  clock =0;
		end
		always #50 clock = ~clock;
		always @ (posedge clock)
		    begin 
			    a = {$random}%256;
				b = {$random}%256;
		    end
		initial
		    begin #10000 $stop; end
	compare    m(.equal(equal),.a(a),.b(b));
endmodule
		