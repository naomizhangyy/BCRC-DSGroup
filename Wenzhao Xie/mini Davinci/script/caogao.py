result_set_15_0  = conv(ifmap_layer_0,wgt_set_15_chn_0,224,3,222,1)
result_set_15_1  = conv(ifmap_layer_1,wgt_set_15_chn_1,224,3,222,1)
result_set_15_2  = conv(ifmap_layer_2,wgt_set_15_chn_2,224,3,222,1)
result_set_15_3  = conv(ifmap_layer_3,wgt_set_15_chn_3,224,3,222,1)
result_set_15_4  = conv(ifmap_layer_4,wgt_set_15_chn_4,224,3,222,1)
result_set_15_5  = conv(ifmap_layer_5,wgt_set_15_chn_5,224,3,222,1)
result_set_15_6  = conv(ifmap_layer_6,wgt_set_15_chn_6,224,3,222,1)
result_set_15_7  = conv(ifmap_layer_7,wgt_set_15_chn_7,224,3,222,1)

result_full_ofmap_set_15 = [None] * (222*222)
for i in range(len(result_full_ofmap_set_15)):
    result_full_ofmap_set_15[i] = \
    result_set_15_0[i] + result_set_15_1[i] + result_set_15_2[i] + result_set_15_3[i] + result_set_15_4[i] + result_set_15_5[i] + \
    result_set_15_6[i] + result_set_15_7[i] + bias_set_15

