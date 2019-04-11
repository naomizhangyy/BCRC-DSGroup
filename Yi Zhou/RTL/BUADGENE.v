`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2019 07:37:33 PM
// Design Name: 
// Module Name: BUADGENE
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


module BUADGENE(
    input   wire    clk,
    input   wire    reset,
    
    output  wire    tx_buad,
    output  wire    rx_buad
    );
    
    reg  [21:0] count_tx;
    reg  [21:0] count_rx;
    
    reg         tx_reg;
    reg         rx_reg;
    
    // tx_buad = clk(20M) / 9600 = 20833
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            count_tx <= 0;
            tx_reg <= 0;
        end
        else begin
            if (count_tx == 10417) begin
                count_tx <= 0;
                tx_reg <= ~tx_reg; 
            end
            else 
                count_tx <= count_tx+1;
        end
    end
    
    // rx_buad = clk(20M) / (9600*16) = 1302
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            count_rx <= 0;
            rx_reg <= 0;
        end
        else begin
            if (count_rx == 651) begin
                count_rx <= 0;
                rx_reg <= ~rx_reg;
            end
            else 
                count_rx <= count_rx+1;
        end
    end
    
    assign tx_buad = tx_reg;
    assign rx_buad = rx_reg;
    
endmodule
