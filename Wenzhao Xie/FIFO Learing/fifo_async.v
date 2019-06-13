`timescale 1ns / 1ps

module fifo_top
    #(parameter length = 16, PTR_LENGTH = 6, depth = 32)
    (
    input               RESETN,

    input               CLK_WR,
    input       [length-1:0]   DATA_WR,
    input               WR,
    output              FULL,
    //output              WR_WRG,

    input               CLK_RD,
    input               RD,
    output              EMPTY,
    //output              RD_WRG,
    output      [length-1:0]   DATA_RD
    );

reg [PTR_LENGTH-1:0] ptr_wr,ptr_rd;    // Binary
wire en_wr,en_rd;
wire [PTR_LENGTH-1:0] wr_b,rd_b;
reg  [PTR_LENGTH-1:0] ptr_wr_b,ptr_rd_b;

reg [PTR_LENGTH-1:0] ptr_wr_stage0,ptr_wr_stage1;
reg [PTR_LENGTH-1:0] ptr_rd_stage0,ptr_rd_stage1;
wire [PTR_LENGTH-1:0] ptr_wr_g,ptr_rd_g;
reg [PTR_LENGTH-1:0] rd_g,wr_g;

//assign WR_WRG = FULL    &&   WR;
//assign RD_WRG = EMPTY   &&   RD;
assign en_wr  = !FULL   &&   WR;
assign en_rd  = !EMPTY  &&   RD;
assign FULL   = (ptr_rd_b[PTR_LENGTH-2:0] == ptr_wr[PTR_LENGTH-2:0]) && (ptr_rd_b[PTR_LENGTH-1] != ptr_wr[PTR_LENGTH-1]);
assign EMPTY  = (ptr_wr_b[PTR_LENGTH-2:0] == ptr_rd[PTR_LENGTH-2:0]) && (ptr_wr_b[PTR_LENGTH-1] == ptr_rd[PTR_LENGTH-1]);

blk_mem_gen_0 dual_bram_inst(
    .clka(CLK_WR),
    .wea(WR),
    .ena(en_wr),
    .addra(ptr_wr[PTR_LENGTH-2:0]),
    .dina(DATA_WR),
    .clkb(CLK_RD),
    .enb(RD),
    .addrb(ptr_rd[PTR_LENGTH-2:0]),
    .doutb(DATA_RD));

binary2gray #(.length(PTR_LENGTH)) b2g_inst0(.BINARY(ptr_wr),.GRAY(ptr_wr_g));////////
binary2gray #(.length(PTR_LENGTH)) b2g_inst1(.BINARY(ptr_rd),.GRAY(ptr_rd_g));////////
gray2binary #(.length(PTR_LENGTH)) g2b_inst0(.GRAY(ptr_wr_stage1),.BINARY(wr_b));
gray2binary #(.length(PTR_LENGTH)) g2b_inst1(.GRAY(ptr_rd_stage1),.BINARY(rd_b));

// WR control block
always@ (posedge CLK_WR) begin
    if(!RESETN) begin
        ptr_wr <= 'b0;
        wr_g <= 'b0;
        ptr_rd_stage0 <= 'b0;
        ptr_rd_stage1 <= 'b0;
    end
    else begin
        if(en_wr) ptr_wr <= ptr_wr + 1'b1;

        // WR ptr transformation
        wr_g <= ptr_wr_g;

        // RD ptr receive
        ptr_rd_stage0 <= rd_g;
        ptr_rd_stage1 <= ptr_rd_stage0;
        ptr_rd_b <= rd_b;
    end
end

// RD control block
always@ (posedge CLK_RD) begin
    if(!RESETN) begin
        ptr_rd <= 'b0;
        rd_g <= 'b0;
        ptr_wr_stage0 <= 'b0;
        ptr_wr_stage1 <= 'b0;
    end
    else begin
        if(en_rd) ptr_rd <= ptr_rd + 1'b1;

        // RD ptr transformation
        rd_g <= ptr_rd_g;

        // WR ptr receive
        ptr_wr_stage0 <= wr_g;
        ptr_wr_stage1 <= ptr_wr_stage0;
        ptr_wr_b <= wr_b;
    end
end

endmodule:fifo_top
