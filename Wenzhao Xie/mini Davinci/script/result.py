import sys
import numpy as np

#---------------funtions declaration----------------#
def int2bin46(i):
    return (bin(((1 << 46) - 1) & i)[2:]).zfill(46)

def int2bin18(i):
    return (bin(((1 << 18) - 1) & i)[2:]).zfill(18)

def int2bin16(i):
    return (bin(((1 << 16) - 1) & i)[2:]).zfill(16)

def bin2int16(s):
    return int(s[1:], 2) - int(s[0]) * (1 << 15)

def text_save(content,filename,mode='a'):
    # Try to save a list variable in txt file.
    file = open(filename,mode)
    for i in range(len(content)):
        file.write(str(content[i])+'\n')
    file.close()

def txt_read(filename,length_of_file):
    a = []
    with open(filename,'r') as f:
        for line in f:
            a.append(str(line.strip('\n').split(',')))
    for i in range(len(a)):
        length = len(a[i])
        a[i] = int(a[i][2:length-2])
    return a

def bin2hex16(str_bin):
    if(str_bin[0:4] == '0000'):
        a = '0'
    elif(str_bin[0:4] == '0001'):
        a = '1'
    elif(str_bin[0:4] == '0010'):
        a = '2'
    elif(str_bin[0:4] == '0011'):
        a = '3'
    elif(str_bin[0:4] == '0100'):
        a = '4'
    elif(str_bin[0:4] == '0101'):
        a = '5'
    elif(str_bin[0:4] == '0110'):
        a = '6'
    elif(str_bin[0:4] == '0111'):
        a = '7'
    elif(str_bin[0:4] == '1000'):
        a = '8'
    elif(str_bin[0:4] == '1001'):
        a = '9'
    elif(str_bin[0:4] == '1010'):
        a = 'a'
    elif(str_bin[0:4] == '1011'):
        a = 'b'
    elif(str_bin[0:4] == '1100'):
        a = 'c'
    elif(str_bin[0:4] == '1101'):
        a = 'd'
    elif(str_bin[0:4] == '1110'):
        a = 'e'
    elif(str_bin[0:4] == '1111'):
        a = 'f'

    if(str_bin[4:8] == '0000'):
        b = '0'
    elif(str_bin[4:8] == '0001'):
        b = '1'
    elif(str_bin[4:8] == '0010'):
        b = '2'
    elif(str_bin[4:8] == '0011'):
        b = '3'
    elif(str_bin[4:8] == '0100'):
        b = '4'
    elif(str_bin[4:8] == '0101'):
        b = '5'
    elif(str_bin[4:8] == '0110'):
        b = '6'
    elif(str_bin[4:8] == '0111'):
        b = '7'
    elif(str_bin[4:8] == '1000'):
        b = '8'
    elif(str_bin[4:8] == '1001'):
        b = '9'
    elif(str_bin[4:8] == '1010'):
        b = 'a'
    elif(str_bin[4:8] == '1011'):
        b = 'b'
    elif(str_bin[4:8] == '1100'):
        b = 'c'
    elif(str_bin[4:8] == '1101'):
        b = 'd'
    elif(str_bin[4:8] == '1110'):
        b = 'e'
    elif(str_bin[4:8] == '1111'):
        b = 'f'

    if(str_bin[8:12] == '0000'):
        c = '0'
    elif(str_bin[8:12] == '0001'):
        c = '1'
    elif(str_bin[8:12] == '0010'):
        c = '2'
    elif(str_bin[8:12] == '0011'):
        c = '3'
    elif(str_bin[8:12] == '0100'):
        c = '4'
    elif(str_bin[8:12] == '0101'):
        c = '5'
    elif(str_bin[8:12] == '0110'):
        c = '6'
    elif(str_bin[8:12] == '0111'):
        c = '7'
    elif(str_bin[8:12] == '1000'):
        c = '8'
    elif(str_bin[8:12] == '1001'):
        c = '9'
    elif(str_bin[8:12] == '1010'):
        c = 'a'
    elif(str_bin[8:12] == '1011'):
        c = 'b'
    elif(str_bin[8:12] == '1100'):
        c = 'c'
    elif(str_bin[8:12] == '1101'):
        c = 'd'
    elif(str_bin[8:12] == '1110'):
        c = 'e'
    elif(str_bin[8:12] == '1111'):
        c = 'f'

    if(str_bin[12:16] == '0000'):
        d = '0'
    elif(str_bin[12:16] == '0001'):
        d = '1'
    elif(str_bin[12:16] == '0010'):
        d = '2'
    elif(str_bin[12:16] == '0011'):
        d = '3'
    elif(str_bin[12:16] == '0100'):
        d = '4'
    elif(str_bin[12:16] == '0101'):
        d = '5'
    elif(str_bin[12:16] == '0110'):
        d = '6'
    elif(str_bin[12:16] == '0111'):
        d = '7'
    elif(str_bin[12:16] == '1000'):
        d = '8'
    elif(str_bin[12:16] == '1001'):
        d = '9'
    elif(str_bin[12:16] == '1010'):
        d = 'a'
    elif(str_bin[12:16] == '1011'):
        d = 'b'
    elif(str_bin[12:16] == '1100'):
        d = 'c'
    elif(str_bin[12:16] == '1101'):
        d = 'd'
    elif(str_bin[12:16] == '1110'):
        d = 'e'
    elif(str_bin[12:16] == '1111'):
        d = 'f'
    
    str_hex = a + b + c + d
    return str_hex

def conv(ifm_list,wgt_list,ifm_size,wgt_size,ofm_size,stride):

    result_list  = [None] * (ofm_size*ofm_size)
    result_index = 0
    cnt_v        = 0
    cnt_h        = 0
    while(result_index != (ofm_size*ofm_size)):
        if(wgt_size == 1):
            result_list[result_index] = ifm_list[(cnt_v+0)*ifm_size + cnt_h] * wgt_list[0]
        elif(wgt_size == 3):
            result_list[result_index] = ifm_list[(cnt_v+0)*ifm_size + cnt_h + 0] * wgt_list[0] + \
                                        ifm_list[(cnt_v+0)*ifm_size + cnt_h + 1] * wgt_list[1] + \
                                        ifm_list[(cnt_v+0)*ifm_size + cnt_h + 2] * wgt_list[2] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 0] * wgt_list[3] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 1] * wgt_list[4] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 2] * wgt_list[5] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 0] * wgt_list[6] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 1] * wgt_list[7] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 2] * wgt_list[8]
        elif(wgt_size == 5):
            result_list[result_index] = ifm_list[(cnt_v+0)*ifm_size + cnt_h + 0] * wgt_list[0] + \
                                        ifm_list[(cnt_v+0)*ifm_size + cnt_h + 1] * wgt_list[1] + \
                                        ifm_list[(cnt_v+0)*ifm_size + cnt_h + 2] * wgt_list[2] + \
                                        ifm_list[(cnt_v+0)*ifm_size + cnt_h + 3] * wgt_list[3] + \
                                        ifm_list[(cnt_v+0)*ifm_size + cnt_h + 4] * wgt_list[4] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 0] * wgt_list[5] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 1] * wgt_list[6] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 2] * wgt_list[7] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 3] * wgt_list[8] + \
                                        ifm_list[(cnt_v+1)*ifm_size + cnt_h + 4] * wgt_list[9] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 0] * wgt_list[10] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 1] * wgt_list[11] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 2] * wgt_list[12] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 3] * wgt_list[13] + \
                                        ifm_list[(cnt_v+2)*ifm_size + cnt_h + 4] * wgt_list[14] + \
                                        ifm_list[(cnt_v+3)*ifm_size + cnt_h + 0] * wgt_list[15] + \
                                        ifm_list[(cnt_v+3)*ifm_size + cnt_h + 1] * wgt_list[16] + \
                                        ifm_list[(cnt_v+3)*ifm_size + cnt_h + 2] * wgt_list[17] + \
                                        ifm_list[(cnt_v+3)*ifm_size + cnt_h + 3] * wgt_list[18] + \
                                        ifm_list[(cnt_v+3)*ifm_size + cnt_h + 4] * wgt_list[19] + \
                                        ifm_list[(cnt_v+4)*ifm_size + cnt_h + 0] * wgt_list[20] + \
                                        ifm_list[(cnt_v+4)*ifm_size + cnt_h + 1] * wgt_list[21] + \
                                        ifm_list[(cnt_v+4)*ifm_size + cnt_h + 2] * wgt_list[22] + \
                                        ifm_list[(cnt_v+4)*ifm_size + cnt_h + 3] * wgt_list[23] + \
                                        ifm_list[(cnt_v+4)*ifm_size + cnt_h + 4] * wgt_list[24]
                                        
        if(cnt_h != ifm_size - wgt_size):
            cnt_h += stride
        else:
            if(cnt_v != ifm_size - wgt_size):
                cnt_h = 0
                cnt_v += stride
            else:
                cnt_h = 0
                cnt_v = 0
        result_index += 1
        
    return result_list

def aver_2x2(res_list,in_length,out_length):
    aver_list_int = [None] * (out_length*out_length)
    aver_list_bin = [None] * (out_length*out_length)

    for i in range(out_length):
        for j in range(out_length):
            aver_list_int[i*out_length + j] = res_list[2*i*in_length + 2*j] + res_list[2*i*in_length + 2*j+1] + res_list[(2*i+1)*in_length + 2*j] + res_list[(2*i+1)*in_length + 2*j+1]
            aver_list_bin[i*out_length + j] = int2bin18(aver_list_int[i*out_length + j])
            aver_list_bin[i*out_length + j] = aver_list_bin[i*out_length + j][0:16]
    return aver_list_bin

def max_2x2(res_list,in_length,out_length):
    max_list_int = [None] * (out_length*out_length)
    max_list_bin = [None] * (out_length*out_length)

    for i in range(out_length):
        for j in range(out_length):
            if(res_list[2*i*in_length + 2*j] >= res_list[2*i*in_length + 2*j+1]):
                if(res_list[2*i*in_length + 2*j] >= res_list[(2*i+1)*in_length + 2*j]):
                    if(res_list[2*i*in_length + 2*j] >= res_list[(2*i+1)*in_length + 2*j+1]):
                        max_list_int[i*out_length + j] = res_list[2*i*in_length + 2*j]

            if(res_list[2*i*in_length + 2*j+1] >= res_list[2*i*in_length + 2*j]):
                if(res_list[2*i*in_length + 2*j+1] >= res_list[(2*i+1)*in_length + 2*j]):
                    if(res_list[2*i*in_length + 2*j+1] >= res_list[(2*i+1)*in_length + 2*j+1]):
                        max_list_int[i*out_length + j] = res_list[2*i*in_length + 2*j+1]

            if(res_list[(2*i+1)*in_length + 2*j] >= res_list[2*i*in_length + 2*j]):
                if(res_list[(2*i+1)*in_length + 2*j] >= res_list[2*i*in_length + 2*j+1]):
                    if(res_list[(2*i+1)*in_length + 2*j] >= res_list[(2*i+1)*in_length + 2*j+1]):
                        max_list_int[i*out_length + j] = res_list[(2*i+1)*in_length + 2*j]

            if(res_list[(2*i+1)*in_length + 2*j+1] >= res_list[2*i*in_length + 2*j]):
                if(res_list[(2*i+1)*in_length + 2*j+1] >= res_list[2*i*in_length + 2*j+1]):
                    if(res_list[(2*i+1)*in_length + 2*j+1] >= res_list[(2*i+1)*in_length + 2*j]):
                        max_list_int[i*out_length + j] = res_list[(2*i+1)*in_length + 2*j+1]
            
            max_list_bin[i*out_length + j] = int2bin16(max_list_int[i*out_length + j])
    return max_list_bin    

def zero_pad_bin16(res_list,in_length,pad_size):
    out_length = in_length + 2*pad_size
    out_list = ['0000000000000000'] * (out_length*out_length)

    for i in range(in_length):
        for j in range(in_length):
            out_list[(i+pad_size)*out_length + (j+pad_size)] = res_list[i*in_length + j]
    return out_list
#---------------funtions declaration----------------#
            

############------data read in------############
ifmap_layer_0  = txt_read('./testcase2/ifmap/ifmap_int_layer0.txt',58*58)
ifmap_layer_1  = txt_read('./testcase2/ifmap/ifmap_int_layer1.txt',58*58)
ifmap_layer_2  = txt_read('./testcase2/ifmap/ifmap_int_layer2.txt',58*58)
ifmap_layer_3  = txt_read('./testcase2/ifmap/ifmap_int_layer0.txt',58*58)
ifmap_layer_4  = txt_read('./testcase2/ifmap/ifmap_int_layer1.txt',58*58)
ifmap_layer_5  = txt_read('./testcase2/ifmap/ifmap_int_layer2.txt',58*58)
ifmap_layer_6  = txt_read('./testcase2/ifmap/ifmap_int_layer0.txt',58*58)
ifmap_layer_7  = txt_read('./testcase2/ifmap/ifmap_int_layer1.txt',58*58)
ifmap_layer_8  = txt_read('./testcase2/ifmap/ifmap_int_layer2.txt',58*58)
ifmap_layer_9  = txt_read('./testcase2/ifmap/ifmap_int_layer0.txt',58*58)
ifmap_layer_10 = txt_read('./testcase2/ifmap/ifmap_int_layer1.txt',58*58)
ifmap_layer_11 = txt_read('./testcase2/ifmap/ifmap_int_layer2.txt',58*58)
ifmap_layer_12 = txt_read('./testcase2/ifmap/ifmap_int_layer0.txt',58*58)
ifmap_layer_13 = txt_read('./testcase2/ifmap/ifmap_int_layer1.txt',58*58)
ifmap_layer_14 = txt_read('./testcase2/ifmap/ifmap_int_layer2.txt',58*58)
ifmap_layer_15 = txt_read('./testcase2/ifmap/ifmap_int_layer0.txt',58*58)

wgt_set_0_chn_0   = txt_read('./testcase2/weight/wgt_set_0_chn_0.txt',5*5)
wgt_set_0_chn_1   = txt_read('./testcase2/weight/wgt_set_0_chn_1.txt',5*5)
wgt_set_0_chn_2   = txt_read('./testcase2/weight/wgt_set_0_chn_2.txt',5*5)
wgt_set_0_chn_3   = txt_read('./testcase2/weight/wgt_set_0_chn_3.txt',5*5)
wgt_set_0_chn_4   = txt_read('./testcase2/weight/wgt_set_0_chn_4.txt',5*5)
wgt_set_0_chn_5   = txt_read('./testcase2/weight/wgt_set_0_chn_5.txt',5*5)
wgt_set_0_chn_6   = txt_read('./testcase2/weight/wgt_set_0_chn_6.txt',5*5)
wgt_set_0_chn_7   = txt_read('./testcase2/weight/wgt_set_0_chn_7.txt',5*5)
wgt_set_0_chn_8   = txt_read('./testcase2/weight/wgt_set_0_chn_8.txt',5*5)
wgt_set_0_chn_9   = txt_read('./testcase2/weight/wgt_set_0_chn_9.txt',5*5)
wgt_set_0_chn_10  = txt_read('./testcase2/weight/wgt_set_0_chn_10.txt',5*5)
wgt_set_0_chn_11  = txt_read('./testcase2/weight/wgt_set_0_chn_11.txt',5*5)
wgt_set_0_chn_12  = txt_read('./testcase2/weight/wgt_set_0_chn_12.txt',5*5)
wgt_set_0_chn_13  = txt_read('./testcase2/weight/wgt_set_0_chn_13.txt',5*5)
wgt_set_0_chn_14  = txt_read('./testcase2/weight/wgt_set_0_chn_14.txt',5*5)
wgt_set_0_chn_15  = txt_read('./testcase2/weight/wgt_set_0_chn_15.txt',5*5)

wgt_set_1_chn_0   = txt_read('./testcase2/weight/wgt_set_1_chn_0.txt',5*5)
wgt_set_1_chn_1   = txt_read('./testcase2/weight/wgt_set_1_chn_1.txt',5*5)
wgt_set_1_chn_2   = txt_read('./testcase2/weight/wgt_set_1_chn_2.txt',5*5)
wgt_set_1_chn_3   = txt_read('./testcase2/weight/wgt_set_1_chn_3.txt',5*5)
wgt_set_1_chn_4   = txt_read('./testcase2/weight/wgt_set_1_chn_4.txt',5*5)
wgt_set_1_chn_5   = txt_read('./testcase2/weight/wgt_set_1_chn_5.txt',5*5)
wgt_set_1_chn_6   = txt_read('./testcase2/weight/wgt_set_1_chn_6.txt',5*5)
wgt_set_1_chn_7   = txt_read('./testcase2/weight/wgt_set_1_chn_7.txt',5*5)
wgt_set_1_chn_8   = txt_read('./testcase2/weight/wgt_set_1_chn_8.txt',5*5)
wgt_set_1_chn_9   = txt_read('./testcase2/weight/wgt_set_1_chn_9.txt',5*5)
wgt_set_1_chn_10  = txt_read('./testcase2/weight/wgt_set_1_chn_10.txt',5*5)
wgt_set_1_chn_11  = txt_read('./testcase2/weight/wgt_set_1_chn_11.txt',5*5)
wgt_set_1_chn_12  = txt_read('./testcase2/weight/wgt_set_1_chn_12.txt',5*5)
wgt_set_1_chn_13  = txt_read('./testcase2/weight/wgt_set_1_chn_13.txt',5*5)
wgt_set_1_chn_14  = txt_read('./testcase2/weight/wgt_set_1_chn_14.txt',5*5)
wgt_set_1_chn_15  = txt_read('./testcase2/weight/wgt_set_1_chn_15.txt',5*5)

wgt_set_2_chn_0   = txt_read('./testcase2/weight/wgt_set_2_chn_0.txt',5*5)
wgt_set_2_chn_1   = txt_read('./testcase2/weight/wgt_set_2_chn_1.txt',5*5)
wgt_set_2_chn_2   = txt_read('./testcase2/weight/wgt_set_2_chn_2.txt',5*5)
wgt_set_2_chn_3   = txt_read('./testcase2/weight/wgt_set_2_chn_3.txt',5*5)
wgt_set_2_chn_4   = txt_read('./testcase2/weight/wgt_set_2_chn_4.txt',5*5)
wgt_set_2_chn_5   = txt_read('./testcase2/weight/wgt_set_2_chn_5.txt',5*5)
wgt_set_2_chn_6   = txt_read('./testcase2/weight/wgt_set_2_chn_6.txt',5*5)
wgt_set_2_chn_7   = txt_read('./testcase2/weight/wgt_set_2_chn_7.txt',5*5)
wgt_set_2_chn_8   = txt_read('./testcase2/weight/wgt_set_2_chn_8.txt',5*5)
wgt_set_2_chn_9   = txt_read('./testcase2/weight/wgt_set_2_chn_9.txt',5*5)
wgt_set_2_chn_10  = txt_read('./testcase2/weight/wgt_set_2_chn_10.txt',5*5)
wgt_set_2_chn_11  = txt_read('./testcase2/weight/wgt_set_2_chn_11.txt',5*5)
wgt_set_2_chn_12  = txt_read('./testcase2/weight/wgt_set_2_chn_12.txt',5*5)
wgt_set_2_chn_13  = txt_read('./testcase2/weight/wgt_set_2_chn_13.txt',5*5)
wgt_set_2_chn_14  = txt_read('./testcase2/weight/wgt_set_2_chn_14.txt',5*5)
wgt_set_2_chn_15  = txt_read('./testcase2/weight/wgt_set_2_chn_15.txt',5*5)

wgt_set_3_chn_0   = txt_read('./testcase2/weight/wgt_set_3_chn_0.txt',5*5)
wgt_set_3_chn_1   = txt_read('./testcase2/weight/wgt_set_3_chn_1.txt',5*5)
wgt_set_3_chn_2   = txt_read('./testcase2/weight/wgt_set_3_chn_2.txt',5*5)
wgt_set_3_chn_3   = txt_read('./testcase2/weight/wgt_set_3_chn_3.txt',5*5)
wgt_set_3_chn_4   = txt_read('./testcase2/weight/wgt_set_3_chn_4.txt',5*5)
wgt_set_3_chn_5   = txt_read('./testcase2/weight/wgt_set_3_chn_5.txt',5*5)
wgt_set_3_chn_6   = txt_read('./testcase2/weight/wgt_set_3_chn_6.txt',5*5)
wgt_set_3_chn_7   = txt_read('./testcase2/weight/wgt_set_3_chn_7.txt',5*5)
wgt_set_3_chn_8   = txt_read('./testcase2/weight/wgt_set_3_chn_8.txt',5*5)
wgt_set_3_chn_9   = txt_read('./testcase2/weight/wgt_set_3_chn_9.txt',5*5)
wgt_set_3_chn_10  = txt_read('./testcase2/weight/wgt_set_3_chn_10.txt',5*5)
wgt_set_3_chn_11  = txt_read('./testcase2/weight/wgt_set_3_chn_11.txt',5*5)
wgt_set_3_chn_12  = txt_read('./testcase2/weight/wgt_set_3_chn_12.txt',5*5)
wgt_set_3_chn_13  = txt_read('./testcase2/weight/wgt_set_3_chn_13.txt',5*5)
wgt_set_3_chn_14  = txt_read('./testcase2/weight/wgt_set_3_chn_14.txt',5*5)
wgt_set_3_chn_15  = txt_read('./testcase2/weight/wgt_set_3_chn_15.txt',5*5)

wgt_set_4_chn_0   = txt_read('./testcase2/weight/wgt_set_4_chn_0.txt',5*5)
wgt_set_4_chn_1   = txt_read('./testcase2/weight/wgt_set_4_chn_1.txt',5*5)
wgt_set_4_chn_2   = txt_read('./testcase2/weight/wgt_set_4_chn_2.txt',5*5)
wgt_set_4_chn_3   = txt_read('./testcase2/weight/wgt_set_4_chn_3.txt',5*5)
wgt_set_4_chn_4   = txt_read('./testcase2/weight/wgt_set_4_chn_4.txt',5*5)
wgt_set_4_chn_5   = txt_read('./testcase2/weight/wgt_set_4_chn_5.txt',5*5)
wgt_set_4_chn_6   = txt_read('./testcase2/weight/wgt_set_4_chn_6.txt',5*5)
wgt_set_4_chn_7   = txt_read('./testcase2/weight/wgt_set_4_chn_7.txt',5*5)
wgt_set_4_chn_8   = txt_read('./testcase2/weight/wgt_set_4_chn_8.txt',5*5)
wgt_set_4_chn_9   = txt_read('./testcase2/weight/wgt_set_4_chn_9.txt',5*5)
wgt_set_4_chn_10  = txt_read('./testcase2/weight/wgt_set_4_chn_10.txt',5*5)
wgt_set_4_chn_11  = txt_read('./testcase2/weight/wgt_set_4_chn_11.txt',5*5)
wgt_set_4_chn_12  = txt_read('./testcase2/weight/wgt_set_4_chn_12.txt',5*5)
wgt_set_4_chn_13  = txt_read('./testcase2/weight/wgt_set_4_chn_13.txt',5*5)
wgt_set_4_chn_14  = txt_read('./testcase2/weight/wgt_set_4_chn_14.txt',5*5)
wgt_set_4_chn_15  = txt_read('./testcase2/weight/wgt_set_4_chn_15.txt',5*5)

wgt_set_5_chn_0   = txt_read('./testcase2/weight/wgt_set_5_chn_0.txt',5*5)
wgt_set_5_chn_1   = txt_read('./testcase2/weight/wgt_set_5_chn_1.txt',5*5)
wgt_set_5_chn_2   = txt_read('./testcase2/weight/wgt_set_5_chn_2.txt',5*5)
wgt_set_5_chn_3   = txt_read('./testcase2/weight/wgt_set_5_chn_3.txt',5*5)
wgt_set_5_chn_4   = txt_read('./testcase2/weight/wgt_set_5_chn_4.txt',5*5)
wgt_set_5_chn_5   = txt_read('./testcase2/weight/wgt_set_5_chn_5.txt',5*5)
wgt_set_5_chn_6   = txt_read('./testcase2/weight/wgt_set_5_chn_6.txt',5*5)
wgt_set_5_chn_7   = txt_read('./testcase2/weight/wgt_set_5_chn_7.txt',5*5)
wgt_set_5_chn_8   = txt_read('./testcase2/weight/wgt_set_5_chn_8.txt',5*5)
wgt_set_5_chn_9   = txt_read('./testcase2/weight/wgt_set_5_chn_9.txt',5*5)
wgt_set_5_chn_10  = txt_read('./testcase2/weight/wgt_set_5_chn_10.txt',5*5)
wgt_set_5_chn_11  = txt_read('./testcase2/weight/wgt_set_5_chn_11.txt',5*5)
wgt_set_5_chn_12  = txt_read('./testcase2/weight/wgt_set_5_chn_12.txt',5*5)
wgt_set_5_chn_13  = txt_read('./testcase2/weight/wgt_set_5_chn_13.txt',5*5)
wgt_set_5_chn_14  = txt_read('./testcase2/weight/wgt_set_5_chn_14.txt',5*5)
wgt_set_5_chn_15  = txt_read('./testcase2/weight/wgt_set_5_chn_15.txt',5*5)

wgt_set_6_chn_0   = txt_read('./testcase2/weight/wgt_set_6_chn_0.txt',5*5)
wgt_set_6_chn_1   = txt_read('./testcase2/weight/wgt_set_6_chn_1.txt',5*5)
wgt_set_6_chn_2   = txt_read('./testcase2/weight/wgt_set_6_chn_2.txt',5*5)
wgt_set_6_chn_3   = txt_read('./testcase2/weight/wgt_set_6_chn_3.txt',5*5)
wgt_set_6_chn_4   = txt_read('./testcase2/weight/wgt_set_6_chn_4.txt',5*5)
wgt_set_6_chn_5   = txt_read('./testcase2/weight/wgt_set_6_chn_5.txt',5*5)
wgt_set_6_chn_6   = txt_read('./testcase2/weight/wgt_set_6_chn_6.txt',5*5)
wgt_set_6_chn_7   = txt_read('./testcase2/weight/wgt_set_6_chn_7.txt',5*5)
wgt_set_6_chn_8   = txt_read('./testcase2/weight/wgt_set_6_chn_8.txt',5*5)
wgt_set_6_chn_9   = txt_read('./testcase2/weight/wgt_set_6_chn_9.txt',5*5)
wgt_set_6_chn_10  = txt_read('./testcase2/weight/wgt_set_6_chn_10.txt',5*5)
wgt_set_6_chn_11  = txt_read('./testcase2/weight/wgt_set_6_chn_11.txt',5*5)
wgt_set_6_chn_12  = txt_read('./testcase2/weight/wgt_set_6_chn_12.txt',5*5)
wgt_set_6_chn_13  = txt_read('./testcase2/weight/wgt_set_6_chn_13.txt',5*5)
wgt_set_6_chn_14  = txt_read('./testcase2/weight/wgt_set_6_chn_14.txt',5*5)
wgt_set_6_chn_15  = txt_read('./testcase2/weight/wgt_set_6_chn_15.txt',5*5)

wgt_set_7_chn_0   = txt_read('./testcase2/weight/wgt_set_7_chn_0.txt',5*5)
wgt_set_7_chn_1   = txt_read('./testcase2/weight/wgt_set_7_chn_1.txt',5*5)
wgt_set_7_chn_2   = txt_read('./testcase2/weight/wgt_set_7_chn_2.txt',5*5)
wgt_set_7_chn_3   = txt_read('./testcase2/weight/wgt_set_7_chn_3.txt',5*5)
wgt_set_7_chn_4   = txt_read('./testcase2/weight/wgt_set_7_chn_4.txt',5*5)
wgt_set_7_chn_5   = txt_read('./testcase2/weight/wgt_set_7_chn_5.txt',5*5)
wgt_set_7_chn_6   = txt_read('./testcase2/weight/wgt_set_7_chn_6.txt',5*5)
wgt_set_7_chn_7   = txt_read('./testcase2/weight/wgt_set_7_chn_7.txt',5*5)
wgt_set_7_chn_8   = txt_read('./testcase2/weight/wgt_set_7_chn_8.txt',5*5)
wgt_set_7_chn_9   = txt_read('./testcase2/weight/wgt_set_7_chn_9.txt',5*5)
wgt_set_7_chn_10  = txt_read('./testcase2/weight/wgt_set_7_chn_10.txt',5*5)
wgt_set_7_chn_11  = txt_read('./testcase2/weight/wgt_set_7_chn_11.txt',5*5)
wgt_set_7_chn_12  = txt_read('./testcase2/weight/wgt_set_7_chn_12.txt',5*5)
wgt_set_7_chn_13  = txt_read('./testcase2/weight/wgt_set_7_chn_13.txt',5*5)
wgt_set_7_chn_14  = txt_read('./testcase2/weight/wgt_set_7_chn_14.txt',5*5)
wgt_set_7_chn_15  = txt_read('./testcase2/weight/wgt_set_7_chn_15.txt',5*5)

wgt_set_8_chn_0   = txt_read('./testcase2/weight/wgt_set_8_chn_0.txt',5*5)
wgt_set_8_chn_1   = txt_read('./testcase2/weight/wgt_set_8_chn_1.txt',5*5)
wgt_set_8_chn_2   = txt_read('./testcase2/weight/wgt_set_8_chn_2.txt',5*5)
wgt_set_8_chn_3   = txt_read('./testcase2/weight/wgt_set_8_chn_3.txt',5*5)
wgt_set_8_chn_4   = txt_read('./testcase2/weight/wgt_set_8_chn_4.txt',5*5)
wgt_set_8_chn_5   = txt_read('./testcase2/weight/wgt_set_8_chn_5.txt',5*5)
wgt_set_8_chn_6   = txt_read('./testcase2/weight/wgt_set_8_chn_6.txt',5*5)
wgt_set_8_chn_7   = txt_read('./testcase2/weight/wgt_set_8_chn_7.txt',5*5)
wgt_set_8_chn_8   = txt_read('./testcase2/weight/wgt_set_8_chn_8.txt',5*5)
wgt_set_8_chn_9   = txt_read('./testcase2/weight/wgt_set_8_chn_9.txt',5*5)
wgt_set_8_chn_10  = txt_read('./testcase2/weight/wgt_set_8_chn_10.txt',5*5)
wgt_set_8_chn_11  = txt_read('./testcase2/weight/wgt_set_8_chn_11.txt',5*5)
wgt_set_8_chn_12  = txt_read('./testcase2/weight/wgt_set_8_chn_12.txt',5*5)
wgt_set_8_chn_13  = txt_read('./testcase2/weight/wgt_set_8_chn_13.txt',5*5)
wgt_set_8_chn_14  = txt_read('./testcase2/weight/wgt_set_8_chn_14.txt',5*5)
wgt_set_8_chn_15  = txt_read('./testcase2/weight/wgt_set_8_chn_15.txt',5*5)

wgt_set_9_chn_0   = txt_read('./testcase2/weight/wgt_set_9_chn_0.txt',5*5)
wgt_set_9_chn_1   = txt_read('./testcase2/weight/wgt_set_9_chn_1.txt',5*5)
wgt_set_9_chn_2   = txt_read('./testcase2/weight/wgt_set_9_chn_2.txt',5*5)
wgt_set_9_chn_3   = txt_read('./testcase2/weight/wgt_set_9_chn_3.txt',5*5)
wgt_set_9_chn_4   = txt_read('./testcase2/weight/wgt_set_9_chn_4.txt',5*5)
wgt_set_9_chn_5   = txt_read('./testcase2/weight/wgt_set_9_chn_5.txt',5*5)
wgt_set_9_chn_6   = txt_read('./testcase2/weight/wgt_set_9_chn_6.txt',5*5)
wgt_set_9_chn_7   = txt_read('./testcase2/weight/wgt_set_9_chn_7.txt',5*5)
wgt_set_9_chn_8   = txt_read('./testcase2/weight/wgt_set_9_chn_8.txt',5*5)
wgt_set_9_chn_9   = txt_read('./testcase2/weight/wgt_set_9_chn_9.txt',5*5)
wgt_set_9_chn_10  = txt_read('./testcase2/weight/wgt_set_9_chn_10.txt',5*5)
wgt_set_9_chn_11  = txt_read('./testcase2/weight/wgt_set_9_chn_11.txt',5*5)
wgt_set_9_chn_12  = txt_read('./testcase2/weight/wgt_set_9_chn_12.txt',5*5)
wgt_set_9_chn_13  = txt_read('./testcase2/weight/wgt_set_9_chn_13.txt',5*5)
wgt_set_9_chn_14  = txt_read('./testcase2/weight/wgt_set_9_chn_14.txt',5*5)
wgt_set_9_chn_15  = txt_read('./testcase2/weight/wgt_set_9_chn_15.txt',5*5)

wgt_set_10_chn_0   = txt_read('./testcase2/weight/wgt_set_10_chn_0.txt',5*5)
wgt_set_10_chn_1   = txt_read('./testcase2/weight/wgt_set_10_chn_1.txt',5*5)
wgt_set_10_chn_2   = txt_read('./testcase2/weight/wgt_set_10_chn_2.txt',5*5)
wgt_set_10_chn_3   = txt_read('./testcase2/weight/wgt_set_10_chn_3.txt',5*5)
wgt_set_10_chn_4   = txt_read('./testcase2/weight/wgt_set_10_chn_4.txt',5*5)
wgt_set_10_chn_5   = txt_read('./testcase2/weight/wgt_set_10_chn_5.txt',5*5)
wgt_set_10_chn_6   = txt_read('./testcase2/weight/wgt_set_10_chn_6.txt',5*5)
wgt_set_10_chn_7   = txt_read('./testcase2/weight/wgt_set_10_chn_7.txt',5*5)
wgt_set_10_chn_8   = txt_read('./testcase2/weight/wgt_set_10_chn_8.txt',5*5)
wgt_set_10_chn_9   = txt_read('./testcase2/weight/wgt_set_10_chn_9.txt',5*5)
wgt_set_10_chn_10  = txt_read('./testcase2/weight/wgt_set_10_chn_10.txt',5*5)
wgt_set_10_chn_11  = txt_read('./testcase2/weight/wgt_set_10_chn_11.txt',5*5)
wgt_set_10_chn_12  = txt_read('./testcase2/weight/wgt_set_10_chn_12.txt',5*5)
wgt_set_10_chn_13  = txt_read('./testcase2/weight/wgt_set_10_chn_13.txt',5*5)
wgt_set_10_chn_14  = txt_read('./testcase2/weight/wgt_set_10_chn_14.txt',5*5)
wgt_set_10_chn_15  = txt_read('./testcase2/weight/wgt_set_10_chn_15.txt',5*5)

wgt_set_11_chn_0   = txt_read('./testcase2/weight/wgt_set_11_chn_0.txt',5*5)
wgt_set_11_chn_1   = txt_read('./testcase2/weight/wgt_set_11_chn_1.txt',5*5)
wgt_set_11_chn_2   = txt_read('./testcase2/weight/wgt_set_11_chn_2.txt',5*5)
wgt_set_11_chn_3   = txt_read('./testcase2/weight/wgt_set_11_chn_3.txt',5*5)
wgt_set_11_chn_4   = txt_read('./testcase2/weight/wgt_set_11_chn_4.txt',5*5)
wgt_set_11_chn_5   = txt_read('./testcase2/weight/wgt_set_11_chn_5.txt',5*5)
wgt_set_11_chn_6   = txt_read('./testcase2/weight/wgt_set_11_chn_6.txt',5*5)
wgt_set_11_chn_7   = txt_read('./testcase2/weight/wgt_set_11_chn_7.txt',5*5)
wgt_set_11_chn_8   = txt_read('./testcase2/weight/wgt_set_11_chn_8.txt',5*5)
wgt_set_11_chn_9   = txt_read('./testcase2/weight/wgt_set_11_chn_9.txt',5*5)
wgt_set_11_chn_10  = txt_read('./testcase2/weight/wgt_set_11_chn_10.txt',5*5)
wgt_set_11_chn_11  = txt_read('./testcase2/weight/wgt_set_11_chn_11.txt',5*5)
wgt_set_11_chn_12  = txt_read('./testcase2/weight/wgt_set_11_chn_12.txt',5*5)
wgt_set_11_chn_13  = txt_read('./testcase2/weight/wgt_set_11_chn_13.txt',5*5)
wgt_set_11_chn_14  = txt_read('./testcase2/weight/wgt_set_11_chn_14.txt',5*5)
wgt_set_11_chn_15  = txt_read('./testcase2/weight/wgt_set_11_chn_15.txt',5*5)

wgt_set_12_chn_0   = txt_read('./testcase2/weight/wgt_set_12_chn_0.txt',5*5)
wgt_set_12_chn_1   = txt_read('./testcase2/weight/wgt_set_12_chn_1.txt',5*5)
wgt_set_12_chn_2   = txt_read('./testcase2/weight/wgt_set_12_chn_2.txt',5*5)
wgt_set_12_chn_3   = txt_read('./testcase2/weight/wgt_set_12_chn_3.txt',5*5)
wgt_set_12_chn_4   = txt_read('./testcase2/weight/wgt_set_12_chn_4.txt',5*5)
wgt_set_12_chn_5   = txt_read('./testcase2/weight/wgt_set_12_chn_5.txt',5*5)
wgt_set_12_chn_6   = txt_read('./testcase2/weight/wgt_set_12_chn_6.txt',5*5)
wgt_set_12_chn_7   = txt_read('./testcase2/weight/wgt_set_12_chn_7.txt',5*5)
wgt_set_12_chn_8   = txt_read('./testcase2/weight/wgt_set_12_chn_8.txt',5*5)
wgt_set_12_chn_9   = txt_read('./testcase2/weight/wgt_set_12_chn_9.txt',5*5)
wgt_set_12_chn_10  = txt_read('./testcase2/weight/wgt_set_12_chn_10.txt',5*5)
wgt_set_12_chn_11  = txt_read('./testcase2/weight/wgt_set_12_chn_11.txt',5*5)
wgt_set_12_chn_12  = txt_read('./testcase2/weight/wgt_set_12_chn_12.txt',5*5)
wgt_set_12_chn_13  = txt_read('./testcase2/weight/wgt_set_12_chn_13.txt',5*5)
wgt_set_12_chn_14  = txt_read('./testcase2/weight/wgt_set_12_chn_14.txt',5*5)
wgt_set_12_chn_15  = txt_read('./testcase2/weight/wgt_set_12_chn_15.txt',5*5)

wgt_set_13_chn_0   = txt_read('./testcase2/weight/wgt_set_13_chn_0.txt',5*5)
wgt_set_13_chn_1   = txt_read('./testcase2/weight/wgt_set_13_chn_1.txt',5*5)
wgt_set_13_chn_2   = txt_read('./testcase2/weight/wgt_set_13_chn_2.txt',5*5)
wgt_set_13_chn_3   = txt_read('./testcase2/weight/wgt_set_13_chn_3.txt',5*5)
wgt_set_13_chn_4   = txt_read('./testcase2/weight/wgt_set_13_chn_4.txt',5*5)
wgt_set_13_chn_5   = txt_read('./testcase2/weight/wgt_set_13_chn_5.txt',5*5)
wgt_set_13_chn_6   = txt_read('./testcase2/weight/wgt_set_13_chn_6.txt',5*5)
wgt_set_13_chn_7   = txt_read('./testcase2/weight/wgt_set_13_chn_7.txt',5*5)
wgt_set_13_chn_8   = txt_read('./testcase2/weight/wgt_set_13_chn_8.txt',5*5)
wgt_set_13_chn_9   = txt_read('./testcase2/weight/wgt_set_13_chn_9.txt',5*5)
wgt_set_13_chn_10  = txt_read('./testcase2/weight/wgt_set_13_chn_10.txt',5*5)
wgt_set_13_chn_11  = txt_read('./testcase2/weight/wgt_set_13_chn_11.txt',5*5)
wgt_set_13_chn_12  = txt_read('./testcase2/weight/wgt_set_13_chn_12.txt',5*5)
wgt_set_13_chn_13  = txt_read('./testcase2/weight/wgt_set_13_chn_13.txt',5*5)
wgt_set_13_chn_14  = txt_read('./testcase2/weight/wgt_set_13_chn_14.txt',5*5)
wgt_set_13_chn_15  = txt_read('./testcase2/weight/wgt_set_13_chn_15.txt',5*5)

wgt_set_14_chn_0   = txt_read('./testcase2/weight/wgt_set_14_chn_0.txt',5*5)
wgt_set_14_chn_1   = txt_read('./testcase2/weight/wgt_set_14_chn_1.txt',5*5)
wgt_set_14_chn_2   = txt_read('./testcase2/weight/wgt_set_14_chn_2.txt',5*5)
wgt_set_14_chn_3   = txt_read('./testcase2/weight/wgt_set_14_chn_3.txt',5*5)
wgt_set_14_chn_4   = txt_read('./testcase2/weight/wgt_set_14_chn_4.txt',5*5)
wgt_set_14_chn_5   = txt_read('./testcase2/weight/wgt_set_14_chn_5.txt',5*5)
wgt_set_14_chn_6   = txt_read('./testcase2/weight/wgt_set_14_chn_6.txt',5*5)
wgt_set_14_chn_7   = txt_read('./testcase2/weight/wgt_set_14_chn_7.txt',5*5)
wgt_set_14_chn_8   = txt_read('./testcase2/weight/wgt_set_14_chn_8.txt',5*5)
wgt_set_14_chn_9   = txt_read('./testcase2/weight/wgt_set_14_chn_9.txt',5*5)
wgt_set_14_chn_10  = txt_read('./testcase2/weight/wgt_set_14_chn_10.txt',5*5)
wgt_set_14_chn_11  = txt_read('./testcase2/weight/wgt_set_14_chn_11.txt',5*5)
wgt_set_14_chn_12  = txt_read('./testcase2/weight/wgt_set_14_chn_12.txt',5*5)
wgt_set_14_chn_13  = txt_read('./testcase2/weight/wgt_set_14_chn_13.txt',5*5)
wgt_set_14_chn_14  = txt_read('./testcase2/weight/wgt_set_14_chn_14.txt',5*5)
wgt_set_14_chn_15  = txt_read('./testcase2/weight/wgt_set_14_chn_15.txt',5*5)

wgt_set_15_chn_0   = txt_read('./testcase2/weight/wgt_set_15_chn_0.txt',5*5)
wgt_set_15_chn_1   = txt_read('./testcase2/weight/wgt_set_15_chn_1.txt',5*5)
wgt_set_15_chn_2   = txt_read('./testcase2/weight/wgt_set_15_chn_2.txt',5*5)
wgt_set_15_chn_3   = txt_read('./testcase2/weight/wgt_set_15_chn_3.txt',5*5)
wgt_set_15_chn_4   = txt_read('./testcase2/weight/wgt_set_15_chn_4.txt',5*5)
wgt_set_15_chn_5   = txt_read('./testcase2/weight/wgt_set_15_chn_5.txt',5*5)
wgt_set_15_chn_6   = txt_read('./testcase2/weight/wgt_set_15_chn_6.txt',5*5)
wgt_set_15_chn_7   = txt_read('./testcase2/weight/wgt_set_15_chn_7.txt',5*5)
wgt_set_15_chn_8   = txt_read('./testcase2/weight/wgt_set_15_chn_8.txt',5*5)
wgt_set_15_chn_9   = txt_read('./testcase2/weight/wgt_set_15_chn_9.txt',5*5)
wgt_set_15_chn_10  = txt_read('./testcase2/weight/wgt_set_15_chn_10.txt',5*5)
wgt_set_15_chn_11  = txt_read('./testcase2/weight/wgt_set_15_chn_11.txt',5*5)
wgt_set_15_chn_12  = txt_read('./testcase2/weight/wgt_set_15_chn_12.txt',5*5)
wgt_set_15_chn_13  = txt_read('./testcase2/weight/wgt_set_15_chn_13.txt',5*5)
wgt_set_15_chn_14  = txt_read('./testcase2/weight/wgt_set_15_chn_14.txt',5*5)
wgt_set_15_chn_15  = txt_read('./testcase2/weight/wgt_set_15_chn_15.txt',5*5)

bias = txt_read('./testcase2/bias/bias_int.txt',16)

bias_set_0  = bias[0]
bias_set_1  = bias[1]
bias_set_2  = bias[2]
bias_set_3  = bias[3]
bias_set_4  = bias[4]
bias_set_5  = bias[5]
bias_set_6  = bias[6]
bias_set_7  = bias[7]
bias_set_8  = bias[8]
bias_set_9  = bias[9]
bias_set_10 = bias[10]
bias_set_11 = bias[11]
bias_set_12 = bias[12]
bias_set_13 = bias[13]
bias_set_14 = bias[14]
bias_set_15 = bias[15]
############------data read in------############


############------calculation------############
result_set_0_0  = conv(ifmap_layer_0,wgt_set_0_chn_0,58,5,54,1)
result_set_0_1  = conv(ifmap_layer_1,wgt_set_0_chn_1,58,5,54,1)
result_set_0_2  = conv(ifmap_layer_2,wgt_set_0_chn_2,58,5,54,1)
result_set_0_3  = conv(ifmap_layer_3,wgt_set_0_chn_3,58,5,54,1)
result_set_0_4  = conv(ifmap_layer_4,wgt_set_0_chn_4,58,5,54,1)
result_set_0_5  = conv(ifmap_layer_5,wgt_set_0_chn_5,58,5,54,1)
result_set_0_6  = conv(ifmap_layer_6,wgt_set_0_chn_6,58,5,54,1)
result_set_0_7  = conv(ifmap_layer_7,wgt_set_0_chn_7,58,5,54,1)
result_set_0_8  = conv(ifmap_layer_8,wgt_set_0_chn_8,58,5,54,1)
result_set_0_9  = conv(ifmap_layer_9,wgt_set_0_chn_9,58,5,54,1)
result_set_0_10 = conv(ifmap_layer_10,wgt_set_0_chn_10,58,5,54,1)
result_set_0_11 = conv(ifmap_layer_11,wgt_set_0_chn_11,58,5,54,1)
result_set_0_12 = conv(ifmap_layer_12,wgt_set_0_chn_12,58,5,54,1)
result_set_0_13 = conv(ifmap_layer_13,wgt_set_0_chn_13,58,5,54,1)
result_set_0_14 = conv(ifmap_layer_14,wgt_set_0_chn_14,58,5,54,1)
result_set_0_15 = conv(ifmap_layer_15,wgt_set_0_chn_15,58,5,54,1)

result_full_ofmap_set_0 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_0)):
    result_full_ofmap_set_0[i] = \
    result_set_0_0[i] + result_set_0_1[i] + result_set_0_2[i] + result_set_0_3[i] + result_set_0_4[i] + result_set_0_5[i] + \
    result_set_0_6[i] + result_set_0_7[i] + result_set_0_8[i] + result_set_0_9[i] + result_set_0_10[i] + result_set_0_11[i] + \
    result_set_0_12[i] + result_set_0_13[i] + result_set_0_14[i] + result_set_0_15[i] + bias_set_0

result_set_1_0  = conv(ifmap_layer_0,wgt_set_1_chn_0,58,5,54,1)
result_set_1_1  = conv(ifmap_layer_1,wgt_set_1_chn_1,58,5,54,1)
result_set_1_2  = conv(ifmap_layer_2,wgt_set_1_chn_2,58,5,54,1)
result_set_1_3  = conv(ifmap_layer_3,wgt_set_1_chn_3,58,5,54,1)
result_set_1_4  = conv(ifmap_layer_4,wgt_set_1_chn_4,58,5,54,1)
result_set_1_5  = conv(ifmap_layer_5,wgt_set_1_chn_5,58,5,54,1)
result_set_1_6  = conv(ifmap_layer_6,wgt_set_1_chn_6,58,5,54,1)
result_set_1_7  = conv(ifmap_layer_7,wgt_set_1_chn_7,58,5,54,1)
result_set_1_8  = conv(ifmap_layer_8,wgt_set_1_chn_8,58,5,54,1)
result_set_1_9  = conv(ifmap_layer_9,wgt_set_1_chn_9,58,5,54,1)
result_set_1_10 = conv(ifmap_layer_10,wgt_set_1_chn_10,58,5,54,1)
result_set_1_11 = conv(ifmap_layer_11,wgt_set_1_chn_11,58,5,54,1)
result_set_1_12 = conv(ifmap_layer_12,wgt_set_1_chn_12,58,5,54,1)
result_set_1_13 = conv(ifmap_layer_13,wgt_set_1_chn_13,58,5,54,1)
result_set_1_14 = conv(ifmap_layer_14,wgt_set_1_chn_14,58,5,54,1)
result_set_1_15 = conv(ifmap_layer_15,wgt_set_1_chn_15,58,5,54,1)

result_full_ofmap_set_1 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_1)):
    result_full_ofmap_set_1[i] = \
    result_set_1_0[i] + result_set_1_1[i] + result_set_1_2[i] + result_set_1_3[i] + result_set_1_4[i] + result_set_1_5[i] + \
    result_set_1_6[i] + result_set_1_7[i] + result_set_1_8[i] + result_set_1_9[i] + result_set_1_10[i] + result_set_1_11[i] + \
    result_set_1_12[i] + result_set_1_13[i] + result_set_1_14[i] + result_set_1_15[i] + bias_set_1

result_set_2_0  = conv(ifmap_layer_0,wgt_set_2_chn_0,58,5,54,1)
result_set_2_1  = conv(ifmap_layer_1,wgt_set_2_chn_1,58,5,54,1)
result_set_2_2  = conv(ifmap_layer_2,wgt_set_2_chn_2,58,5,54,1)
result_set_2_3  = conv(ifmap_layer_3,wgt_set_2_chn_3,58,5,54,1)
result_set_2_4  = conv(ifmap_layer_4,wgt_set_2_chn_4,58,5,54,1)
result_set_2_5  = conv(ifmap_layer_5,wgt_set_2_chn_5,58,5,54,1)
result_set_2_6  = conv(ifmap_layer_6,wgt_set_2_chn_6,58,5,54,1)
result_set_2_7  = conv(ifmap_layer_7,wgt_set_2_chn_7,58,5,54,1)
result_set_2_8  = conv(ifmap_layer_8,wgt_set_2_chn_8,58,5,54,1)
result_set_2_9  = conv(ifmap_layer_9,wgt_set_2_chn_9,58,5,54,1)
result_set_2_10 = conv(ifmap_layer_10,wgt_set_2_chn_10,58,5,54,1)
result_set_2_11 = conv(ifmap_layer_11,wgt_set_2_chn_11,58,5,54,1)
result_set_2_12 = conv(ifmap_layer_12,wgt_set_2_chn_12,58,5,54,1)
result_set_2_13 = conv(ifmap_layer_13,wgt_set_2_chn_13,58,5,54,1)
result_set_2_14 = conv(ifmap_layer_14,wgt_set_2_chn_14,58,5,54,1)
result_set_2_15 = conv(ifmap_layer_15,wgt_set_2_chn_15,58,5,54,1)

result_full_ofmap_set_2 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_2)):
    result_full_ofmap_set_2[i] = \
    result_set_2_0[i] + result_set_2_1[i] + result_set_2_2[i] + result_set_2_3[i] + result_set_2_4[i] + result_set_2_5[i] + \
    result_set_2_6[i] + result_set_2_7[i] + result_set_2_8[i] + result_set_2_9[i] + result_set_2_10[i] + result_set_2_11[i] + \
    result_set_2_12[i] + result_set_2_13[i] + result_set_2_14[i] + result_set_2_15[i] + bias_set_2

result_set_3_0  = conv(ifmap_layer_0,wgt_set_3_chn_0,58,5,54,1)
result_set_3_1  = conv(ifmap_layer_1,wgt_set_3_chn_1,58,5,54,1)
result_set_3_2  = conv(ifmap_layer_2,wgt_set_3_chn_2,58,5,54,1)
result_set_3_3  = conv(ifmap_layer_3,wgt_set_3_chn_3,58,5,54,1)
result_set_3_4  = conv(ifmap_layer_4,wgt_set_3_chn_4,58,5,54,1)
result_set_3_5  = conv(ifmap_layer_5,wgt_set_3_chn_5,58,5,54,1)
result_set_3_6  = conv(ifmap_layer_6,wgt_set_3_chn_6,58,5,54,1)
result_set_3_7  = conv(ifmap_layer_7,wgt_set_3_chn_7,58,5,54,1)
result_set_3_8  = conv(ifmap_layer_8,wgt_set_3_chn_8,58,5,54,1)
result_set_3_9  = conv(ifmap_layer_9,wgt_set_3_chn_9,58,5,54,1)
result_set_3_10 = conv(ifmap_layer_10,wgt_set_3_chn_10,58,5,54,1)
result_set_3_11 = conv(ifmap_layer_11,wgt_set_3_chn_11,58,5,54,1)
result_set_3_12 = conv(ifmap_layer_12,wgt_set_3_chn_12,58,5,54,1)
result_set_3_13 = conv(ifmap_layer_13,wgt_set_3_chn_13,58,5,54,1)
result_set_3_14 = conv(ifmap_layer_14,wgt_set_3_chn_14,58,5,54,1)
result_set_3_15 = conv(ifmap_layer_15,wgt_set_3_chn_15,58,5,54,1)

result_full_ofmap_set_3 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_3)):
    result_full_ofmap_set_3[i] = \
    result_set_3_0[i] + result_set_3_1[i] + result_set_3_2[i] + result_set_3_3[i] + result_set_3_4[i] + result_set_3_5[i] + \
    result_set_3_6[i] + result_set_3_7[i] + result_set_3_8[i] + result_set_3_9[i] + result_set_3_10[i] + result_set_3_11[i] + \
    result_set_3_12[i] + result_set_3_13[i] + result_set_3_14[i] + result_set_3_15[i] + bias_set_3

result_set_4_0  = conv(ifmap_layer_0,wgt_set_4_chn_0,58,5,54,1)
result_set_4_1  = conv(ifmap_layer_1,wgt_set_4_chn_1,58,5,54,1)
result_set_4_2  = conv(ifmap_layer_2,wgt_set_4_chn_2,58,5,54,1)
result_set_4_3  = conv(ifmap_layer_3,wgt_set_4_chn_3,58,5,54,1)
result_set_4_4  = conv(ifmap_layer_4,wgt_set_4_chn_4,58,5,54,1)
result_set_4_5  = conv(ifmap_layer_5,wgt_set_4_chn_5,58,5,54,1)
result_set_4_6  = conv(ifmap_layer_6,wgt_set_4_chn_6,58,5,54,1)
result_set_4_7  = conv(ifmap_layer_7,wgt_set_4_chn_7,58,5,54,1)
result_set_4_8  = conv(ifmap_layer_8,wgt_set_4_chn_8,58,5,54,1)
result_set_4_9  = conv(ifmap_layer_9,wgt_set_4_chn_9,58,5,54,1)
result_set_4_10 = conv(ifmap_layer_10,wgt_set_4_chn_10,58,5,54,1)
result_set_4_11 = conv(ifmap_layer_11,wgt_set_4_chn_11,58,5,54,1)
result_set_4_12 = conv(ifmap_layer_12,wgt_set_4_chn_12,58,5,54,1)
result_set_4_13 = conv(ifmap_layer_13,wgt_set_4_chn_13,58,5,54,1)
result_set_4_14 = conv(ifmap_layer_14,wgt_set_4_chn_14,58,5,54,1)
result_set_4_15 = conv(ifmap_layer_15,wgt_set_4_chn_15,58,5,54,1)

result_full_ofmap_set_4 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_4)):
    result_full_ofmap_set_4[i] = \
    result_set_4_0[i] + result_set_4_1[i] + result_set_4_2[i] + result_set_4_3[i] + result_set_4_4[i] + result_set_4_5[i] + \
    result_set_4_6[i] + result_set_4_7[i] + result_set_4_8[i] + result_set_4_9[i] + result_set_4_10[i] + result_set_4_11[i] + \
    result_set_4_12[i] + result_set_4_13[i] + result_set_4_14[i] + result_set_4_15[i] + bias_set_4

result_set_5_0  = conv(ifmap_layer_0,wgt_set_5_chn_0,58,5,54,1)
result_set_5_1  = conv(ifmap_layer_1,wgt_set_5_chn_1,58,5,54,1)
result_set_5_2  = conv(ifmap_layer_2,wgt_set_5_chn_2,58,5,54,1)
result_set_5_3  = conv(ifmap_layer_3,wgt_set_5_chn_3,58,5,54,1)
result_set_5_4  = conv(ifmap_layer_4,wgt_set_5_chn_4,58,5,54,1)
result_set_5_5  = conv(ifmap_layer_5,wgt_set_5_chn_5,58,5,54,1)
result_set_5_6  = conv(ifmap_layer_6,wgt_set_5_chn_6,58,5,54,1)
result_set_5_7  = conv(ifmap_layer_7,wgt_set_5_chn_7,58,5,54,1)
result_set_5_8  = conv(ifmap_layer_8,wgt_set_5_chn_8,58,5,54,1)
result_set_5_9  = conv(ifmap_layer_9,wgt_set_5_chn_9,58,5,54,1)
result_set_5_10 = conv(ifmap_layer_10,wgt_set_5_chn_10,58,5,54,1)
result_set_5_11 = conv(ifmap_layer_11,wgt_set_5_chn_11,58,5,54,1)
result_set_5_12 = conv(ifmap_layer_12,wgt_set_5_chn_12,58,5,54,1)
result_set_5_13 = conv(ifmap_layer_13,wgt_set_5_chn_13,58,5,54,1)
result_set_5_14 = conv(ifmap_layer_14,wgt_set_5_chn_14,58,5,54,1)
result_set_5_15 = conv(ifmap_layer_15,wgt_set_5_chn_15,58,5,54,1)

result_full_ofmap_set_5 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_5)):
    result_full_ofmap_set_5[i] = \
    result_set_5_0[i] + result_set_5_1[i] + result_set_5_2[i] + result_set_5_3[i] + result_set_5_4[i] + result_set_5_5[i] + \
    result_set_5_6[i] + result_set_5_7[i] + result_set_5_8[i] + result_set_5_9[i] + result_set_5_10[i] + result_set_5_11[i] + \
    result_set_5_12[i] + result_set_5_13[i] + result_set_5_14[i] + result_set_5_15[i] + bias_set_5

result_set_6_0  = conv(ifmap_layer_0,wgt_set_6_chn_0,58,5,54,1)
result_set_6_1  = conv(ifmap_layer_1,wgt_set_6_chn_1,58,5,54,1)
result_set_6_2  = conv(ifmap_layer_2,wgt_set_6_chn_2,58,5,54,1)
result_set_6_3  = conv(ifmap_layer_3,wgt_set_6_chn_3,58,5,54,1)
result_set_6_4  = conv(ifmap_layer_4,wgt_set_6_chn_4,58,5,54,1)
result_set_6_5  = conv(ifmap_layer_5,wgt_set_6_chn_5,58,5,54,1)
result_set_6_6  = conv(ifmap_layer_6,wgt_set_6_chn_6,58,5,54,1)
result_set_6_7  = conv(ifmap_layer_7,wgt_set_6_chn_7,58,5,54,1)
result_set_6_8  = conv(ifmap_layer_8,wgt_set_6_chn_8,58,5,54,1)
result_set_6_9  = conv(ifmap_layer_9,wgt_set_6_chn_9,58,5,54,1)
result_set_6_10 = conv(ifmap_layer_10,wgt_set_6_chn_10,58,5,54,1)
result_set_6_11 = conv(ifmap_layer_11,wgt_set_6_chn_11,58,5,54,1)
result_set_6_12 = conv(ifmap_layer_12,wgt_set_6_chn_12,58,5,54,1)
result_set_6_13 = conv(ifmap_layer_13,wgt_set_6_chn_13,58,5,54,1)
result_set_6_14 = conv(ifmap_layer_14,wgt_set_6_chn_14,58,5,54,1)
result_set_6_15 = conv(ifmap_layer_15,wgt_set_6_chn_15,58,5,54,1)

result_full_ofmap_set_6 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_6)):
    result_full_ofmap_set_6[i] = \
    result_set_6_0[i] + result_set_6_1[i] + result_set_6_2[i] + result_set_6_3[i] + result_set_6_4[i] + result_set_6_5[i] + \
    result_set_6_6[i] + result_set_6_7[i] + result_set_6_8[i] + result_set_6_9[i] + result_set_6_10[i] + result_set_6_11[i] + \
    result_set_6_12[i] + result_set_6_13[i] + result_set_6_14[i] + result_set_6_15[i] + bias_set_6

result_set_7_0  = conv(ifmap_layer_0,wgt_set_7_chn_0,58,5,54,1)
result_set_7_1  = conv(ifmap_layer_1,wgt_set_7_chn_1,58,5,54,1)
result_set_7_2  = conv(ifmap_layer_2,wgt_set_7_chn_2,58,5,54,1)
result_set_7_3  = conv(ifmap_layer_3,wgt_set_7_chn_3,58,5,54,1)
result_set_7_4  = conv(ifmap_layer_4,wgt_set_7_chn_4,58,5,54,1)
result_set_7_5  = conv(ifmap_layer_5,wgt_set_7_chn_5,58,5,54,1)
result_set_7_6  = conv(ifmap_layer_6,wgt_set_7_chn_6,58,5,54,1)
result_set_7_7  = conv(ifmap_layer_7,wgt_set_7_chn_7,58,5,54,1)
result_set_7_8  = conv(ifmap_layer_8,wgt_set_7_chn_8,58,5,54,1)
result_set_7_9  = conv(ifmap_layer_9,wgt_set_7_chn_9,58,5,54,1)
result_set_7_10 = conv(ifmap_layer_10,wgt_set_7_chn_10,58,5,54,1)
result_set_7_11 = conv(ifmap_layer_11,wgt_set_7_chn_11,58,5,54,1)
result_set_7_12 = conv(ifmap_layer_12,wgt_set_7_chn_12,58,5,54,1)
result_set_7_13 = conv(ifmap_layer_13,wgt_set_7_chn_13,58,5,54,1)
result_set_7_14 = conv(ifmap_layer_14,wgt_set_7_chn_14,58,5,54,1)
result_set_7_15 = conv(ifmap_layer_15,wgt_set_7_chn_15,58,5,54,1)

result_full_ofmap_set_7 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_7)):
    result_full_ofmap_set_7[i] = \
    result_set_7_0[i] + result_set_7_1[i] + result_set_7_2[i] + result_set_7_3[i] + result_set_7_4[i] + result_set_7_5[i] + \
    result_set_7_6[i] + result_set_7_7[i] + result_set_7_8[i] + result_set_7_9[i] + result_set_7_10[i] + result_set_7_11[i] + \
    result_set_7_12[i] + result_set_7_13[i] + result_set_7_14[i] + result_set_7_15[i] + bias_set_7

result_set_8_0  = conv(ifmap_layer_0,wgt_set_8_chn_0,58,5,54,1)
result_set_8_1  = conv(ifmap_layer_1,wgt_set_8_chn_1,58,5,54,1)
result_set_8_2  = conv(ifmap_layer_2,wgt_set_8_chn_2,58,5,54,1)
result_set_8_3  = conv(ifmap_layer_3,wgt_set_8_chn_3,58,5,54,1)
result_set_8_4  = conv(ifmap_layer_4,wgt_set_8_chn_4,58,5,54,1)
result_set_8_5  = conv(ifmap_layer_5,wgt_set_8_chn_5,58,5,54,1)
result_set_8_6  = conv(ifmap_layer_6,wgt_set_8_chn_6,58,5,54,1)
result_set_8_7  = conv(ifmap_layer_7,wgt_set_8_chn_7,58,5,54,1)
result_set_8_8  = conv(ifmap_layer_8,wgt_set_8_chn_8,58,5,54,1)
result_set_8_9  = conv(ifmap_layer_9,wgt_set_8_chn_9,58,5,54,1)
result_set_8_10 = conv(ifmap_layer_10,wgt_set_8_chn_10,58,5,54,1)
result_set_8_11 = conv(ifmap_layer_11,wgt_set_8_chn_11,58,5,54,1)
result_set_8_12 = conv(ifmap_layer_12,wgt_set_8_chn_12,58,5,54,1)
result_set_8_13 = conv(ifmap_layer_13,wgt_set_8_chn_13,58,5,54,1)
result_set_8_14 = conv(ifmap_layer_14,wgt_set_8_chn_14,58,5,54,1)
result_set_8_15 = conv(ifmap_layer_15,wgt_set_8_chn_15,58,5,54,1)

result_full_ofmap_set_8 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_8)):
    result_full_ofmap_set_8[i] = \
    result_set_8_0[i] + result_set_8_1[i] + result_set_8_2[i] + result_set_8_3[i] + result_set_8_4[i] + result_set_8_5[i] + \
    result_set_8_6[i] + result_set_8_7[i] + result_set_8_8[i] + result_set_8_9[i] + result_set_8_10[i] + result_set_8_11[i] + \
    result_set_8_12[i] + result_set_8_13[i] + result_set_8_14[i] + result_set_8_15[i] + bias_set_8

result_set_9_0  = conv(ifmap_layer_0,wgt_set_9_chn_0,58,5,54,1)
result_set_9_1  = conv(ifmap_layer_1,wgt_set_9_chn_1,58,5,54,1)
result_set_9_2  = conv(ifmap_layer_2,wgt_set_9_chn_2,58,5,54,1)
result_set_9_3  = conv(ifmap_layer_3,wgt_set_9_chn_3,58,5,54,1)
result_set_9_4  = conv(ifmap_layer_4,wgt_set_9_chn_4,58,5,54,1)
result_set_9_5  = conv(ifmap_layer_5,wgt_set_9_chn_5,58,5,54,1)
result_set_9_6  = conv(ifmap_layer_6,wgt_set_9_chn_6,58,5,54,1)
result_set_9_7  = conv(ifmap_layer_7,wgt_set_9_chn_7,58,5,54,1)
result_set_9_8  = conv(ifmap_layer_8,wgt_set_9_chn_8,58,5,54,1)
result_set_9_9  = conv(ifmap_layer_9,wgt_set_9_chn_9,58,5,54,1)
result_set_9_10 = conv(ifmap_layer_10,wgt_set_9_chn_10,58,5,54,1)
result_set_9_11 = conv(ifmap_layer_11,wgt_set_9_chn_11,58,5,54,1)
result_set_9_12 = conv(ifmap_layer_12,wgt_set_9_chn_12,58,5,54,1)
result_set_9_13 = conv(ifmap_layer_13,wgt_set_9_chn_13,58,5,54,1)
result_set_9_14 = conv(ifmap_layer_14,wgt_set_9_chn_14,58,5,54,1)
result_set_9_15 = conv(ifmap_layer_15,wgt_set_9_chn_15,58,5,54,1)

result_full_ofmap_set_9 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_9)):
    result_full_ofmap_set_9[i] = \
    result_set_9_0[i] + result_set_9_1[i] + result_set_9_2[i] + result_set_9_3[i] + result_set_9_4[i] + result_set_9_5[i] + \
    result_set_9_6[i] + result_set_9_7[i] + result_set_9_8[i] + result_set_9_9[i] + result_set_9_10[i] + result_set_9_11[i] + \
    result_set_9_12[i] + result_set_9_13[i] + result_set_9_14[i] + result_set_9_15[i] + bias_set_9

result_set_10_0  = conv(ifmap_layer_0,wgt_set_10_chn_0,58,5,54,1)
result_set_10_1  = conv(ifmap_layer_1,wgt_set_10_chn_1,58,5,54,1)
result_set_10_2  = conv(ifmap_layer_2,wgt_set_10_chn_2,58,5,54,1)
result_set_10_3  = conv(ifmap_layer_3,wgt_set_10_chn_3,58,5,54,1)
result_set_10_4  = conv(ifmap_layer_4,wgt_set_10_chn_4,58,5,54,1)
result_set_10_5  = conv(ifmap_layer_5,wgt_set_10_chn_5,58,5,54,1)
result_set_10_6  = conv(ifmap_layer_6,wgt_set_10_chn_6,58,5,54,1)
result_set_10_7  = conv(ifmap_layer_7,wgt_set_10_chn_7,58,5,54,1)
result_set_10_8  = conv(ifmap_layer_8,wgt_set_10_chn_8,58,5,54,1)
result_set_10_9  = conv(ifmap_layer_9,wgt_set_10_chn_9,58,5,54,1)
result_set_10_10 = conv(ifmap_layer_10,wgt_set_10_chn_10,58,5,54,1)
result_set_10_11 = conv(ifmap_layer_11,wgt_set_10_chn_11,58,5,54,1)
result_set_10_12 = conv(ifmap_layer_12,wgt_set_10_chn_12,58,5,54,1)
result_set_10_13 = conv(ifmap_layer_13,wgt_set_10_chn_13,58,5,54,1)
result_set_10_14 = conv(ifmap_layer_14,wgt_set_10_chn_14,58,5,54,1)
result_set_10_15 = conv(ifmap_layer_15,wgt_set_10_chn_15,58,5,54,1)

result_full_ofmap_set_10 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_10)):
    result_full_ofmap_set_10[i] = \
    result_set_10_0[i] + result_set_10_1[i] + result_set_10_2[i] + result_set_10_3[i] + result_set_10_4[i] + result_set_10_5[i] + \
    result_set_10_6[i] + result_set_10_7[i] + result_set_10_8[i] + result_set_10_9[i] + result_set_10_10[i] + result_set_10_11[i] + \
    result_set_10_12[i] + result_set_10_13[i] + result_set_10_14[i] + result_set_10_15[i] + bias_set_10

result_set_11_0  = conv(ifmap_layer_0,wgt_set_11_chn_0,58,5,54,1)
result_set_11_1  = conv(ifmap_layer_1,wgt_set_11_chn_1,58,5,54,1)
result_set_11_2  = conv(ifmap_layer_2,wgt_set_11_chn_2,58,5,54,1)
result_set_11_3  = conv(ifmap_layer_3,wgt_set_11_chn_3,58,5,54,1)
result_set_11_4  = conv(ifmap_layer_4,wgt_set_11_chn_4,58,5,54,1)
result_set_11_5  = conv(ifmap_layer_5,wgt_set_11_chn_5,58,5,54,1)
result_set_11_6  = conv(ifmap_layer_6,wgt_set_11_chn_6,58,5,54,1)
result_set_11_7  = conv(ifmap_layer_7,wgt_set_11_chn_7,58,5,54,1)
result_set_11_8  = conv(ifmap_layer_8,wgt_set_11_chn_8,58,5,54,1)
result_set_11_9  = conv(ifmap_layer_9,wgt_set_11_chn_9,58,5,54,1)
result_set_11_10 = conv(ifmap_layer_10,wgt_set_11_chn_10,58,5,54,1)
result_set_11_11 = conv(ifmap_layer_11,wgt_set_11_chn_11,58,5,54,1)
result_set_11_12 = conv(ifmap_layer_12,wgt_set_11_chn_12,58,5,54,1)
result_set_11_13 = conv(ifmap_layer_13,wgt_set_11_chn_13,58,5,54,1)
result_set_11_14 = conv(ifmap_layer_14,wgt_set_11_chn_14,58,5,54,1)
result_set_11_15 = conv(ifmap_layer_15,wgt_set_11_chn_15,58,5,54,1)

result_full_ofmap_set_11 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_11)):
    result_full_ofmap_set_11[i] = \
    result_set_11_0[i] + result_set_11_1[i] + result_set_11_2[i] + result_set_11_3[i] + result_set_11_4[i] + result_set_11_5[i] + \
    result_set_11_6[i] + result_set_11_7[i] + result_set_11_8[i] + result_set_11_9[i] + result_set_11_10[i] + result_set_11_11[i] + \
    result_set_11_12[i] + result_set_11_13[i] + result_set_11_14[i] + result_set_11_15[i] + bias_set_11

result_set_12_0  = conv(ifmap_layer_0,wgt_set_12_chn_0,58,5,54,1)
result_set_12_1  = conv(ifmap_layer_1,wgt_set_12_chn_1,58,5,54,1)
result_set_12_2  = conv(ifmap_layer_2,wgt_set_12_chn_2,58,5,54,1)
result_set_12_3  = conv(ifmap_layer_3,wgt_set_12_chn_3,58,5,54,1)
result_set_12_4  = conv(ifmap_layer_4,wgt_set_12_chn_4,58,5,54,1)
result_set_12_5  = conv(ifmap_layer_5,wgt_set_12_chn_5,58,5,54,1)
result_set_12_6  = conv(ifmap_layer_6,wgt_set_12_chn_6,58,5,54,1)
result_set_12_7  = conv(ifmap_layer_7,wgt_set_12_chn_7,58,5,54,1)
result_set_12_8  = conv(ifmap_layer_8,wgt_set_12_chn_8,58,5,54,1)
result_set_12_9  = conv(ifmap_layer_9,wgt_set_12_chn_9,58,5,54,1)
result_set_12_10 = conv(ifmap_layer_10,wgt_set_12_chn_10,58,5,54,1)
result_set_12_11 = conv(ifmap_layer_11,wgt_set_12_chn_11,58,5,54,1)
result_set_12_12 = conv(ifmap_layer_12,wgt_set_12_chn_12,58,5,54,1)
result_set_12_13 = conv(ifmap_layer_13,wgt_set_12_chn_13,58,5,54,1)
result_set_12_14 = conv(ifmap_layer_14,wgt_set_12_chn_14,58,5,54,1)
result_set_12_15 = conv(ifmap_layer_15,wgt_set_12_chn_15,58,5,54,1)

result_full_ofmap_set_12 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_12)):
    result_full_ofmap_set_12[i] = \
    result_set_12_0[i] + result_set_12_1[i] + result_set_12_2[i] + result_set_12_3[i] + result_set_12_4[i] + result_set_12_5[i] + \
    result_set_12_6[i] + result_set_12_7[i] + result_set_12_8[i] + result_set_12_9[i] + result_set_12_10[i] + result_set_12_11[i] + \
    result_set_12_12[i] + result_set_12_13[i] + result_set_12_14[i] + result_set_12_15[i] + bias_set_12

result_set_13_0  = conv(ifmap_layer_0,wgt_set_13_chn_0,58,5,54,1)
result_set_13_1  = conv(ifmap_layer_1,wgt_set_13_chn_1,58,5,54,1)
result_set_13_2  = conv(ifmap_layer_2,wgt_set_13_chn_2,58,5,54,1)
result_set_13_3  = conv(ifmap_layer_3,wgt_set_13_chn_3,58,5,54,1)
result_set_13_4  = conv(ifmap_layer_4,wgt_set_13_chn_4,58,5,54,1)
result_set_13_5  = conv(ifmap_layer_5,wgt_set_13_chn_5,58,5,54,1)
result_set_13_6  = conv(ifmap_layer_6,wgt_set_13_chn_6,58,5,54,1)
result_set_13_7  = conv(ifmap_layer_7,wgt_set_13_chn_7,58,5,54,1)
result_set_13_8  = conv(ifmap_layer_8,wgt_set_13_chn_8,58,5,54,1)
result_set_13_9  = conv(ifmap_layer_9,wgt_set_13_chn_9,58,5,54,1)
result_set_13_10 = conv(ifmap_layer_10,wgt_set_13_chn_10,58,5,54,1)
result_set_13_11 = conv(ifmap_layer_11,wgt_set_13_chn_11,58,5,54,1)
result_set_13_12 = conv(ifmap_layer_12,wgt_set_13_chn_12,58,5,54,1)
result_set_13_13 = conv(ifmap_layer_13,wgt_set_13_chn_13,58,5,54,1)
result_set_13_14 = conv(ifmap_layer_14,wgt_set_13_chn_14,58,5,54,1)
result_set_13_15 = conv(ifmap_layer_15,wgt_set_13_chn_15,58,5,54,1)

result_full_ofmap_set_13 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_13)):
    result_full_ofmap_set_13[i] = \
    result_set_13_0[i] + result_set_13_1[i] + result_set_13_2[i] + result_set_13_3[i] + result_set_13_4[i] + result_set_13_5[i] + \
    result_set_13_6[i] + result_set_13_7[i] + result_set_13_8[i] + result_set_13_9[i] + result_set_13_10[i] + result_set_13_11[i] + \
    result_set_13_12[i] + result_set_13_13[i] + result_set_13_14[i] + result_set_13_15[i] + bias_set_13

result_set_14_0  = conv(ifmap_layer_0,wgt_set_14_chn_0,58,5,54,1)
result_set_14_1  = conv(ifmap_layer_1,wgt_set_14_chn_1,58,5,54,1)
result_set_14_2  = conv(ifmap_layer_2,wgt_set_14_chn_2,58,5,54,1)
result_set_14_3  = conv(ifmap_layer_3,wgt_set_14_chn_3,58,5,54,1)
result_set_14_4  = conv(ifmap_layer_4,wgt_set_14_chn_4,58,5,54,1)
result_set_14_5  = conv(ifmap_layer_5,wgt_set_14_chn_5,58,5,54,1)
result_set_14_6  = conv(ifmap_layer_6,wgt_set_14_chn_6,58,5,54,1)
result_set_14_7  = conv(ifmap_layer_7,wgt_set_14_chn_7,58,5,54,1)
result_set_14_8  = conv(ifmap_layer_8,wgt_set_14_chn_8,58,5,54,1)
result_set_14_9  = conv(ifmap_layer_9,wgt_set_14_chn_9,58,5,54,1)
result_set_14_10 = conv(ifmap_layer_10,wgt_set_14_chn_10,58,5,54,1)
result_set_14_11 = conv(ifmap_layer_11,wgt_set_14_chn_11,58,5,54,1)
result_set_14_12 = conv(ifmap_layer_12,wgt_set_14_chn_12,58,5,54,1)
result_set_14_13 = conv(ifmap_layer_13,wgt_set_14_chn_13,58,5,54,1)
result_set_14_14 = conv(ifmap_layer_14,wgt_set_14_chn_14,58,5,54,1)
result_set_14_15 = conv(ifmap_layer_15,wgt_set_14_chn_15,58,5,54,1)

result_full_ofmap_set_14 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_14)):
    result_full_ofmap_set_14[i] = \
    result_set_14_0[i] + result_set_14_1[i] + result_set_14_2[i] + result_set_14_3[i] + result_set_14_4[i] + result_set_14_5[i] + \
    result_set_14_6[i] + result_set_14_7[i] + result_set_14_8[i] + result_set_14_9[i] + result_set_14_10[i] + result_set_14_11[i] + \
    result_set_14_12[i] + result_set_14_13[i] + result_set_14_14[i] + result_set_14_15[i] + bias_set_14

result_set_15_0  = conv(ifmap_layer_0,wgt_set_15_chn_0,58,5,54,1)
result_set_15_1  = conv(ifmap_layer_1,wgt_set_15_chn_1,58,5,54,1)
result_set_15_2  = conv(ifmap_layer_2,wgt_set_15_chn_2,58,5,54,1)
result_set_15_3  = conv(ifmap_layer_3,wgt_set_15_chn_3,58,5,54,1)
result_set_15_4  = conv(ifmap_layer_4,wgt_set_15_chn_4,58,5,54,1)
result_set_15_5  = conv(ifmap_layer_5,wgt_set_15_chn_5,58,5,54,1)
result_set_15_6  = conv(ifmap_layer_6,wgt_set_15_chn_6,58,5,54,1)
result_set_15_7  = conv(ifmap_layer_7,wgt_set_15_chn_7,58,5,54,1)
result_set_15_8  = conv(ifmap_layer_8,wgt_set_15_chn_8,58,5,54,1)
result_set_15_9  = conv(ifmap_layer_9,wgt_set_15_chn_9,58,5,54,1)
result_set_15_10 = conv(ifmap_layer_10,wgt_set_15_chn_10,58,5,54,1)
result_set_15_11 = conv(ifmap_layer_11,wgt_set_15_chn_11,58,5,54,1)
result_set_15_12 = conv(ifmap_layer_12,wgt_set_15_chn_12,58,5,54,1)
result_set_15_13 = conv(ifmap_layer_13,wgt_set_15_chn_13,58,5,54,1)
result_set_15_14 = conv(ifmap_layer_14,wgt_set_15_chn_14,58,5,54,1)
result_set_15_15 = conv(ifmap_layer_15,wgt_set_15_chn_15,58,5,54,1)

result_full_ofmap_set_15 = [None] * (54*54)
for i in range(len(result_full_ofmap_set_15)):
    result_full_ofmap_set_15[i] = \
    result_set_15_0[i] + result_set_15_1[i] + result_set_15_2[i] + result_set_15_3[i] + result_set_15_4[i] + result_set_15_5[i] + \
    result_set_15_6[i] + result_set_15_7[i] + result_set_15_8[i] + result_set_15_9[i] + result_set_15_10[i] + result_set_15_11[i] + \
    result_set_15_12[i] + result_set_15_13[i] + result_set_15_14[i] + result_set_15_15[i] + bias_set_15


text_save(result_full_ofmap_set_0,'result_full_ofmap_0.txt')
text_save(result_full_ofmap_set_1,'result_full_ofmap_1.txt')
text_save(result_full_ofmap_set_2,'result_full_ofmap_2.txt')
text_save(result_full_ofmap_set_3,'result_full_ofmap_3.txt')
text_save(result_full_ofmap_set_4,'result_full_ofmap_4.txt')
text_save(result_full_ofmap_set_5,'result_full_ofmap_5.txt')
text_save(result_full_ofmap_set_6,'result_full_ofmap_6.txt')
text_save(result_full_ofmap_set_7,'result_full_ofmap_7.txt')

text_save(result_full_ofmap_set_8,'result_full_ofmap_8.txt')
text_save(result_full_ofmap_set_9,'result_full_ofmap_9.txt')
text_save(result_full_ofmap_set_10,'result_full_ofmap_10.txt')
text_save(result_full_ofmap_set_11,'result_full_ofmap_11.txt')
text_save(result_full_ofmap_set_12,'result_full_ofmap_12.txt')
text_save(result_full_ofmap_set_13,'result_full_ofmap_13.txt')
text_save(result_full_ofmap_set_14,'result_full_ofmap_14.txt')
text_save(result_full_ofmap_set_15,'result_full_ofmap_15.txt')


result_full_ofmap_0_bin16  = [None] * (54*54)
result_full_ofmap_1_bin16  = [None] * (54*54)
result_full_ofmap_2_bin16  = [None] * (54*54)
result_full_ofmap_3_bin16  = [None] * (54*54)
result_full_ofmap_4_bin16  = [None] * (54*54)
result_full_ofmap_5_bin16  = [None] * (54*54)
result_full_ofmap_6_bin16  = [None] * (54*54)
result_full_ofmap_7_bin16  = [None] * (54*54)
result_full_ofmap_8_bin16  = [None] * (54*54)
result_full_ofmap_9_bin16  = [None] * (54*54)
result_full_ofmap_10_bin16 = [None] * (54*54)
result_full_ofmap_11_bin16 = [None] * (54*54)
result_full_ofmap_12_bin16 = [None] * (54*54)
result_full_ofmap_13_bin16 = [None] * (54*54)
result_full_ofmap_14_bin16 = [None] * (54*54)
result_full_ofmap_15_bin16 = [None] * (54*54)

result_full_ofmap_0_int16  = [None] * (54*54)
result_full_ofmap_1_int16  = [None] * (54*54)
result_full_ofmap_2_int16  = [None] * (54*54)
result_full_ofmap_3_int16  = [None] * (54*54)
result_full_ofmap_4_int16  = [None] * (54*54)
result_full_ofmap_5_int16  = [None] * (54*54)
result_full_ofmap_6_int16  = [None] * (54*54)
result_full_ofmap_7_int16  = [None] * (54*54)
result_full_ofmap_8_int16  = [None] * (54*54)
result_full_ofmap_9_int16  = [None] * (54*54)
result_full_ofmap_10_int16 = [None] * (54*54)
result_full_ofmap_11_int16 = [None] * (54*54)
result_full_ofmap_12_int16 = [None] * (54*54)
result_full_ofmap_13_int16 = [None] * (54*54)
result_full_ofmap_14_int16 = [None] * (54*54)
result_full_ofmap_15_int16 = [None] * (54*54)

for i in range(len(result_full_ofmap_set_0)):
    result_full_ofmap_0_bin16[i]  = int2bin46(result_full_ofmap_set_0[i])
    result_full_ofmap_1_bin16[i]  = int2bin46(result_full_ofmap_set_1[i])                  
    result_full_ofmap_2_bin16[i]  = int2bin46(result_full_ofmap_set_2[i]) 
    result_full_ofmap_3_bin16[i]  = int2bin46(result_full_ofmap_set_3[i]) 
    result_full_ofmap_4_bin16[i]  = int2bin46(result_full_ofmap_set_4[i]) 
    result_full_ofmap_5_bin16[i]  = int2bin46(result_full_ofmap_set_5[i])
    result_full_ofmap_6_bin16[i]  = int2bin46(result_full_ofmap_set_6[i]) 
    result_full_ofmap_7_bin16[i]  = int2bin46(result_full_ofmap_set_7[i]) 
    result_full_ofmap_8_bin16[i]  = int2bin46(result_full_ofmap_set_8[i]) 
    result_full_ofmap_9_bin16[i]  = int2bin46(result_full_ofmap_set_9[i]) 
    result_full_ofmap_10_bin16[i] = int2bin46(result_full_ofmap_set_10[i]) 
    result_full_ofmap_11_bin16[i] = int2bin46(result_full_ofmap_set_11[i]) 
    result_full_ofmap_12_bin16[i] = int2bin46(result_full_ofmap_set_12[i]) 
    result_full_ofmap_13_bin16[i] = int2bin46(result_full_ofmap_set_13[i]) 
    result_full_ofmap_14_bin16[i] = int2bin46(result_full_ofmap_set_14[i]) 
    result_full_ofmap_15_bin16[i] = int2bin46(result_full_ofmap_set_15[i]) 

    result_full_ofmap_0_bin16[i] = result_full_ofmap_0_bin16[i][0] + result_full_ofmap_0_bin16[i][31:46]
    result_full_ofmap_1_bin16[i] = result_full_ofmap_1_bin16[i][0] + result_full_ofmap_1_bin16[i][31:46]
    result_full_ofmap_2_bin16[i] = result_full_ofmap_2_bin16[i][0] + result_full_ofmap_2_bin16[i][31:46]
    result_full_ofmap_3_bin16[i] = result_full_ofmap_3_bin16[i][0] + result_full_ofmap_3_bin16[i][31:46]
    result_full_ofmap_4_bin16[i] = result_full_ofmap_4_bin16[i][0] + result_full_ofmap_4_bin16[i][31:46]
    result_full_ofmap_5_bin16[i] = result_full_ofmap_5_bin16[i][0] + result_full_ofmap_5_bin16[i][31:46]
    result_full_ofmap_6_bin16[i] = result_full_ofmap_6_bin16[i][0] + result_full_ofmap_6_bin16[i][31:46]
    result_full_ofmap_7_bin16[i] = result_full_ofmap_7_bin16[i][0] + result_full_ofmap_7_bin16[i][31:46]
    result_full_ofmap_8_bin16[i] = result_full_ofmap_8_bin16[i][0] + result_full_ofmap_8_bin16[i][31:46]
    result_full_ofmap_9_bin16[i] = result_full_ofmap_9_bin16[i][0] + result_full_ofmap_9_bin16[i][31:46]
    result_full_ofmap_10_bin16[i] = result_full_ofmap_10_bin16[i][0] + result_full_ofmap_10_bin16[i][31:46]
    result_full_ofmap_11_bin16[i] = result_full_ofmap_11_bin16[i][0] + result_full_ofmap_11_bin16[i][31:46]
    result_full_ofmap_12_bin16[i] = result_full_ofmap_12_bin16[i][0] + result_full_ofmap_12_bin16[i][31:46]
    result_full_ofmap_13_bin16[i] = result_full_ofmap_13_bin16[i][0] + result_full_ofmap_13_bin16[i][31:46]
    result_full_ofmap_14_bin16[i] = result_full_ofmap_14_bin16[i][0] + result_full_ofmap_14_bin16[i][31:46]
    result_full_ofmap_15_bin16[i] = result_full_ofmap_15_bin16[i][0] + result_full_ofmap_15_bin16[i][31:46]

result_pad_bin16_0 = zero_pad_bin16(result_full_ofmap_0_bin16,54,1)
result_pad_bin16_1 = zero_pad_bin16(result_full_ofmap_1_bin16,54,1)
result_pad_bin16_2 = zero_pad_bin16(result_full_ofmap_2_bin16,54,1)
result_pad_bin16_3 = zero_pad_bin16(result_full_ofmap_3_bin16,54,1)
result_pad_bin16_4 = zero_pad_bin16(result_full_ofmap_4_bin16,54,1)
result_pad_bin16_5 = zero_pad_bin16(result_full_ofmap_5_bin16,54,1)
result_pad_bin16_6 = zero_pad_bin16(result_full_ofmap_6_bin16,54,1)
result_pad_bin16_7 = zero_pad_bin16(result_full_ofmap_7_bin16,54,1)
result_pad_bin16_8 = zero_pad_bin16(result_full_ofmap_8_bin16,54,1)
result_pad_bin16_9 = zero_pad_bin16(result_full_ofmap_9_bin16,54,1)
result_pad_bin16_10 = zero_pad_bin16(result_full_ofmap_10_bin16,54,1)
result_pad_bin16_11 = zero_pad_bin16(result_full_ofmap_11_bin16,54,1)
result_pad_bin16_12 = zero_pad_bin16(result_full_ofmap_12_bin16,54,1)
result_pad_bin16_13 = zero_pad_bin16(result_full_ofmap_13_bin16,54,1)
result_pad_bin16_14 = zero_pad_bin16(result_full_ofmap_14_bin16,54,1)
result_pad_bin16_15 = zero_pad_bin16(result_full_ofmap_15_bin16,54,1)

result_pad_hex16_0  = [None] * (56*56)
result_pad_hex16_1  = [None] * (56*56)
result_pad_hex16_2  = [None] * (56*56)
result_pad_hex16_3  = [None] * (56*56)
result_pad_hex16_4  = [None] * (56*56)
result_pad_hex16_5  = [None] * (56*56)
result_pad_hex16_6  = [None] * (56*56)
result_pad_hex16_7  = [None] * (56*56)
result_pad_hex16_8  = [None] * (56*56)
result_pad_hex16_9  = [None] * (56*56)
result_pad_hex16_10 = [None] * (56*56)
result_pad_hex16_11 = [None] * (56*56)
result_pad_hex16_12 = [None] * (56*56)
result_pad_hex16_13 = [None] * (56*56)
result_pad_hex16_14 = [None] * (56*56)
result_pad_hex16_15 = [None] * (56*56)

for i in range(len(result_pad_bin16_0)):
    result_pad_hex16_0[i] = bin2hex16(result_pad_bin16_0[i])
    result_pad_hex16_1[i] = bin2hex16(result_pad_bin16_1[i])
    result_pad_hex16_2[i] = bin2hex16(result_pad_bin16_2[i])
    result_pad_hex16_3[i] = bin2hex16(result_pad_bin16_3[i])
    result_pad_hex16_4[i] = bin2hex16(result_pad_bin16_4[i])
    result_pad_hex16_5[i] = bin2hex16(result_pad_bin16_5[i])
    result_pad_hex16_6[i] = bin2hex16(result_pad_bin16_6[i])
    result_pad_hex16_7[i] = bin2hex16(result_pad_bin16_7[i])
    result_pad_hex16_8[i] = bin2hex16(result_pad_bin16_8[i])
    result_pad_hex16_9[i] = bin2hex16(result_pad_bin16_9[i])
    result_pad_hex16_10[i] = bin2hex16(result_pad_bin16_10[i])
    result_pad_hex16_11[i] = bin2hex16(result_pad_bin16_11[i])
    result_pad_hex16_12[i] = bin2hex16(result_pad_bin16_12[i])
    result_pad_hex16_13[i] = bin2hex16(result_pad_bin16_13[i])
    result_pad_hex16_14[i] = bin2hex16(result_pad_bin16_14[i])
    result_pad_hex16_15[i] = bin2hex16(result_pad_bin16_15[i])

result_128bits_07_hex  = [None] * (56*56)
result_128bits_815_hex = [None] * (56*56)

for i in range(len(result_128bits_07_hex)):
    result_128bits_07_hex[i]  = result_pad_hex16_7[i] + result_pad_hex16_6[i] + result_pad_hex16_5[i] + result_pad_hex16_4[i] + result_pad_hex16_3[i] + result_pad_hex16_2[i] + result_pad_hex16_1[i] + result_pad_hex16_0[i]
    result_128bits_815_hex[i] = result_pad_hex16_15[i] + result_pad_hex16_14[i] + result_pad_hex16_13[i] + result_pad_hex16_12[i] + result_pad_hex16_11[i] + result_pad_hex16_10[i] + result_pad_hex16_9[i] + result_pad_hex16_8[i]

text_save(result_128bits_07_hex,'result_128bits_07_hex.txt')
text_save(result_128bits_815_hex,'result_128bits_815_hex.txt')