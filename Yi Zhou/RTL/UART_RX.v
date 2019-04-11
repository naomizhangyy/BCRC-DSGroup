`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2019 09:27:59 PM
// Design Name: 
// Module Name: UART_RX
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


module UART_RX
#(parameter WIDTH=8)(
    input   wire             rx_clk,
    input   wire             rx_reset,
    input   wire             rx,
    
    output  wire             ready,
    output  wire             error,
    output  wire [WIDTH-1:0] data_out
    );
    
    //wire             start_rx;              
    reg              error_reg, error_next;
    reg              start_reg1, start_next1;
    reg              start_reg2, start_next2;
    reg  [WIDTH-1:0] data_reg, data_next;
    reg  [3:0]       count_reg, count_next;
    reg  [3:0]       count_clk, count_cnext;
    reg  [1:0]       state, next_state;
    
    localparam  idle=2'b00, rece=2'b01,
                check = 2'b11, finish=2'b10;
    
    always @(posedge rx_clk or negedge rx_reset) begin
        if (!rx_reset) begin
            data_reg <= 'b0;
            count_reg <= 'b0;
            count_clk <= 'b0;
            state <= idle;
            start_reg1 <= 1;
            start_reg2 <= 1;
            error_reg <= 0;
        end
        
        else begin
           data_reg <= data_next;
           count_reg <= count_next;
           count_clk <= count_cnext;
           state <= next_state;
           start_reg1 <= start_next1;
           start_reg2 <= start_next2;
           error_reg <= error_next;
        end
    end 
    
    always @(*) begin
        case(state)
            idle: begin
                    error_next = 0;
                    data_next = 'b0;
                    count_next = 'b0;
                    if (count_clk==7) begin
                        start_next1 = rx;
                        start_next2 = start_reg1;
                        count_cnext = 0;
                    end
                    else
                        count_cnext = count_clk+1;
                    if (!start_reg1 & start_reg2 == 1) begin
                        next_state = rece;
                    end    
                end
            rece: begin
                    error_next = 0;
                    count_cnext = count_clk+1;
                    if (count_clk == 15) begin
                        data_next = {rx,data_reg[WIDTH-1:1]};
                        if (count_next==WIDTH-1) begin
                            count_next = 'b0;
                            next_state = check;
                        end
                        else begin
                            count_next = count_reg+1;
                            next_state = rece;
                        end
                    end
                end
            check: begin
                    count_cnext = count_clk+1;
                    if (count_clk == 15) begin
                        error_next = (rx==(^data_reg))?1:0;
                        next_state = finish;
                    end
                end
            finish: begin
                    count_cnext = count_clk+1;
                    if (count_clk == 15) begin
                        next_state = idle;
                        if (rx != 1)
                            error_next = 1;
                        else
                            error_next = error_reg;
                    end
                end
        endcase
    end       
    
    assign ready = (state==finish) ? 1:0;
    assign data_out = data_reg;
    assign error = error_reg;
    
endmodule
