`timescale 1ns / 1ps

module TOP_MODULE(
    input SYS_CLK,
    input RESET_N,
    
    output LED0,
    output LED1,
    //output LED2,
    //output LED3,
    output LED4,
    output LED5,
    output LED6,
    output LED7,

    // Camera side
    input PCLK,
    input VSYNC_CAMERA,
    input HREF,
    input [7:0] DATA,

    inout SIOD,
    output SIOC,

    output OV5640_RESETN,
    output OV5640_PWDN,
    input RESET_CLK,
    output XCLK,

    // Display side
    output VSYNC_DISPLAY,
    output HSYNC,
    output [3:0] RED,
    output [3:0] GREEN,
    output [3:0] BLUE
    );

    wire clk_display,clk_24m;
    assign XCLK = clk_24m;

    clk_wiz_0 clk_wiz_inst(
    .reset(RESET_CLK),
    .clk_in1(SYS_CLK),
    .clk_out1(clk_display),
    .clk_out2(clk_24m)
    );

    wire end_init;
    wire en_store,en_display;
    wire end_store,end_display;
    wire mid_signal;

    wire en_wr,pclk;
    wire [11:0] rgb;
    wire [18:0] addr;
    
    Camera2BRAM camera2bram_inst(
    .RESET_N(RESET_N),
    .EN_STORE(end_init),

    .PCLK(PCLK),
    .H_REF(HREF),
    .V_SYNC(VSYNC_CAMERA),
    .DATA(DATA),

    .PCLK_OUT(pclk),
    .EN_WR(en_wr),
    .RGB(rgb),
    .ADDR(addr),
    .LED4(LED4),
    .LED5(LED5),
    .MID_SIGNAL(mid_signal)
    );

    wire en_rd;
    wire [11:0] data_rd;
    wire [18:0] addr_rd;

    BRAM2VGA bram2vga_inst(
    .CLK_25M(clk_display),
    .RESET_N(RESET_N),
    .EN_DISPLAY(mid_signal),
    .DISPLAY_END(end_display),

    .EN_RD(en_rd),
    .DATA(data_rd),
    .ADDR(addr_rd),
    .LED6(LED6),
    .LED7(LED7),

    .H_SYNC(HSYNC),
    .V_SYNC(VSYNC_DISPLAY),
    .RED(RED),
    .BLUE(BLUE),
    .GREEN(GREEN)
    );

    blk_mem_gen_0 blk_mem_inst(
    .clka(pclk),
    .ena(1'b1),
    .wea(en_wr),
    .addra(addr),
    .dina(rgb),

    .clkb(clk_display),
    .enb(en_rd),
    .addrb(addr_rd),
    .doutb(data_rd)
    );

    wire wr_end,wr;
    wire [7:0] data_sccb;
    wire [15:0] addr_sccb;
    wire sccb_start;

    SCCB_DATA sccb_data_inst(
    .CLK(SYS_CLK),
    .RESET_N(RESET_N),
    .WR_END(wr_end),

    .LED0(LED0),
    .LED1(LED1),

    .WR(wr),
    .DATA(data_sccb),
    .ADDR(addr_sccb),
    .SCCB_START(sccb_start),
    .OV5640_RESETN(OV5640_RESETN),
    .OV5640_PWDN(OV5640_PWDN),

    .END_INIT(end_init)
    );

    SCCB_CTRL sccb_ctrl_inst(
    .CLK(SYS_CLK),
    .RESET(RESET_N),
    .WR(wr),
    .ADDR(addr_sccb),
    .DATA_WR(data_sccb),
    .SCCB_START(sccb_start),

    .WR_END(wr_end),
    .SIOC(SIOC),
    .SIOD(SIOD)
    );

endmodule
