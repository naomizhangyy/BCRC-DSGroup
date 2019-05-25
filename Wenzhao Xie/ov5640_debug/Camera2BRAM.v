`include "timescale.v"

module Camera2BRAM(
    input RESET_N,
    input EN_STORE,

    output reg LED4,
    output reg LED5,

    // Camera side
    input PCLK,
    input H_REF,
    input V_SYNC,
    input [7:0] DATA,
    // Use RGB444, xR + GB

    // BRAM side
    output reg MID_SIGNAL,
    output PCLK_OUT,    // Output to BRAM
    output reg EN_WR,
    output reg [11:0] RGB,
    output reg [18:0] ADDR
);

assign PCLK_OUT = PCLK;

reg flag_href,flag_vsync,href_valid,vsync_valid;
reg flag_combine;
reg [7:0] rgb_in;
reg [9:0] cnt_href,cnt_vsync;

always@(posedge PCLK) begin
    if(!RESET_N) begin
        LED4 <= 1'b0;
        LED5 <= 1'b0;
        EN_WR <= 1'b0;
        cnt_href <= 10'b0;
        cnt_vsync <= 10'b0;
        flag_combine <= 1'b0;
        flag_href <= 1'b1;
        flag_vsync <= 1'b0;
        href_valid <= 1'b0;
        MID_SIGNAL <= 1'b0;
    end
    else if(EN_STORE) begin
        
        flag_vsync <= V_SYNC;
        if(flag_vsync && !V_SYNC) begin
            vsync_valid <= 1'b1;
            cnt_href <= 10'b0;
            cnt_vsync <= 10'b0;
        end
        
        if(vsync_valid) begin               // Start one frame transformation
            
            flag_href <= H_REF;
            if(!flag_href && H_REF) href_valid <= 1'b1;
            if(flag_href && !H_REF) href_valid <= 1'b0;

            if(href_valid || (!flag_href && H_REF)) begin
                
                if(flag_combine == 1'b1) begin

                    // DATA transportation
                    EN_WR <= 1'b1;
                    RGB <= {rgb_in[3:0],DATA};
                    ADDR <= cnt_vsync*640 + cnt_href;

                    // HREF and V_SYNC counting
                    if(cnt_href != 639) begin
                        cnt_href <= cnt_href + 1'b1;
                    end
                    else begin
                        LED4 <= ~LED4;
                        cnt_href <= 10'b0;
                        href_valid <= 1'b0;
                        
                        if(cnt_vsync == 200) MID_SIGNAL <= 1'b1;////////////
                        
                        if(cnt_vsync != 479) begin
                            cnt_vsync <= cnt_vsync + 1'b1;
                        end
                        else begin      
                            LED5 <= ~LED5;
                            flag_combine <= 1'b0;
                            cnt_href <= 10'b0;
                            cnt_vsync <= 10'b0;
                            vsync_valid <= 1'b0;
                            flag_href <= 1'b1;
                            flag_vsync <= 1'b1;
                        end
                    end
                    flag_combine <= 1'b0;
                end
                else begin
                    EN_WR <= 1'b0;
                    rgb_in <= DATA;
                    flag_combine <= 1'b1;
                end
            end
        end
    end
end

endmodule:Camera2BRAM

