`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2019 06:30:23 PM
// Design Name: 
// Module Name: UART_SYS
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


module UART_SYS
#(parameter WIDTH=8)(
    input   wire             clk,
    input   wire             reset,
    
    input   wire             tx_wen,
    input   wire             rx_ren,
    input   wire             rx,
    input   wire [WIDTH-1:0] wdata_tx_fifo,
    
    output  wire             tx,
    output  wire [WIDTH-1:0] rdata_rx_fifo,
    
    output  wire    tx_full,
    output  wire    tx_empty,
    output  wire    rx_full,
    output  wire    rx_empty
    );
        
    // data signals between fifo and uart
    wire [WIDTH-1:0] tx_data;
    wire [WIDTH-1:0] rx_data;
    
    // control signals between fifo and uart
    wire    tx_request;
    
    // uart's statue
    wire    tx_done;
    wire    rx_done;
    wire    rx_error;
    
    // uart clk
    wire    tx_clk;
    wire    rx_clk;
    
    // Buad genetator
    BUADGENE Buadge(
        .clk        (clk),
        .reset      (reset),
        .tx_buad    (tx_clk),
        .rx_buad    (rx_clk)
    );
    
    // fifo of receiver 
    FIFO #(.WIDTH(WIDTH)) RX_FIFO(
        .fifo_clk       (clk),
        .fifo_reset     (reset),
        .fifo_wen       (rx_done),
        .fifo_ren       (rx_ren),
        .fifo_wdata     (rx_data),
        .fifo_rdata     (rdata_rx_fifo),
        .fifo_full      (rx_full),
        .fifo_empty     (rx_empty)
    ); 
    
    // receiver
    UART_RX #(.WIDTH(WIDTH)) RX(
        .rx_clk         (rx_clk),
        .rx_reset       (reset),
        .rx             (rx),
        .ready          (rx_done),
        .error          (rx_error),
        .data_out       (rx_data)
    );
    
    // fifo of transmitter
    FIFO #(.WIDTH(WIDTH)) TX_FIFO(
        .fifo_clk       (tx_clk),
        .fifo_reset     (reset),
        .fifo_wen       (tx_wen),
        .fifo_ren       (tx_request),
        .fifo_wdata     (wdata_tx_fifo),
        .fifo_rdata     (tx_data),
        .fifo_full      (tx_full),
        .fifo_empty     (tx_empty)
    );
    
    // transmitter
    UART_TX #(.WIDTH(WIDTH)) TX(
        .tx_clk         (tx_clk),
        .tx_reset       (reset),
        .tx_start       (!tx_empty),
        .data_in        (tx_data),
        .request        (tx_request),
        .tx_done        (tx_done)  ,
        .tx             (tx)         
    );
    
endmodule
