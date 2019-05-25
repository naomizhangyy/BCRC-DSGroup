`include "timescale.v"

module BRAM2VGA(
    input CLK_25M,
    input RESET_N,
    input EN_DISPLAY,
    output reg DISPLAY_END,
    
    output reg LED6,
    output reg LED7,

    // BRAM side
    output reg EN_RD,
    input [11:0] DATA,
    output reg [18:0] ADDR,

    // VGA side
    output reg H_SYNC,
    output reg V_SYNC,
    output reg [3:0] RED,
    output reg [3:0] GREEN,
    output reg [3:0] BLUE
);

parameter HORI_SYNC     =   96,
          HORI_BACK     =   48,
          HORI_FRONT    =   16,
          HORI_ACTIVE   =   640,
          HORI_TOTAL    =   800;
          
parameter VERT_SYNC     =   2,
          VERT_BACK     =   31,
          VERT_FRONT    =   11,
          VERT_ACTIVE   =   480,
          VERT_TOTAL    =   524;

reg cnt_go;
reg [9:0] cnt_hsync,cnt_vsync;

always@(posedge CLK_25M) begin
    if(!RESET_N) begin
        LED6 <= 1'b0;
        LED7 <= 1'b0;
        cnt_go <= 1'b0;
        //DISPLAY_END <= 1'b0;
    end
    //else if(!EN_DISPLAY) DISPLAY_END <= 1'b0; 
    else begin

        // Initialization
        if(cnt_go == 1'b0) begin
            cnt_go <= 1'b1;
            cnt_vsync <= 10'b0;
            cnt_hsync <= 10'b0;
            H_SYNC <= 1'b0;
            V_SYNC <= 1'b0;
            DISPLAY_END <= 1'b0;
        end

        // If cnt_go is 1, keep counting.
        if(cnt_go == 1'b1) begin         
            if(cnt_hsync == HORI_SYNC + HORI_BACK) H_SYNC <= 1'b1;
            if(cnt_hsync != HORI_TOTAL) cnt_hsync <= cnt_hsync + 1'b1;
            else begin
                LED6 <= ~LED6;
                H_SYNC <= 1'b0;
                cnt_hsync <= 0;
                if(cnt_vsync != VERT_TOTAL) cnt_vsync <= cnt_vsync + 1'b1;
            end
            if(cnt_vsync == VERT_SYNC) V_SYNC <= 1'b1;
            if(cnt_vsync == VERT_TOTAL) begin
                LED7 <= ~LED7;
                V_SYNC <= 1'b0;
                cnt_vsync <= 0;
                cnt_go <= 0;
            end
        end
    end
    
    
    
    if((cnt_vsync >= (VERT_SYNC + VERT_BACK)) && (cnt_vsync <= (VERT_TOTAL - VERT_FRONT -1)) && (cnt_hsync >= (HORI_SYNC + HORI_BACK - 1)) && (cnt_hsync <= (HORI_TOTAL - HORI_FRONT - 1))) begin
        
        EN_RD <= 1'b1;
        ADDR <= (cnt_vsync-35)*640 + (cnt_hsync-143);
    end
    else EN_RD <= 1'b0;

    if((cnt_vsync >= (VERT_SYNC + VERT_BACK)) && (cnt_vsync <= (VERT_TOTAL - VERT_FRONT -1)) && (cnt_hsync >= (HORI_SYNC + HORI_BACK)) && (cnt_hsync <= (HORI_TOTAL - HORI_FRONT))) begin
        
        RED <= DATA[11:8];
        GREEN <= DATA[7:4];
        BLUE <= DATA[3:0];
    end
    else begin
        RED <= 4'b0;
        GREEN <= 4'b0;
        BLUE <= 4'b0;
    end
    
  
end

endmodule:BRAM2VGA
