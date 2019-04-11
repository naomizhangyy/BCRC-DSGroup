`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2019 06:57:01 PM
// Design Name: 
// Module Name: FIFO
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


module FIFO
#(parameter PTR=4, WIDTH=8, DEPTH=16)(
    input   wire    fifo_clk,
    input   wire    fifo_reset,
    
    input   wire                fifo_wen,
    input   wire                fifo_ren,
    input   wire [WIDTH-1:0]    fifo_wdata,
    output  wire [WIDTH-1:0]    fifo_rdata,
        
    output  wire                fifo_full,
    output  wire                fifo_empty
    );
    
    // The size of inside memory
    reg  [WIDTH-1:0] BRAM [DEPTH-1:0];
    
    // inside signals
    wire                full_reg_nxt, empty_reg_nxt;
    reg                 full_reg, empty_reg;
    reg  [PTR-1:0]      w_ptr, w_ptr_nxt;
    reg  [PTR-1:0]      r_ptr, r_ptr_nxt;
    reg  [WIDTH-1:0]    rdata;
    
    // write data
    always @(posedge fifo_clk) begin
        if (fifo_wen)
            BRAM[w_ptr] <= fifo_wdata;
    end
    
    // read data
    always @(posedge fifo_clk) begin
        if (fifo_ren)
            rdata <= BRAM[r_ptr];
    end
    
    assign fifo_rdata = rdata;
    
    always @(posedge fifo_clk or negedge fifo_reset) begin
        if (!fifo_reset) begin
            w_ptr <= 0;
            r_ptr <= 0;
            full_reg <= 0;
            empty_reg <= 1;
        end
        
        else begin
            w_ptr <= w_ptr_nxt;
            r_ptr <= r_ptr_nxt;
            full_reg <= full_reg_nxt;
            empty_reg <= empty_reg_nxt;
        end
    end
    
    always @(*) begin
        w_ptr_nxt = w_ptr;
        if (~fifo_full & fifo_wen) begin
            if (w_ptr == DEPTH-1)
                w_ptr_nxt = 0;
            else
                w_ptr_nxt = w_ptr+1;
        end
    end
    
    always @(*)  begin
        r_ptr_nxt = r_ptr;
        if (~fifo_empty & fifo_ren) begin
            if (r_ptr == DEPTH-1)
                r_ptr_nxt = 0;
            else 
                r_ptr_nxt = r_ptr+1; 
        end
    end
    
    assign full_reg_nxt = (w_ptr_nxt==r_ptr)? 1:0;
    assign empty_reg_nxt = (r_ptr_nxt == w_ptr)? 1:0;
    
    assign fifo_full = full_reg;
    assign fifo_empty = empty_reg;
    
endmodule
