`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2019 07:57:23 PM
// Design Name: 
// Module Name: URAT_TX
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


module UART_TX 
#(parameter WIDTH = 8)(
    input   wire             tx_clk,
    input   wire             tx_reset,
    input   wire             tx_start,
    input   wire [WIDTH-1:0] data_in,
    
    output  wire             request,
    output  wire             tx_done,
    output  wire             tx 
    );
     // define inside signals
    wire             start_tr;
    //reg              tx_check;
    reg              start_reg1, start_reg2;
    reg              tx_reg, tx_next;
    reg  [WIDTH-1:0] data_reg, data_next;
    reg  [3:0]       count_reg, count_next;
    
    // define state
    localparam  idle=3'b000, start=3'b001, trans=3'b011, 
                check=3'b010, stop=3'b110;
    
    // define state register
    reg [2:0] current_state, next_state;
    
    // detect tx_start signal
    always @(posedge tx_clk or negedge tx_reset) begin
        if (!tx_reset) begin
            start_reg1 <= 0;
            start_reg2 <= 0;
        end
        else begin
            start_reg1 <= tx_start;
            start_reg2 <= start_reg1;
        end
    end
    
    assign start_tr = start_reg1 & (~start_reg2);
    
    // state transition
    always @(posedge tx_clk or negedge tx_reset) begin
        if (!tx_reset) begin
            current_state <= idle;
            count_reg <= 0;
            data_reg <= 0;
            tx_reg <= 1;
        end 
        
        else begin
            current_state <= next_state;
            count_reg <= count_next;
            data_reg <= data_next;
            tx_reg <= tx_next;
        end
    end
    
    always @(*) begin
        next_state = current_state;
        tx_next = tx_reg;
        data_next = data_reg;
        count_next = count_reg; 
        case (current_state)
            idle: begin
                    //tx_check = 0;
                    tx_next = 1;
                    data_next = 'b0;
                    count_next = 'b0;
                    if (start_tr)
                        next_state = start;
                    else
                        next_state = idle;
                end
            start: begin
                    //tx_check = 0;
                    tx_next = 0;
                    data_next = data_in;
                    count_next = 'b0;
                    next_state = trans;
                end
            trans: begin
                    tx_next = data_reg[0];
                    //tx_check = tx_check^data_reg[0];
                    data_next = data_reg >> 1;
                    if (count_reg == WIDTH-1) begin
                        next_state = check;
                        count_next = 'b0;
                    end
                    else begin
                        count_next = count_reg+1;
                        next_state = trans;
                    end
                end
            check: begin
                    tx_next = ^data_reg;
                    next_state = stop;
                end
            stop: begin
                    //tx_check = 0;
                    tx_next = 1;
                    next_state = idle;
                end
        endcase
    end 
    
    assign tx = tx_reg;
    assign tx_done = (current_state == stop) ? 1:0;
    assign request = (next_state==start) ? 1:0;
    
endmodule
