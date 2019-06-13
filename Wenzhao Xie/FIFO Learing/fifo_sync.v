`timescale 1ns / 1ps

module fifo_top
    #(parameter length = 16,depth = 32,ptr_length = 5)
    (
    input                       CLK,
    input                       RESETN,

    input       [length-1:0]    DATA_WR,
    input                       WR,
    input                       RD,

    output                      FULL,
    output                      EMPTY,
    //output                      WR_WRG,
    //output                      RD_WRG,
    output      [length-1:0]    DATA_RD
    );

localparam ETY = 3'b001,
          NF  = 3'b010,
          FUL = 3'b100;

reg [2:0]               state                      ;
reg [ptr_length-1:0]    ptr_wr,ptr_rd              ;

wire en_wr;

blk_mem_gen_0 bram_inst(
    .clka(CLK),
    .wea(WR && (state != FULL)),
    .addra(ptr_wr),
    .dina(DATA_WR),
    .ena(WR && (state != FULL)),
    
    .clkb(CLK),
    .enb(RD && (state != EMPTY)),
    .addrb(ptr_rd),
    .doutb(DATA_RD)
);

//assign WR_WRG = WR && (state == FUL);
//assign RD_WRG = RD && (state == ETY);
assign EMPTY  = (state == ETY);
assign FULL   = (state == FUL);

// RD/WR control logic
always@(posedge CLK) begin
    if(!RESETN) begin
        ptr_rd <= 'b0;
        ptr_wr <= 'b0;
        state <= ETY;
    end
    else begin
        // RD is not allowed when empty
        if(RD)
            case(state)
                ETY: begin
                    //DATA_RD <= 'b0;
                end
                NF: begin
                    ptr_rd <= ptr_rd + 1'b1;
                    if(ptr_wr == (ptr_rd + 1'b1) && !WR) state <= ETY;
                end
                FUL: begin
                    state <= NF;
                    ptr_rd <= ptr_rd + 1'b1;
                end
                default: state <= ETY;
            endcase
    
        // WR is not allowed when full
        if(WR)
            case(state)
                ETY: begin
                    state <= NF;
                    ptr_wr <= ptr_wr + 1'b1;
                end
                NF: begin
                    ptr_wr <= ptr_wr + 1'b1;
                    if(ptr_rd == (ptr_wr + 1'b1) && !RD) state <= FUL;
                end
                FUL: ;
                default: state <= ETY;
            endcase
    end
end

endmodule:fifo_top
