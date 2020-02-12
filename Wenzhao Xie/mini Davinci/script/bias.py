import numpy as np

def int2bin16(i):
    return (bin(((1 << 16) - 1) & i)[2:]).zfill(16)

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

def text_save(content,filename,mode='a'):
    # Try to save a list variable in txt file.
    file = open(filename,mode)
    for i in range(len(content)):
        file.write(str(content[i])+'\n')
    file.close()

bias_ofmap_0 = np.random.randint(-32768,32767,1)
bias_ofmap_1 = np.random.randint(-32768,32767,1)
bias_ofmap_2 = np.random.randint(-32768,32767,1)
bias_ofmap_3 = np.random.randint(-32768,32767,1)
bias_ofmap_4 = np.random.randint(-32768,32767,1)
bias_ofmap_5 = np.random.randint(-32768,32767,1)
bias_ofmap_6 = np.random.randint(-32768,32767,1)
bias_ofmap_7 = np.random.randint(-32768,32767,1)

bias_ofmap_8  = np.random.randint(-32768,32767,1)
bias_ofmap_9  = np.random.randint(-32768,32767,1)
bias_ofmap_10 = np.random.randint(-32768,32767,1)
bias_ofmap_11 = np.random.randint(-32768,32767,1)
bias_ofmap_12 = np.random.randint(-32768,32767,1)
bias_ofmap_13 = np.random.randint(-32768,32767,1)
bias_ofmap_14 = np.random.randint(-32768,32767,1)
bias_ofmap_15 = np.random.randint(-32768,32767,1)

bias_ofmap_0_hex = bin2hex16(str(int2bin16(bias_ofmap_0[0])))
bias_ofmap_1_hex = bin2hex16(str(int2bin16(bias_ofmap_1[0])))
bias_ofmap_2_hex = bin2hex16(str(int2bin16(bias_ofmap_2[0])))
bias_ofmap_3_hex = bin2hex16(str(int2bin16(bias_ofmap_3[0])))
bias_ofmap_4_hex = bin2hex16(str(int2bin16(bias_ofmap_4[0])))
bias_ofmap_5_hex = bin2hex16(str(int2bin16(bias_ofmap_5[0])))
bias_ofmap_6_hex = bin2hex16(str(int2bin16(bias_ofmap_6[0])))
bias_ofmap_7_hex = bin2hex16(str(int2bin16(bias_ofmap_7[0])))

bias_ofmap_8_hex  = bin2hex16(str(int2bin16(bias_ofmap_8[0])))
bias_ofmap_9_hex  = bin2hex16(str(int2bin16(bias_ofmap_9[0])))
bias_ofmap_10_hex = bin2hex16(str(int2bin16(bias_ofmap_10[0])))
bias_ofmap_11_hex = bin2hex16(str(int2bin16(bias_ofmap_11[0])))
bias_ofmap_12_hex = bin2hex16(str(int2bin16(bias_ofmap_12[0])))
bias_ofmap_13_hex = bin2hex16(str(int2bin16(bias_ofmap_13[0])))
bias_ofmap_14_hex = bin2hex16(str(int2bin16(bias_ofmap_14[0])))
bias_ofmap_15_hex = bin2hex16(str(int2bin16(bias_ofmap_15[0])))

list0 = [bias_ofmap_0[0], bias_ofmap_1[0], bias_ofmap_2[0], bias_ofmap_3[0], bias_ofmap_4[0], bias_ofmap_5[0], bias_ofmap_6[0], bias_ofmap_7[0]]
list1 = [bias_ofmap_8[0], bias_ofmap_9[0], bias_ofmap_10[0], bias_ofmap_11[0], bias_ofmap_12[0], bias_ofmap_13[0], bias_ofmap_14[0], bias_ofmap_15[0]]

bias_list_int = list0 + list1

list0 = [bias_ofmap_0_hex, bias_ofmap_1_hex, bias_ofmap_2_hex, bias_ofmap_3_hex, bias_ofmap_4_hex, bias_ofmap_5_hex, bias_ofmap_6_hex, bias_ofmap_7_hex]
list1 = [bias_ofmap_8_hex, bias_ofmap_9_hex, bias_ofmap_10_hex, bias_ofmap_11_hex, bias_ofmap_12_hex, bias_ofmap_13_hex, bias_ofmap_14_hex, bias_ofmap_15_hex]

bias_list_hex = list0 + list1

text_save(bias_list_int,"bias_int.txt")
text_save(bias_list_hex,'bias_hex.txt')