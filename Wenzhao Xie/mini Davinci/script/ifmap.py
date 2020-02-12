import numpy as np

def int2bin16(i):
    return (bin(((1 << 16) - 1) & i)[2:]).zfill(16)

def bin2int16(s):
    return int(s[1:], 2) - int(s[0]) * (1 << 16)

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

ifm_chn_0 = np.random.randint(-32768,32767,58*58)
my_list_0  = [None] * 3364

ifm_chn_1 = np.random.randint(-32768,32767,58*58)
my_list_1  = [None] * 3364

ifm_chn_2 = np.random.randint(-32768,32767,58*58)
my_list_2  = [None] * 3364

ifm_chn_3 = np.random.randint(-32768,32767,58*58)
my_list_3  = [None] * 3364

ifm_chn_4 = np.random.randint(-32768,32767,58*58)
my_list_4  = [None] * 3364

ifm_chn_5 = np.random.randint(-32768,32767,58*58)
my_list_5  = [None] * 3364

ifm_chn_6 = np.random.randint(-32768,32767,58*58)
my_list_6  = [None] * 3364

ifm_chn_7 = np.random.randint(-32768,32767,58*58)
my_list_7  = [None] * 3364

ifm_chn_8 = np.random.randint(-32768,32767,58*58)
my_list_8  = [None] * 3364

ifm_chn_9 = np.random.randint(-32768,32767,58*58)
my_list_9  = [None] * 3364

ifm_chn_10 = np.random.randint(-32768,32767,58*58)
my_list_10 = [None] * 3364

ifm_chn_11 = np.random.randint(-32768,32767,58*58)
my_list_11 = [None] * 3364

ifm_chn_12 = np.random.randint(-32768,32767,58*58)
my_list_12 = [None] * 3364

ifm_chn_13 = np.random.randint(-32768,32767,58*58)
my_list_13 = [None] * 3364

ifm_chn_14 = np.random.randint(-32768,32767,58*58)
my_list_14 = [None] * 3364

ifm_chn_15 = np.random.randint(-32768,32767,58*58)
my_list_15 = [None] * 3364

ifm_chn_07   = [None] * 3364
ifm_chn_815  = [None] * 3364

for i in range(len(my_list_0)):
    my_list_0[i]  = bin2hex16(str(int2bin16(ifm_chn_0[i])))
    my_list_1[i]  = bin2hex16(str(int2bin16(ifm_chn_1[i])))
    my_list_2[i]  = bin2hex16(str(int2bin16(ifm_chn_2[i])))
    my_list_3[i]  = bin2hex16(str(int2bin16(ifm_chn_3[i])))
    my_list_4[i]  = bin2hex16(str(int2bin16(ifm_chn_4[i])))
    my_list_5[i]  = bin2hex16(str(int2bin16(ifm_chn_5[i])))
    my_list_6[i]  = bin2hex16(str(int2bin16(ifm_chn_6[i])))
    my_list_7[i]  = bin2hex16(str(int2bin16(ifm_chn_7[i])))
    my_list_8[i]  = bin2hex16(str(int2bin16(ifm_chn_8[i])))
    my_list_9[i]  = bin2hex16(str(int2bin16(ifm_chn_9[i])))
    my_list_10[i] = bin2hex16(str(int2bin16(ifm_chn_10[i])))
    my_list_11[i] = bin2hex16(str(int2bin16(ifm_chn_11[i])))
    my_list_12[i] = bin2hex16(str(int2bin16(ifm_chn_12[i])))
    my_list_13[i] = bin2hex16(str(int2bin16(ifm_chn_13[i])))
    my_list_14[i] = bin2hex16(str(int2bin16(ifm_chn_14[i])))
    my_list_15[i] = bin2hex16(str(int2bin16(ifm_chn_15[i])))
    
for i in range(len(ifm_chn_07)):
    ifm_chn_07[i]   = str(my_list_7[i]) +  str(my_list_6[i]) +  str(my_list_5[i]) +  str(my_list_4[i]) +  str(my_list_3[i]) +  str(my_list_2[i]) +  str(my_list_1[i]) +  str(my_list_0[i])
    ifm_chn_815[i]  = str(my_list_15[i]) +  str(my_list_14[i]) +  str(my_list_13[i]) +  str(my_list_12[i]) +  str(my_list_11[i]) +  str(my_list_10[i]) +  str(my_list_9[i]) +  str(my_list_8[i])

ifm_list_hex = ifm_chn_07 + ifm_chn_815

text_save(ifm_list_hex,'ifmap_hex.txt')

text_save(ifm_chn_0,'ifmap_int_layer0.txt')
text_save(ifm_chn_1,'ifmap_int_layer1.txt')
text_save(ifm_chn_2,'ifmap_int_layer2.txt')
text_save(ifm_chn_3,'ifmap_int_layer3.txt')
text_save(ifm_chn_4,'ifmap_int_layer4.txt')
text_save(ifm_chn_5,'ifmap_int_layer5.txt')
text_save(ifm_chn_6,'ifmap_int_layer6.txt')
text_save(ifm_chn_7,'ifmap_int_layer7.txt')
text_save(ifm_chn_8,'ifmap_int_layer8.txt')
text_save(ifm_chn_9,'ifmap_int_layer9.txt')
text_save(ifm_chn_10,'ifmap_int_layer10.txt')
text_save(ifm_chn_11,'ifmap_int_layer11.txt')
text_save(ifm_chn_12,'ifmap_int_layer12.txt')
text_save(ifm_chn_13,'ifmap_int_layer13.txt')
text_save(ifm_chn_14,'ifmap_int_layer14.txt')
text_save(ifm_chn_15,'ifmap_int_layer15.txt')