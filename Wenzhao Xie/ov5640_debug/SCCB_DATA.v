`timescale 1ns / 1ps

module SCCB_DATA(
    input CLK,
    input RESET_N,
    input WR_END,
    input SCCB_START,

    output reg OV5640_RESETN,
    output reg OV5640_PWDN,

    output reg LED0,
    output reg LED1,
    output reg END_INIT,
    output reg WR,
    output reg [7:0] DATA,
    output reg [15:0] ADDR
    );

parameter REG_NUM           =   301;
parameter send_data         =   4'b0001,
          wait_end          =   4'b0010,
          wait_end_to_end   =   4'b0100,
          IDLE              =   4'b1000;

reg [11:0] wait_a_minute;

reg [3:0] state;
reg [8:0] cnt_conf;
reg [23:0] conf_mem [REG_NUM-1:0];

reg init_end;
reg [21:0] cnt_init;
parameter DELAY_2MS   = 200000,
          DELAY_6MS   = 600000,
          DELAY_20MS  = 2000000;

always @(posedge CLK) begin
    if(!RESET_N) begin
        cnt_conf <= 9'b0;
        WR <= 0;
        END_INIT <= 1'b0;

        wait_a_minute <= 16'b0;

		conf_mem[1]  <=   {16'h3023, 8'h01};  // continue auto focus
        conf_mem[2]  <=   {16'h3022, 8'h04};
        
        conf_mem[3]  <=   {16'h3103, 8'h03};
        conf_mem[4]  <=   {16'h3017, 8'hff};
        conf_mem[5]  <=   {16'h3018, 8'hff};
        conf_mem[6]  <=   {16'h3034, 8'h1A};
        conf_mem[7]  <=   {16'h3037, 8'h13};
        conf_mem[8]  <=   {16'h3108, 8'h01};
        conf_mem[9]  <=   {16'h3630, 8'h36};
        
        conf_mem[10]  <=   {16'h3631, 8'h0e};
        conf_mem[11]  <=   {16'h3632, 8'he2};
        conf_mem[12]  <=   {16'h3633, 8'h12};
        conf_mem[13]  <=   {16'h3621, 8'he0};
        conf_mem[14]  <=   {16'h3704, 8'ha0};
        conf_mem[15]  <=   {16'h3703, 8'h5a};
        conf_mem[16]  <=   {16'h3715, 8'h78};
        conf_mem[17]  <=   {16'h3717, 8'h01};
        conf_mem[18]  <=   {16'h370b, 8'h60};
        conf_mem[19]  <=   {16'h3705, 8'h1a};
        
        conf_mem[20]  <=   {16'h3905, 8'h02};
        conf_mem[21]  <=   {16'h3906, 8'h10};
        conf_mem[22]  <=   {16'h3901, 8'h0a};
        conf_mem[23]  <=   {16'h3731, 8'h12};
        conf_mem[24]  <=   {16'h3600, 8'h08};
        conf_mem[25]  <=   {16'h3601, 8'h33};
        conf_mem[26]  <=   {16'h302d, 8'h60};
        conf_mem[27]  <=   {16'h3620, 8'h52};
        conf_mem[28]  <=   {16'h371b, 8'h20};
        conf_mem[29]  <=   {16'h471c, 8'h50};
        
        conf_mem[30]  <=   {16'h3a13, 8'h43};
        conf_mem[31]  <=   {16'h3a18, 8'h00};
        conf_mem[32]  <=   {16'h3a19, 8'hf8};
        conf_mem[33]  <=   {16'h3635, 8'h13};
        conf_mem[34]  <=   {16'h3636, 8'h03};
        conf_mem[35]  <=   {16'h3634, 8'h40};
        conf_mem[36]  <=   {16'h3622, 8'h01};
        conf_mem[37]  <=   {16'h3c01, 8'h34};
        conf_mem[38]  <=   {16'h3c04, 8'h28};
        conf_mem[39]  <=   {16'h3c05, 8'h98};
        
        conf_mem[40]  <=   {16'h3c06, 8'h00};
        conf_mem[41]  <=   {16'h3c07, 8'h08};
        conf_mem[42]  <=   {16'h3c08, 8'h00};
        conf_mem[43]  <=   {16'h3c09, 8'h1c};
        conf_mem[44]  <=   {16'h3c0a, 8'h9c};
        conf_mem[45]  <=   {16'h3c0b, 8'h40};
        conf_mem[46]  <=   {16'h3810, 8'h00};
        conf_mem[47]  <=   {16'h3811, 8'h10};
        conf_mem[48]  <=   {16'h3812, 8'h00};
        conf_mem[49]  <=   {16'h3708, 8'h64};
        
        conf_mem[50]  <=   {16'h4001, 8'h02};
        conf_mem[51]  <=   {16'h4005, 8'h1a};
        conf_mem[52]  <=   {16'h3000, 8'h00};
        conf_mem[53]  <=   {16'h3004, 8'hff};
        conf_mem[54]  <=   {16'h300e, 8'h58};
        conf_mem[55]  <=   {16'h302e, 8'h00};
        conf_mem[56]  <=   {16'h4300, 8'hA1};    // format RGB444, xR GB
        conf_mem[57]  <=   {16'h501f, 8'h01};    // format RGB
        conf_mem[58]  <=   {16'h440e, 8'h00};
        conf_mem[59]  <=   {16'h5000, 8'ha7};
        
        conf_mem[60]  <=   {16'h3a0f, 8'h30};
        conf_mem[61]  <=   {16'h3a10, 8'h28};
        conf_mem[62]  <=   {16'h3a1b, 8'h30};
        conf_mem[63]  <=   {16'h3a1e, 8'h26};
        conf_mem[64]  <=   {16'h3a11, 8'h60};
        conf_mem[65]  <=   {16'h3a1f, 8'h14};
        conf_mem[66]  <=   {16'h5800, 8'h23};
        conf_mem[67]  <=   {16'h5801, 8'h14};
        conf_mem[68]  <=   {16'h5802, 8'h0f};
        conf_mem[69]  <=   {16'h5803, 8'h0f};
        
        conf_mem[70]  <=   {16'h5804, 8'h12};
        conf_mem[71]  <=   {16'h5805, 8'h26};
        conf_mem[72]  <=   {16'h5806, 8'h0c};
        conf_mem[73]  <=   {16'h5807, 8'h08};
        conf_mem[74]  <=   {16'h5808, 8'h05};
        conf_mem[75]  <=   {16'h5809, 8'h05};
        conf_mem[76]  <=   {16'h580a, 8'h08};
        conf_mem[77]  <=   {16'h580b, 8'h0d};
        conf_mem[78]  <=   {16'h580c, 8'h08};
        conf_mem[79]  <=   {16'h580d, 8'h03};
        
        conf_mem[80]  <=   {16'h580e, 8'h00};
        conf_mem[81]  <=   {16'h580f, 8'h00};
        conf_mem[82]  <=   {16'h5810, 8'h03};
        conf_mem[83]  <=   {16'h5811, 8'h09};
        conf_mem[84]  <=   {16'h5812, 8'h07};
        conf_mem[85]  <=   {16'h5813, 8'h03};
        conf_mem[86]  <=   {16'h5814, 8'h00};
        conf_mem[87]  <=   {16'h5815, 8'h01};
        conf_mem[88]  <=   {16'h5816, 8'h03};
        conf_mem[89]  <=   {16'h5817, 8'h08};
        
        conf_mem[90]  <=   {16'h5818, 8'h0d};
        conf_mem[91]  <=   {16'h5819, 8'h08};
        conf_mem[92]  <=   {16'h581a, 8'h05};
        conf_mem[93]  <=   {16'h581b, 8'h06};
        conf_mem[94]  <=   {16'h581c, 8'h08};
        conf_mem[95]  <=   {16'h581d, 8'h0e};
        conf_mem[96]  <=   {16'h581e, 8'h29};
        conf_mem[97]  <=   {16'h581f, 8'h17};
        conf_mem[98]  <=   {16'h5820, 8'h11};
        conf_mem[99]  <=   {16'h5821, 8'h11};
        
        conf_mem[100]  <=   {16'h5822, 8'h15};
        conf_mem[101]  <=   {16'h5823, 8'h28};
        conf_mem[102]  <=   {16'h5824, 8'h46};
        conf_mem[103]  <=   {16'h5825, 8'h26};
        conf_mem[104]  <=   {16'h5826, 8'h08};
        conf_mem[105]  <=   {16'h5827, 8'h26};
        conf_mem[106]  <=   {16'h5828, 8'h64};
        conf_mem[107]  <=   {16'h5829, 8'h26};
        conf_mem[108]  <=   {16'h582a, 8'h24};
        conf_mem[109]  <=   {16'h582b, 8'h22};
        
        conf_mem[110]  <=   {16'h582c, 8'h24};
        conf_mem[111]  <=   {16'h582d, 8'h24};
        conf_mem[112]  <=   {16'h582e, 8'h06};
        conf_mem[113]  <=   {16'h582f, 8'h22};
        conf_mem[114]  <=   {16'h5830, 8'h40};
        conf_mem[115]  <=   {16'h5831, 8'h42};
        conf_mem[116]  <=   {16'h5832, 8'h24};
        conf_mem[117]  <=   {16'h5833, 8'h26};
        conf_mem[118]  <=   {16'h5834, 8'h24};
        conf_mem[119]  <=   {16'h5835, 8'h22};
        
        conf_mem[120]  <=   {16'h5836, 8'h22};
        conf_mem[121]  <=   {16'h5837, 8'h26};
        conf_mem[122]  <=   {16'h5838, 8'h44};
        conf_mem[123]  <=   {16'h5839, 8'h24};
        conf_mem[124]  <=   {16'h583a, 8'h26};
        conf_mem[125]  <=   {16'h583b, 8'h28};
        conf_mem[126]  <=   {16'h583c, 8'h42};
        conf_mem[127]  <=   {16'h583d, 8'hce};
        conf_mem[128]  <=   {16'h5180, 8'hff};
        conf_mem[129]  <=   {16'h5181, 8'hf2};
        
        conf_mem[130]  <=   {16'h5182, 8'h00};
        conf_mem[131]  <=   {16'h5183, 8'h14};
        conf_mem[132]  <=   {16'h5184, 8'h25};
        conf_mem[133]  <=   {16'h5185, 8'h24};
        conf_mem[134]  <=   {16'h5186, 8'h09};
        conf_mem[135]  <=   {16'h5187, 8'h09};
        conf_mem[136]  <=   {16'h5188, 8'h09};
        conf_mem[137]  <=   {16'h5189, 8'h75};
        conf_mem[138]  <=   {16'h518a, 8'h54};
        conf_mem[139]  <=   {16'h518b, 8'he0};
        
        conf_mem[140]  <=   {16'h518c, 8'hb2};
        conf_mem[141]  <=   {16'h518d, 8'h42};
        conf_mem[142]  <=   {16'h518e, 8'h3d};
        conf_mem[143]  <=   {16'h518f, 8'h56};
        conf_mem[144]  <=   {16'h5190, 8'h46};
        conf_mem[145]  <=   {16'h5191, 8'hf8};
        conf_mem[146]  <=   {16'h5192, 8'h04};
        conf_mem[147]  <=   {16'h5193, 8'h70};
        conf_mem[148]  <=   {16'h5194, 8'hf0};
        conf_mem[149]  <=   {16'h5195, 8'hf0};
        
        conf_mem[150]  <=   {16'h5196, 8'h03};
        conf_mem[151]  <=   {16'h5197, 8'h01};
        conf_mem[152]  <=   {16'h5198, 8'h04};
        conf_mem[153]  <=   {16'h5199, 8'h12};
        conf_mem[154]  <=   {16'h519a, 8'h04};
        conf_mem[155]  <=   {16'h519b, 8'h00};
        conf_mem[156]  <=   {16'h519c, 8'h06};
        conf_mem[157]  <=   {16'h519d, 8'h82};
        conf_mem[158]  <=   {16'h519e, 8'h38};
        conf_mem[159]  <=   {16'h5480, 8'h01};
        
        conf_mem[160]  <=   {16'h5481, 8'h08};
        conf_mem[161]  <=   {16'h5482, 8'h14};
        conf_mem[162]  <=   {16'h5483, 8'h28};
        conf_mem[163]  <=   {16'h5484, 8'h51};
        conf_mem[164]  <=   {16'h5485, 8'h65};
        conf_mem[165]  <=   {16'h5486, 8'h71};
        conf_mem[166]  <=   {16'h5487, 8'h7d};
        conf_mem[167]  <=   {16'h5488, 8'h87};
        conf_mem[168]  <=   {16'h5489, 8'h91};
        conf_mem[169]  <=   {16'h548a, 8'h9a};
        
        conf_mem[170]  <=   {16'h548b, 8'haa};
        conf_mem[171]  <=   {16'h548c, 8'hb8};
        conf_mem[172]  <=   {16'h548d, 8'hcd};
        conf_mem[173]  <=   {16'h548e, 8'hdd};
        conf_mem[174]  <=   {16'h548f, 8'hea};
        conf_mem[175]  <=   {16'h5490, 8'h1d};
        conf_mem[176]  <=   {16'h5381, 8'h1e};
        conf_mem[177]  <=   {16'h5382, 8'h5b};
        conf_mem[178]  <=   {16'h5383, 8'h08};
        conf_mem[179]  <=   {16'h5384, 8'h0a};
        
        conf_mem[180]  <=   {16'h5385, 8'h7e};
        conf_mem[181]  <=   {16'h5386, 8'h88};
        conf_mem[182]  <=   {16'h5387, 8'h7c};
        conf_mem[183]  <=   {16'h5388, 8'h6c};
        conf_mem[184]  <=   {16'h5389, 8'h10};
        conf_mem[185]  <=   {16'h538a, 8'h01};
        conf_mem[186]  <=   {16'h538b, 8'h98};
        conf_mem[187]  <=   {16'h5580, 8'h06};
        conf_mem[188]  <=   {16'h5583, 8'h40};
        conf_mem[189]  <=   {16'h5584, 8'h10};
        
        conf_mem[190]  <=   {16'h5589, 8'h10};
        conf_mem[191]  <=   {16'h558a, 8'h00};
        conf_mem[192]  <=   {16'h558b, 8'hf8};
        conf_mem[193]  <=   {16'h501d, 8'h40};
        conf_mem[194]  <=   {16'h5300, 8'h08};
        conf_mem[195]  <=   {16'h5301, 8'h30};
        conf_mem[196]  <=   {16'h5302, 8'h10};
        conf_mem[197]  <=   {16'h5303, 8'h00};
        conf_mem[198]  <=   {16'h5304, 8'h08};
        conf_mem[199]  <=   {16'h5305, 8'h30};
        
        conf_mem[201]  <=   {16'h5306, 8'h08};
        conf_mem[202]  <=   {16'h5307, 8'h16};
        conf_mem[203]  <=   {16'h5309, 8'h08};
        conf_mem[204]  <=   {16'h530a, 8'h30};
        conf_mem[205]  <=   {16'h530b, 8'h04};
        conf_mem[206]  <=   {16'h530c, 8'h06};
        conf_mem[207]  <=   {16'h5025, 8'h00};
        conf_mem[208]  <=   {16'h3008, 8'h02};
        conf_mem[209]  <=   {16'h3035, 8'h21};
        conf_mem[200]  <=   {16'h3036, 8'h3f};
        
        conf_mem[210]  <=   {16'h3c07, 8'h08};
        conf_mem[211]  <=   {16'h3820, 8'h41};
        conf_mem[212]  <=   {16'h3821, 8'h07};
        conf_mem[213]  <=   {16'h3814, 8'h31};
        conf_mem[214]  <=   {16'h3815, 8'h31};
        conf_mem[215]  <=   {16'h3800, 8'h00};
        conf_mem[216]  <=   {16'h3801, 8'h00};
        conf_mem[217]  <=   {16'h3802, 8'h00};
        conf_mem[218]  <=   {16'h3803, 8'h04};
        conf_mem[219]  <=   {16'h3804, 8'h0a};
        
        conf_mem[220]  <=   {16'h3805, 8'h3f};
        conf_mem[221]  <=   {16'h3806, 8'h07};
        conf_mem[222]  <=   {16'h3807, 8'h9b};
        conf_mem[223]  <=   {16'h3808, 8'h03};
        conf_mem[224]  <=   {16'h3809, 8'h20};
        conf_mem[225]  <=   {16'h380a, 8'h02};
        conf_mem[226]  <=   {16'h380b, 8'h58};
        conf_mem[227]  <=   {16'h380c, 8'h07};
        conf_mem[228]  <=   {16'h380d, 8'h68};
        conf_mem[229]  <=   {16'h380e, 8'h03};
        
        conf_mem[230]  <=   {16'h380f, 8'hd8};
        conf_mem[231]  <=   {16'h3813, 8'h06};
        conf_mem[232]  <=   {16'h3618, 8'h00};
        conf_mem[233]  <=   {16'h3612, 8'h29};
        conf_mem[234]  <=   {16'h3709, 8'h52};
        conf_mem[235]  <=   {16'h370c, 8'h03};
        conf_mem[236]  <=   {16'h3a02, 8'h17};
        conf_mem[237]  <=   {16'h3a03, 8'h10};
        conf_mem[238]  <=   {16'h3a14, 8'h17};
        conf_mem[239]  <=   {16'h3a15, 8'h10};
        
        conf_mem[240]  <=   {16'h4004, 8'h02};
        conf_mem[241]  <=   {16'h3002, 8'h1c};
        conf_mem[242]  <=   {16'h3006, 8'hc3};
        conf_mem[243]  <=   {16'h4713, 8'h03};
        conf_mem[244]  <=   {16'h4407, 8'h04};
        conf_mem[245]  <=   {16'h460b, 8'h35};
        conf_mem[246]  <=   {16'h460c, 8'h22};
        conf_mem[247]  <=   {16'h4837, 8'h22};
        conf_mem[248]  <=   {16'h3824, 8'h02};
        conf_mem[249]  <=   {16'h5001, 8'ha3};
        
        conf_mem[250]  <=   {16'h3503, 8'h00};
        conf_mem[251]  <=   {16'h3035, 8'h21};       // PLL     input clock <=24Mhz, PCLK <=84Mhz
        conf_mem[252]  <=   {16'h3036, 8'h3f};
        conf_mem[253]  <=   {16'h3c07, 8'h07};
        conf_mem[254]  <=   {16'h3820, 8'h47};
        conf_mem[255]  <=   {16'h3821, 8'h07};
        conf_mem[256]  <=   {16'h3814, 8'h31};
        conf_mem[257]  <=   {16'h3815, 8'h31};
        conf_mem[258]  <=   {16'h3800, 8'h01};       // HS
        conf_mem[259]  <=   {16'h3801, 8'h00};       // HS
        
        conf_mem[260]  <=   {16'h3802, 8'h00};       // VS
        conf_mem[261]  <=   {16'h3803, 8'h04};       // VS
        conf_mem[262]  <=   {16'h3804, 8'h0a};       // HW (HE)
        conf_mem[263]  <=   {16'h3805, 8'h2f};       // HW (HE)
        conf_mem[264]  <=   {16'h3806, 8'h07};       // VH (VE)
        conf_mem[265]  <=   {16'h3807, 8'h9b};       // VH (VE)
        conf_mem[266]  <=   {16'h3808, 8'h02};       // DVPHO     640
        conf_mem[267]  <=   {16'h3809, 8'h80};       // DVPHO     
        conf_mem[268]  <=   {16'h380a, 8'h01};       // DVPVO     480
        conf_mem[269]  <=   {16'h380b, 8'he0};       // DVPVO     
        
        conf_mem[270]  <=   {16'h380c, 8'h03};       // HTS       800
        conf_mem[271]  <=   {16'h380d, 8'h20};       // HTS
        conf_mem[272]  <=   {16'h380e, 8'h02};       // VTS       525
        conf_mem[273]  <=   {16'h380f, 8'h0d};       // VTS
        conf_mem[274]  <=   {16'h3810, 8'h00};
        conf_mem[275]  <=   {16'h3811, 8'h08};
        conf_mem[276]  <=   {16'h3812, 8'h00};
        conf_mem[277]  <=   {16'h3813, 8'h06};       // timing V offset
        
        conf_mem[278]  <=   {16'h3618, 8'h00};
        conf_mem[279]  <=   {16'h3612, 8'h29};
        conf_mem[280]  <=   {16'h3709, 8'h52};
        conf_mem[281]  <=   {16'h370c, 8'h03};
        conf_mem[282]  <=   {16'h3a02, 8'h02};
        
        conf_mem[283]  <=   {16'h3a03, 8'he0};
        conf_mem[284]  <=   {16'h3a14, 8'h02};
        conf_mem[285]  <=   {16'h3a15, 8'he0};
        conf_mem[286]  <=   {16'h4004, 8'h02};
        
        conf_mem[287]  <=   {16'h3002, 8'h1c};
        conf_mem[288]  <=   {16'h3006, 8'hc3};
        conf_mem[289]  <=   {16'h4713, 8'h03};
        conf_mem[290]  <=   {16'h4407, 8'h04};
        conf_mem[291]  <=   {16'h460b, 8'h37};
        conf_mem[292]  <=   {16'h460c, 8'h20};
        conf_mem[293]  <=   {16'h4837, 8'h16};
        conf_mem[294]  <=   {16'h3824, 8'h04};       // PCLK manual divider
        conf_mem[295]  <=   {16'h5001, 8'h83};
        conf_mem[296]  <=   {16'h3503, 8'h00};
        
        conf_mem[297]  <=   {16'h3016, 8'h02};
        conf_mem[298]  <=   {16'h3b07, 8'h0a};
        conf_mem[299]  <=   {16'h3b00, 8'h83};
        conf_mem[300]  <=   {16'h3b00, 8'h00};

        state <= send_data;
        init_end <= 0;
        cnt_init = 0;
        OV5640_RESETN <= 1'b0;
        OV5640_PWDN <= 1'b1;
        LED0 <= 1'b0;
        LED1 <= 1'b0;
    end
    else if(!init_end) begin
        cnt_init <= cnt_init + 1;
        if(cnt_init == (DELAY_6MS - 1)) OV5640_PWDN <= 1'b0;
        if(cnt_init == (DELAY_6MS + DELAY_2MS - 1)) OV5640_RESETN <= 1'b1;
        if(cnt_init == (DELAY_6MS + DELAY_2MS + DELAY_20MS - 1)) init_end <= 1'b1;
    end
    else begin
        case(state)
            send_data: begin
                DATA <= conf_mem[cnt_conf][7:0];
                ADDR <= conf_mem[cnt_conf][23:8];
                WR <= 1;
                state <= wait_end;
                LED0 <= 1'b1;
                LED1 <= 1'b0;
            end
            wait_end: begin
                if(SCCB_START == 1'b1) WR <= 1'b0;
                if(WR_END == 1'b1) begin
                    if(cnt_conf != REG_NUM-1) begin
                        cnt_conf <= cnt_conf + 1;
                        state <= wait_end_to_end;
                    end
                    else begin
                        DATA <= 0;
                        ADDR <= 0;
                        WR <= 0;
                        LED0 <= 1'b0;
                        LED1 <= 1'b1;
                        state <= IDLE;
                        END_INIT <= 1'b1;
                    end
                end
                else state <= wait_end;
            end
            wait_end_to_end: begin
                if(WR_END == 1'b0) begin
                    wait_a_minute <= wait_a_minute + 1;
                    if(wait_a_minute != 12'b1111_1111_1111) begin

                        state <= wait_end_to_end;
                    end
                    else state <= send_data;
                end
            end
            IDLE: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule:SCCB_DATA

