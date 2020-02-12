`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BCRC Lab
// Engineer: Xie Wenzhao
// Create Date: 2019/10/16 12:13:44
// Design Name: sDavinci
// Module Name: cmp_cubic
// Project Name: sDavinci
// Target Devices: zc706
// Tool Versions: Vivado 2019.1
// Description:
//
// Additional Comments:
// From matrix input to accmulation result output, 2 cycles.
//////////////////////////////////////////////////////////////////////////////////

module cmp_cubic
#(parameter DATA_WID=16, SIZE=8)
    (
    input clock,
    input rst_n,
    input [DATA_WID*SIZE*SIZE-1:0] weights,
    input [DATA_WID*SIZE*SIZE-1:0] pixels,

    output reg [2239:0] acc_out
);

genvar gv_i,gv_j;

/////////////////////////////////////////////////////////////////////////////////
// 用来方便抓波�?
wire [15:0] wgt_wire_layer0 [SIZE-1:0]; //[layer_index][wgt_index]
wire [15:0] wgt_wire_layer1 [SIZE-1:0];
wire [15:0] wgt_wire_layer2 [SIZE-1:0];
wire [15:0] wgt_wire_layer3 [SIZE-1:0];
wire [15:0] wgt_wire_layer4 [SIZE-1:0];
wire [15:0] wgt_wire_layer5 [SIZE-1:0];
wire [15:0] wgt_wire_layer6 [SIZE-1:0];
wire [15:0] wgt_wire_layer7 [SIZE-1:0];

wire [15:0] ifm_wire_layer0 [SIZE-1:0]; //[layer_index][wgt_index]
wire [15:0] ifm_wire_layer1 [SIZE-1:0];
wire [15:0] ifm_wire_layer2 [SIZE-1:0];
wire [15:0] ifm_wire_layer3 [SIZE-1:0];
wire [15:0] ifm_wire_layer4 [SIZE-1:0];
wire [15:0] ifm_wire_layer5 [SIZE-1:0];
wire [15:0] ifm_wire_layer6 [SIZE-1:0];
wire [15:0] ifm_wire_layer7 [SIZE-1:0];

generate
    for(gv_j=0;gv_j<SIZE;gv_j=gv_j+1)
    begin
        assign ifm_wire_layer0[gv_j] =  pixels[0*16+gv_j*8*16+15:0*16+gv_j*8*16];
        assign ifm_wire_layer1[gv_j] =  pixels[1*16+gv_j*8*16+15:1*16+gv_j*8*16];
        assign ifm_wire_layer2[gv_j] =  pixels[2*16+gv_j*8*16+15:2*16+gv_j*8*16];
        assign ifm_wire_layer3[gv_j] =  pixels[3*16+gv_j*8*16+15:3*16+gv_j*8*16];
        assign ifm_wire_layer4[gv_j] =  pixels[4*16+gv_j*8*16+15:4*16+gv_j*8*16];
        assign ifm_wire_layer5[gv_j] =  pixels[5*16+gv_j*8*16+15:5*16+gv_j*8*16];
        assign ifm_wire_layer6[gv_j] =  pixels[6*16+gv_j*8*16+15:6*16+gv_j*8*16];
        assign ifm_wire_layer7[gv_j] =  pixels[7*16+gv_j*8*16+15:7*16+gv_j*8*16];

        assign wgt_wire_layer0[gv_j] = weights[0*16+gv_j*8*16+15:0*16+gv_j*8*16];
        assign wgt_wire_layer1[gv_j] = weights[1*16+gv_j*8*16+15:1*16+gv_j*8*16];
        assign wgt_wire_layer2[gv_j] = weights[2*16+gv_j*8*16+15:2*16+gv_j*8*16];
        assign wgt_wire_layer3[gv_j] = weights[3*16+gv_j*8*16+15:3*16+gv_j*8*16];
        assign wgt_wire_layer4[gv_j] = weights[4*16+gv_j*8*16+15:4*16+gv_j*8*16];
        assign wgt_wire_layer5[gv_j] = weights[5*16+gv_j*8*16+15:5*16+gv_j*8*16];
        assign wgt_wire_layer6[gv_j] = weights[6*16+gv_j*8*16+15:6*16+gv_j*8*16];
        assign wgt_wire_layer7[gv_j] = weights[7*16+gv_j*8*16+15:7*16+gv_j*8*16];
    end
endgenerate
///////////////////////////////////////////////////////////////////////////////

wire signed [34:0] acc_wire [SIZE-1:0][SIZE-1:0];

wire [32*SIZE*SIZE-1:0] psums_wire0;
cmp_layer cmp_layer_inst0(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer0[7],wgt_wire_layer0[6],wgt_wire_layer0[5],wgt_wire_layer0[4],
              wgt_wire_layer0[3],wgt_wire_layer0[2],wgt_wire_layer0[1],wgt_wire_layer0[0]}),
    .pixels ({ifm_wire_layer0[7],ifm_wire_layer0[6],ifm_wire_layer0[5],ifm_wire_layer0[4],
              ifm_wire_layer0[3],ifm_wire_layer0[2],ifm_wire_layer0[1],ifm_wire_layer0[0]}),
    .psums_out(psums_wire0)
);

wire [32*SIZE*SIZE-1:0] psums_wire1;
cmp_layer cmp_layer_inst1(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer1[7],wgt_wire_layer1[6],wgt_wire_layer1[5],wgt_wire_layer1[4],
              wgt_wire_layer1[3],wgt_wire_layer1[2],wgt_wire_layer1[1],wgt_wire_layer1[0]}),
    .pixels ({ifm_wire_layer1[7],ifm_wire_layer1[6],ifm_wire_layer1[5],ifm_wire_layer1[4],
              ifm_wire_layer1[3],ifm_wire_layer1[2],ifm_wire_layer1[1],ifm_wire_layer1[0]}),
    .psums_out(psums_wire1)
);

wire [32*SIZE*SIZE-1:0] psums_wire2;
cmp_layer cmp_layer_inst2(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer2[7],wgt_wire_layer2[6],wgt_wire_layer2[5],wgt_wire_layer2[4],
              wgt_wire_layer2[3],wgt_wire_layer2[2],wgt_wire_layer2[1],wgt_wire_layer2[0]}),
    .pixels ({ifm_wire_layer2[7],ifm_wire_layer2[6],ifm_wire_layer2[5],ifm_wire_layer2[4],
              ifm_wire_layer2[3],ifm_wire_layer2[2],ifm_wire_layer2[1],ifm_wire_layer2[0]}),
    .psums_out(psums_wire2)
);

wire [32*SIZE*SIZE-1:0] psums_wire3;
cmp_layer cmp_layer_inst3(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer3[7],wgt_wire_layer3[6],wgt_wire_layer3[5],wgt_wire_layer3[4],
              wgt_wire_layer3[3],wgt_wire_layer3[2],wgt_wire_layer3[1],wgt_wire_layer3[0]}),
    .pixels ({ifm_wire_layer3[7],ifm_wire_layer3[6],ifm_wire_layer3[5],ifm_wire_layer3[4],
              ifm_wire_layer3[3],ifm_wire_layer3[2],ifm_wire_layer3[1],ifm_wire_layer3[0]}),
    .psums_out(psums_wire3)
);

wire [32*SIZE*SIZE-1:0] psums_wire4;
cmp_layer cmp_layer_inst4(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer4[7],wgt_wire_layer4[6],wgt_wire_layer4[5],wgt_wire_layer4[4],
              wgt_wire_layer4[3],wgt_wire_layer4[2],wgt_wire_layer4[1],wgt_wire_layer4[0]}),
    .pixels ({ifm_wire_layer4[7],ifm_wire_layer4[6],ifm_wire_layer4[5],ifm_wire_layer4[4],
              ifm_wire_layer4[3],ifm_wire_layer4[2],ifm_wire_layer4[1],ifm_wire_layer4[0]}),
    .psums_out(psums_wire4)
);

wire [32*SIZE*SIZE-1:0] psums_wire5;
cmp_layer cmp_layer_inst5(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer5[7],wgt_wire_layer5[6],wgt_wire_layer5[5],wgt_wire_layer5[4],
              wgt_wire_layer5[3],wgt_wire_layer5[2],wgt_wire_layer5[1],wgt_wire_layer5[0]}),
    .pixels ({ifm_wire_layer5[7],ifm_wire_layer5[6],ifm_wire_layer5[5],ifm_wire_layer5[4],
              ifm_wire_layer5[3],ifm_wire_layer5[2],ifm_wire_layer5[1],ifm_wire_layer5[0]}),
    .psums_out(psums_wire5)
);

wire [32*SIZE*SIZE-1:0] psums_wire6;
cmp_layer cmp_layer_inst6(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer6[7],wgt_wire_layer6[6],wgt_wire_layer6[5],wgt_wire_layer6[4],
              wgt_wire_layer6[3],wgt_wire_layer6[2],wgt_wire_layer6[1],wgt_wire_layer6[0]}),
    .pixels ({ifm_wire_layer6[7],ifm_wire_layer6[6],ifm_wire_layer6[5],ifm_wire_layer6[4],
              ifm_wire_layer6[3],ifm_wire_layer6[2],ifm_wire_layer6[1],ifm_wire_layer6[0]}),
    .psums_out(psums_wire6)
);

wire [32*SIZE*SIZE-1:0] psums_wire7;
cmp_layer cmp_layer_inst7(
    .clock(clock),
    .rst_n(rst_n),
    .weights({wgt_wire_layer7[7],wgt_wire_layer7[6],wgt_wire_layer7[5],wgt_wire_layer7[4],
              wgt_wire_layer7[3],wgt_wire_layer7[2],wgt_wire_layer7[1],wgt_wire_layer7[0]}),
    .pixels ({ifm_wire_layer7[7],ifm_wire_layer7[6],ifm_wire_layer7[5],ifm_wire_layer7[4],
              ifm_wire_layer7[3],ifm_wire_layer7[2],ifm_wire_layer7[1],ifm_wire_layer7[0]}),
    .psums_out(psums_wire7)
);

wire signed [32:0] add_tree_0 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_1 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_2 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_3 [SIZE-1:0][SIZE-1:0];
wire signed [33:0] add_tree_4 [SIZE-1:0][SIZE-1:0];
wire signed [33:0] add_tree_5 [SIZE-1:0][SIZE-1:0];

wire signed [31:0] psum_0 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_1 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_2 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_3 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_4 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_5 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_6 [SIZE-1:0][SIZE-1:0];
wire signed [31:0] psum_7 [SIZE-1:0][SIZE-1:0];

wire signed [32:0] add_tree_0_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_0_wire_1 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_1_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_1_wire_1 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_2_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_2_wire_1 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_3_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [32:0] add_tree_3_wire_1 [SIZE-1:0][SIZE-1:0];

wire signed [33:0] add_tree_4_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [33:0] add_tree_4_wire_1 [SIZE-1:0][SIZE-1:0];
wire signed [33:0] add_tree_5_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [33:0] add_tree_5_wire_1 [SIZE-1:0][SIZE-1:0];

wire signed [34:0] acc_wire_0 [SIZE-1:0][SIZE-1:0];
wire signed [34:0] acc_wire_1 [SIZE-1:0][SIZE-1:0];

generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        for(gv_j=0;gv_j<SIZE;gv_j=gv_j+1)
        begin
            assign psum_0[gv_i][gv_j] = psums_wire0[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_1[gv_i][gv_j] = psums_wire1[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_2[gv_i][gv_j] = psums_wire2[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_3[gv_i][gv_j] = psums_wire3[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_4[gv_i][gv_j] = psums_wire4[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_5[gv_i][gv_j] = psums_wire5[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_6[gv_i][gv_j] = psums_wire6[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];
            assign psum_7[gv_i][gv_j] = psums_wire7[gv_j*8*32+gv_i*32+31:gv_j*8*32+gv_i*32];

            assign add_tree_0_wire_0[gv_i][gv_j] = psum_0[gv_i][gv_j];
            assign add_tree_0_wire_1[gv_i][gv_j] = psum_1[gv_i][gv_j];
            assign add_tree_1_wire_0[gv_i][gv_j] = psum_2[gv_i][gv_j];
            assign add_tree_1_wire_1[gv_i][gv_j] = psum_3[gv_i][gv_j];
            assign add_tree_2_wire_0[gv_i][gv_j] = psum_4[gv_i][gv_j];
            assign add_tree_2_wire_1[gv_i][gv_j] = psum_5[gv_i][gv_j];
            assign add_tree_3_wire_0[gv_i][gv_j] = psum_6[gv_i][gv_j];
            assign add_tree_3_wire_1[gv_i][gv_j] = psum_7[gv_i][gv_j];

            assign add_tree_0[gv_i][gv_j] = add_tree_0_wire_0[gv_i][gv_j] + add_tree_0_wire_1[gv_i][gv_j];
            assign add_tree_1[gv_i][gv_j] = add_tree_1_wire_0[gv_i][gv_j] + add_tree_1_wire_1[gv_i][gv_j];
            assign add_tree_2[gv_i][gv_j] = add_tree_2_wire_0[gv_i][gv_j] + add_tree_2_wire_1[gv_i][gv_j];
            assign add_tree_3[gv_i][gv_j] = add_tree_3_wire_0[gv_i][gv_j] + add_tree_3_wire_1[gv_i][gv_j];

            assign add_tree_4_wire_0[gv_i][gv_j] = add_tree_0[gv_i][gv_j];
            assign add_tree_4_wire_1[gv_i][gv_j] = add_tree_1[gv_i][gv_j];
            assign add_tree_5_wire_0[gv_i][gv_j] = add_tree_2[gv_i][gv_j];
            assign add_tree_5_wire_1[gv_i][gv_j] = add_tree_3[gv_i][gv_j];

            assign add_tree_4[gv_i][gv_j] = add_tree_4_wire_0[gv_i][gv_j] + add_tree_4_wire_1[gv_i][gv_j];
            assign add_tree_5[gv_i][gv_j] = add_tree_5_wire_0[gv_i][gv_j] + add_tree_5_wire_1[gv_i][gv_j];

            assign acc_wire_0[gv_i][gv_j] = add_tree_4[gv_i][gv_j];
            assign acc_wire_1[gv_i][gv_j] = add_tree_5[gv_i][gv_j];

            assign acc_wire[gv_i][gv_j] = acc_wire_0[gv_i][gv_j] + acc_wire_1[gv_i][gv_j];
        end
    end
endgenerate

generate
    for(gv_i=0;gv_i<SIZE;gv_i=gv_i+1)
    begin
        for(gv_j=0;gv_j<SIZE;gv_j=gv_j+1)
        begin
            always@(posedge clock)
                acc_out[gv_i*8*35+gv_j*35+34:gv_i*8*35+gv_j*35] <= acc_wire[gv_i][gv_j];
                //acc_out[gv_i*35+gv_j*8*35+34:gv_i*35+gv_j*8*35] <= acc_wire[gv_i][gv_j];
        end
    end
endgenerate

endmodule