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

####### weight set_0 generation #######

wgt_set_0_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_0_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_0_07  = [None] * 25
wgt_set_0_815 = [None] * 25

for i in range(len(wgt_set_0_07)):
    wgt_set_0_07[i]  = bin2hex16(str(int2bin16(wgt_set_0_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_0_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_0[i])))
    wgt_set_0_815[i] = bin2hex16(str(int2bin16(wgt_set_0_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_0_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_0_chn_8[i])))

wgt_set_0 = wgt_set_0_07 + wgt_set_0_815

text_save(wgt_set_0_chn_0,'wgt_set_0_chn_0.txt')
text_save(wgt_set_0_chn_1,'wgt_set_0_chn_1.txt')
text_save(wgt_set_0_chn_2,'wgt_set_0_chn_2.txt')
text_save(wgt_set_0_chn_3,'wgt_set_0_chn_3.txt')
text_save(wgt_set_0_chn_4,'wgt_set_0_chn_4.txt')
text_save(wgt_set_0_chn_5,'wgt_set_0_chn_5.txt')
text_save(wgt_set_0_chn_6,'wgt_set_0_chn_6.txt')
text_save(wgt_set_0_chn_7,'wgt_set_0_chn_7.txt')
text_save(wgt_set_0_chn_8,'wgt_set_0_chn_8.txt')
text_save(wgt_set_0_chn_9,'wgt_set_0_chn_9.txt')
text_save(wgt_set_0_chn_10,'wgt_set_0_chn_10.txt')
text_save(wgt_set_0_chn_11,'wgt_set_0_chn_11.txt')
text_save(wgt_set_0_chn_12,'wgt_set_0_chn_12.txt')
text_save(wgt_set_0_chn_13,'wgt_set_0_chn_13.txt')
text_save(wgt_set_0_chn_14,'wgt_set_0_chn_14.txt')
text_save(wgt_set_0_chn_15,'wgt_set_0_chn_15.txt')

####### weight set_0 generation #######

####### weight set_1 generation #######

wgt_set_1_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_1_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_1_07  = [None] * 25
wgt_set_1_815 = [None] * 25

for i in range(len(wgt_set_1_07)):
    wgt_set_1_07[i]  = bin2hex16(str(int2bin16(wgt_set_1_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_1_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_0[i])))
    wgt_set_1_815[i] = bin2hex16(str(int2bin16(wgt_set_1_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_1_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_1_chn_8[i])))

wgt_set_1 = wgt_set_1_07 + wgt_set_1_815

text_save(wgt_set_1_chn_0,'wgt_set_1_chn_0.txt')
text_save(wgt_set_1_chn_1,'wgt_set_1_chn_1.txt')
text_save(wgt_set_1_chn_2,'wgt_set_1_chn_2.txt')
text_save(wgt_set_1_chn_3,'wgt_set_1_chn_3.txt')
text_save(wgt_set_1_chn_4,'wgt_set_1_chn_4.txt')
text_save(wgt_set_1_chn_5,'wgt_set_1_chn_5.txt')
text_save(wgt_set_1_chn_6,'wgt_set_1_chn_6.txt')
text_save(wgt_set_1_chn_7,'wgt_set_1_chn_7.txt')
text_save(wgt_set_1_chn_8,'wgt_set_1_chn_8.txt')
text_save(wgt_set_1_chn_9,'wgt_set_1_chn_9.txt')
text_save(wgt_set_1_chn_10,'wgt_set_1_chn_10.txt')
text_save(wgt_set_1_chn_11,'wgt_set_1_chn_11.txt')
text_save(wgt_set_1_chn_12,'wgt_set_1_chn_12.txt')
text_save(wgt_set_1_chn_13,'wgt_set_1_chn_13.txt')
text_save(wgt_set_1_chn_14,'wgt_set_1_chn_14.txt')
text_save(wgt_set_1_chn_15,'wgt_set_1_chn_15.txt')

####### weight set_1 generation #######

####### weight set_2 generation #######

wgt_set_2_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_2_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_2_07  = [None] * 25
wgt_set_2_815 = [None] * 25

for i in range(len(wgt_set_2_07)):
    wgt_set_2_07[i]  = bin2hex16(str(int2bin16(wgt_set_2_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_2_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_0[i])))
    wgt_set_2_815[i] = bin2hex16(str(int2bin16(wgt_set_2_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_2_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_2_chn_8[i])))

wgt_set_2 = wgt_set_2_07 + wgt_set_2_815

text_save(wgt_set_2_chn_0,'wgt_set_2_chn_0.txt')
text_save(wgt_set_2_chn_1,'wgt_set_2_chn_1.txt')
text_save(wgt_set_2_chn_2,'wgt_set_2_chn_2.txt')
text_save(wgt_set_2_chn_3,'wgt_set_2_chn_3.txt')
text_save(wgt_set_2_chn_4,'wgt_set_2_chn_4.txt')
text_save(wgt_set_2_chn_5,'wgt_set_2_chn_5.txt')
text_save(wgt_set_2_chn_6,'wgt_set_2_chn_6.txt')
text_save(wgt_set_2_chn_7,'wgt_set_2_chn_7.txt')
text_save(wgt_set_2_chn_8,'wgt_set_2_chn_8.txt')
text_save(wgt_set_2_chn_9,'wgt_set_2_chn_9.txt')
text_save(wgt_set_2_chn_10,'wgt_set_2_chn_10.txt')
text_save(wgt_set_2_chn_11,'wgt_set_2_chn_11.txt')
text_save(wgt_set_2_chn_12,'wgt_set_2_chn_12.txt')
text_save(wgt_set_2_chn_13,'wgt_set_2_chn_13.txt')
text_save(wgt_set_2_chn_14,'wgt_set_2_chn_14.txt')
text_save(wgt_set_2_chn_15,'wgt_set_2_chn_15.txt')

####### weight set_2 generation #######

####### weight set_3 generation #######

wgt_set_3_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_3_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_3_07  = [None] * 25
wgt_set_3_815 = [None] * 25

for i in range(len(wgt_set_3_07)):
    wgt_set_3_07[i]  = bin2hex16(str(int2bin16(wgt_set_3_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_3_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_0[i])))
    wgt_set_3_815[i] = bin2hex16(str(int2bin16(wgt_set_3_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_3_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_3_chn_8[i])))

wgt_set_3 = wgt_set_3_07 + wgt_set_3_815

text_save(wgt_set_3_chn_0,'wgt_set_3_chn_0.txt')
text_save(wgt_set_3_chn_1,'wgt_set_3_chn_1.txt')
text_save(wgt_set_3_chn_2,'wgt_set_3_chn_2.txt')
text_save(wgt_set_3_chn_3,'wgt_set_3_chn_3.txt')
text_save(wgt_set_3_chn_4,'wgt_set_3_chn_4.txt')
text_save(wgt_set_3_chn_5,'wgt_set_3_chn_5.txt')
text_save(wgt_set_3_chn_6,'wgt_set_3_chn_6.txt')
text_save(wgt_set_3_chn_7,'wgt_set_3_chn_7.txt')
text_save(wgt_set_3_chn_8,'wgt_set_3_chn_8.txt')
text_save(wgt_set_3_chn_9,'wgt_set_3_chn_9.txt')
text_save(wgt_set_3_chn_10,'wgt_set_3_chn_10.txt')
text_save(wgt_set_3_chn_11,'wgt_set_3_chn_11.txt')
text_save(wgt_set_3_chn_12,'wgt_set_3_chn_12.txt')
text_save(wgt_set_3_chn_13,'wgt_set_3_chn_13.txt')
text_save(wgt_set_3_chn_14,'wgt_set_3_chn_14.txt')
text_save(wgt_set_3_chn_15,'wgt_set_3_chn_15.txt')

####### weight set_3 generation #######

####### weight set_4 generation #######

wgt_set_4_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_4_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_4_07  = [None] * 25
wgt_set_4_815 = [None] * 25

for i in range(len(wgt_set_4_07)):
    wgt_set_4_07[i]  = bin2hex16(str(int2bin16(wgt_set_4_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_4_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_0[i])))
    wgt_set_4_815[i] = bin2hex16(str(int2bin16(wgt_set_4_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_4_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_4_chn_8[i])))

wgt_set_4 = wgt_set_4_07 + wgt_set_4_815

text_save(wgt_set_4_chn_0,'wgt_set_4_chn_0.txt')
text_save(wgt_set_4_chn_1,'wgt_set_4_chn_1.txt')
text_save(wgt_set_4_chn_2,'wgt_set_4_chn_2.txt')
text_save(wgt_set_4_chn_3,'wgt_set_4_chn_3.txt')
text_save(wgt_set_4_chn_4,'wgt_set_4_chn_4.txt')
text_save(wgt_set_4_chn_5,'wgt_set_4_chn_5.txt')
text_save(wgt_set_4_chn_6,'wgt_set_4_chn_6.txt')
text_save(wgt_set_4_chn_7,'wgt_set_4_chn_7.txt')
text_save(wgt_set_4_chn_8,'wgt_set_4_chn_8.txt')
text_save(wgt_set_4_chn_9,'wgt_set_4_chn_9.txt')
text_save(wgt_set_4_chn_10,'wgt_set_4_chn_10.txt')
text_save(wgt_set_4_chn_11,'wgt_set_4_chn_11.txt')
text_save(wgt_set_4_chn_12,'wgt_set_4_chn_12.txt')
text_save(wgt_set_4_chn_13,'wgt_set_4_chn_13.txt')
text_save(wgt_set_4_chn_14,'wgt_set_4_chn_14.txt')
text_save(wgt_set_4_chn_15,'wgt_set_4_chn_15.txt')

####### weight set_4 generation #######

####### weight set_5 generation #######

wgt_set_5_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_5_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_5_07  = [None] * 25
wgt_set_5_815 = [None] * 25

for i in range(len(wgt_set_5_07)):
    wgt_set_5_07[i]  = bin2hex16(str(int2bin16(wgt_set_5_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_5_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_0[i])))
    wgt_set_5_815[i] = bin2hex16(str(int2bin16(wgt_set_5_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_5_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_5_chn_8[i])))

wgt_set_5 = wgt_set_5_07 + wgt_set_5_815

text_save(wgt_set_5_chn_0,'wgt_set_5_chn_0.txt')
text_save(wgt_set_5_chn_1,'wgt_set_5_chn_1.txt')
text_save(wgt_set_5_chn_2,'wgt_set_5_chn_2.txt')
text_save(wgt_set_5_chn_3,'wgt_set_5_chn_3.txt')
text_save(wgt_set_5_chn_4,'wgt_set_5_chn_4.txt')
text_save(wgt_set_5_chn_5,'wgt_set_5_chn_5.txt')
text_save(wgt_set_5_chn_6,'wgt_set_5_chn_6.txt')
text_save(wgt_set_5_chn_7,'wgt_set_5_chn_7.txt')
text_save(wgt_set_5_chn_8,'wgt_set_5_chn_8.txt')
text_save(wgt_set_5_chn_9,'wgt_set_5_chn_9.txt')
text_save(wgt_set_5_chn_10,'wgt_set_5_chn_10.txt')
text_save(wgt_set_5_chn_11,'wgt_set_5_chn_11.txt')
text_save(wgt_set_5_chn_12,'wgt_set_5_chn_12.txt')
text_save(wgt_set_5_chn_13,'wgt_set_5_chn_13.txt')
text_save(wgt_set_5_chn_14,'wgt_set_5_chn_14.txt')
text_save(wgt_set_5_chn_15,'wgt_set_5_chn_15.txt')

####### weight set_5 generation #######

####### weight set_6 generation #######

wgt_set_6_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_6_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_6_07  = [None] * 25
wgt_set_6_815 = [None] * 25

for i in range(len(wgt_set_6_07)):
    wgt_set_6_07[i]  = bin2hex16(str(int2bin16(wgt_set_6_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_6_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_0[i])))
    wgt_set_6_815[i] = bin2hex16(str(int2bin16(wgt_set_6_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_6_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_6_chn_8[i])))

wgt_set_6 = wgt_set_6_07 + wgt_set_6_815

text_save(wgt_set_6_chn_0,'wgt_set_6_chn_0.txt')
text_save(wgt_set_6_chn_1,'wgt_set_6_chn_1.txt')
text_save(wgt_set_6_chn_2,'wgt_set_6_chn_2.txt')
text_save(wgt_set_6_chn_3,'wgt_set_6_chn_3.txt')
text_save(wgt_set_6_chn_4,'wgt_set_6_chn_4.txt')
text_save(wgt_set_6_chn_5,'wgt_set_6_chn_5.txt')
text_save(wgt_set_6_chn_6,'wgt_set_6_chn_6.txt')
text_save(wgt_set_6_chn_7,'wgt_set_6_chn_7.txt')
text_save(wgt_set_6_chn_8,'wgt_set_6_chn_8.txt')
text_save(wgt_set_6_chn_9,'wgt_set_6_chn_9.txt')
text_save(wgt_set_6_chn_10,'wgt_set_6_chn_10.txt')
text_save(wgt_set_6_chn_11,'wgt_set_6_chn_11.txt')
text_save(wgt_set_6_chn_12,'wgt_set_6_chn_12.txt')
text_save(wgt_set_6_chn_13,'wgt_set_6_chn_13.txt')
text_save(wgt_set_6_chn_14,'wgt_set_6_chn_14.txt')
text_save(wgt_set_6_chn_15,'wgt_set_6_chn_15.txt')

####### weight set_6 generation #######

####### weight set_7 generation #######

wgt_set_7_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_7_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_7_07  = [None] * 25
wgt_set_7_815 = [None] * 25

for i in range(len(wgt_set_7_07)):
    wgt_set_7_07[i]  = bin2hex16(str(int2bin16(wgt_set_7_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_7_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_0[i])))
    wgt_set_7_815[i] = bin2hex16(str(int2bin16(wgt_set_7_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_7_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_7_chn_8[i])))

wgt_set_7 = wgt_set_7_07 + wgt_set_7_815

text_save(wgt_set_7_chn_0,'wgt_set_7_chn_0.txt')
text_save(wgt_set_7_chn_1,'wgt_set_7_chn_1.txt')
text_save(wgt_set_7_chn_2,'wgt_set_7_chn_2.txt')
text_save(wgt_set_7_chn_3,'wgt_set_7_chn_3.txt')
text_save(wgt_set_7_chn_4,'wgt_set_7_chn_4.txt')
text_save(wgt_set_7_chn_5,'wgt_set_7_chn_5.txt')
text_save(wgt_set_7_chn_6,'wgt_set_7_chn_6.txt')
text_save(wgt_set_7_chn_7,'wgt_set_7_chn_7.txt')
text_save(wgt_set_7_chn_8,'wgt_set_7_chn_8.txt')
text_save(wgt_set_7_chn_9,'wgt_set_7_chn_9.txt')
text_save(wgt_set_7_chn_10,'wgt_set_7_chn_10.txt')
text_save(wgt_set_7_chn_11,'wgt_set_7_chn_11.txt')
text_save(wgt_set_7_chn_12,'wgt_set_7_chn_12.txt')
text_save(wgt_set_7_chn_13,'wgt_set_7_chn_13.txt')
text_save(wgt_set_7_chn_14,'wgt_set_7_chn_14.txt')
text_save(wgt_set_7_chn_15,'wgt_set_7_chn_15.txt')

####### weight set_7 generation #######

####### weight set_8 generation #######

wgt_set_8_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_8_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_8_07  = [None] * 25
wgt_set_8_815 = [None] * 25

for i in range(len(wgt_set_8_07)):
    wgt_set_8_07[i]  = bin2hex16(str(int2bin16(wgt_set_8_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_8_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_0[i])))
    wgt_set_8_815[i] = bin2hex16(str(int2bin16(wgt_set_8_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_8_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_8_chn_8[i])))

wgt_set_8 = wgt_set_8_07 + wgt_set_8_815

text_save(wgt_set_8_chn_0,'wgt_set_8_chn_0.txt')
text_save(wgt_set_8_chn_1,'wgt_set_8_chn_1.txt')
text_save(wgt_set_8_chn_2,'wgt_set_8_chn_2.txt')
text_save(wgt_set_8_chn_3,'wgt_set_8_chn_3.txt')
text_save(wgt_set_8_chn_4,'wgt_set_8_chn_4.txt')
text_save(wgt_set_8_chn_5,'wgt_set_8_chn_5.txt')
text_save(wgt_set_8_chn_6,'wgt_set_8_chn_6.txt')
text_save(wgt_set_8_chn_7,'wgt_set_8_chn_7.txt')
text_save(wgt_set_8_chn_8,'wgt_set_8_chn_8.txt')
text_save(wgt_set_8_chn_9,'wgt_set_8_chn_9.txt')
text_save(wgt_set_8_chn_10,'wgt_set_8_chn_10.txt')
text_save(wgt_set_8_chn_11,'wgt_set_8_chn_11.txt')
text_save(wgt_set_8_chn_12,'wgt_set_8_chn_12.txt')
text_save(wgt_set_8_chn_13,'wgt_set_8_chn_13.txt')
text_save(wgt_set_8_chn_14,'wgt_set_8_chn_14.txt')
text_save(wgt_set_8_chn_15,'wgt_set_8_chn_15.txt')

####### weight set_8 generation #######

####### weight set_9 generation #######

wgt_set_9_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_9_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_9_07  = [None] * 25
wgt_set_9_815 = [None] * 25

for i in range(len(wgt_set_9_07)):
    wgt_set_9_07[i]  = bin2hex16(str(int2bin16(wgt_set_9_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_9_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_0[i])))
    wgt_set_9_815[i] = bin2hex16(str(int2bin16(wgt_set_9_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_9_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_9_chn_8[i])))

wgt_set_9 = wgt_set_9_07 + wgt_set_9_815

text_save(wgt_set_9_chn_0,'wgt_set_9_chn_0.txt')
text_save(wgt_set_9_chn_1,'wgt_set_9_chn_1.txt')
text_save(wgt_set_9_chn_2,'wgt_set_9_chn_2.txt')
text_save(wgt_set_9_chn_3,'wgt_set_9_chn_3.txt')
text_save(wgt_set_9_chn_4,'wgt_set_9_chn_4.txt')
text_save(wgt_set_9_chn_5,'wgt_set_9_chn_5.txt')
text_save(wgt_set_9_chn_6,'wgt_set_9_chn_6.txt')
text_save(wgt_set_9_chn_7,'wgt_set_9_chn_7.txt')
text_save(wgt_set_9_chn_8,'wgt_set_9_chn_8.txt')
text_save(wgt_set_9_chn_9,'wgt_set_9_chn_9.txt')
text_save(wgt_set_9_chn_10,'wgt_set_9_chn_10.txt')
text_save(wgt_set_9_chn_11,'wgt_set_9_chn_11.txt')
text_save(wgt_set_9_chn_12,'wgt_set_9_chn_12.txt')
text_save(wgt_set_9_chn_13,'wgt_set_9_chn_13.txt')
text_save(wgt_set_9_chn_14,'wgt_set_9_chn_14.txt')
text_save(wgt_set_9_chn_15,'wgt_set_9_chn_15.txt')

####### weight set_9 generation #######

####### weight set_10 generation #######

wgt_set_10_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_10_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_10_07  = [None] * 25
wgt_set_10_815 = [None] * 25

for i in range(len(wgt_set_10_07)):
    wgt_set_10_07[i]  = bin2hex16(str(int2bin16(wgt_set_10_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_10_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_0[i])))
    wgt_set_10_815[i] = bin2hex16(str(int2bin16(wgt_set_10_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_10_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_10_chn_8[i])))

wgt_set_10 = wgt_set_10_07 + wgt_set_10_815

text_save(wgt_set_10_chn_0,'wgt_set_10_chn_0.txt')
text_save(wgt_set_10_chn_1,'wgt_set_10_chn_1.txt')
text_save(wgt_set_10_chn_2,'wgt_set_10_chn_2.txt')
text_save(wgt_set_10_chn_3,'wgt_set_10_chn_3.txt')
text_save(wgt_set_10_chn_4,'wgt_set_10_chn_4.txt')
text_save(wgt_set_10_chn_5,'wgt_set_10_chn_5.txt')
text_save(wgt_set_10_chn_6,'wgt_set_10_chn_6.txt')
text_save(wgt_set_10_chn_7,'wgt_set_10_chn_7.txt')
text_save(wgt_set_10_chn_8,'wgt_set_10_chn_8.txt')
text_save(wgt_set_10_chn_9,'wgt_set_10_chn_9.txt')
text_save(wgt_set_10_chn_10,'wgt_set_10_chn_10.txt')
text_save(wgt_set_10_chn_11,'wgt_set_10_chn_11.txt')
text_save(wgt_set_10_chn_12,'wgt_set_10_chn_12.txt')
text_save(wgt_set_10_chn_13,'wgt_set_10_chn_13.txt')
text_save(wgt_set_10_chn_14,'wgt_set_10_chn_14.txt')
text_save(wgt_set_10_chn_15,'wgt_set_10_chn_15.txt')

####### weight set_10 generation #######

####### weight set_11 generation #######

wgt_set_11_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_11_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_11_07  = [None] * 25
wgt_set_11_815 = [None] * 25

for i in range(len(wgt_set_11_07)):
    wgt_set_11_07[i]  = bin2hex16(str(int2bin16(wgt_set_11_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_11_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_0[i])))
    wgt_set_11_815[i] = bin2hex16(str(int2bin16(wgt_set_11_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_11_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_11_chn_8[i])))

wgt_set_11 = wgt_set_11_07 + wgt_set_11_815

text_save(wgt_set_11_chn_0,'wgt_set_11_chn_0.txt')
text_save(wgt_set_11_chn_1,'wgt_set_11_chn_1.txt')
text_save(wgt_set_11_chn_2,'wgt_set_11_chn_2.txt')
text_save(wgt_set_11_chn_3,'wgt_set_11_chn_3.txt')
text_save(wgt_set_11_chn_4,'wgt_set_11_chn_4.txt')
text_save(wgt_set_11_chn_5,'wgt_set_11_chn_5.txt')
text_save(wgt_set_11_chn_6,'wgt_set_11_chn_6.txt')
text_save(wgt_set_11_chn_7,'wgt_set_11_chn_7.txt')
text_save(wgt_set_11_chn_8,'wgt_set_11_chn_8.txt')
text_save(wgt_set_11_chn_9,'wgt_set_11_chn_9.txt')
text_save(wgt_set_11_chn_10,'wgt_set_11_chn_10.txt')
text_save(wgt_set_11_chn_11,'wgt_set_11_chn_11.txt')
text_save(wgt_set_11_chn_12,'wgt_set_11_chn_12.txt')
text_save(wgt_set_11_chn_13,'wgt_set_11_chn_13.txt')
text_save(wgt_set_11_chn_14,'wgt_set_11_chn_14.txt')
text_save(wgt_set_11_chn_15,'wgt_set_11_chn_15.txt')

####### weight set_11 generation #######

####### weight set_12 generation #######

wgt_set_12_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_12_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_12_07  = [None] * 25
wgt_set_12_815 = [None] * 25

for i in range(len(wgt_set_12_07)):
    wgt_set_12_07[i]  = bin2hex16(str(int2bin16(wgt_set_12_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_12_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_0[i])))
    wgt_set_12_815[i] = bin2hex16(str(int2bin16(wgt_set_12_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_12_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_12_chn_8[i])))

wgt_set_12 = wgt_set_12_07 + wgt_set_12_815

text_save(wgt_set_12_chn_0,'wgt_set_12_chn_0.txt')
text_save(wgt_set_12_chn_1,'wgt_set_12_chn_1.txt')
text_save(wgt_set_12_chn_2,'wgt_set_12_chn_2.txt')
text_save(wgt_set_12_chn_3,'wgt_set_12_chn_3.txt')
text_save(wgt_set_12_chn_4,'wgt_set_12_chn_4.txt')
text_save(wgt_set_12_chn_5,'wgt_set_12_chn_5.txt')
text_save(wgt_set_12_chn_6,'wgt_set_12_chn_6.txt')
text_save(wgt_set_12_chn_7,'wgt_set_12_chn_7.txt')
text_save(wgt_set_12_chn_8,'wgt_set_12_chn_8.txt')
text_save(wgt_set_12_chn_9,'wgt_set_12_chn_9.txt')
text_save(wgt_set_12_chn_10,'wgt_set_12_chn_10.txt')
text_save(wgt_set_12_chn_11,'wgt_set_12_chn_11.txt')
text_save(wgt_set_12_chn_12,'wgt_set_12_chn_12.txt')
text_save(wgt_set_12_chn_13,'wgt_set_12_chn_13.txt')
text_save(wgt_set_12_chn_14,'wgt_set_12_chn_14.txt')
text_save(wgt_set_12_chn_15,'wgt_set_12_chn_15.txt')

####### weight set_12 generation #######

####### weight set_13 generation #######

wgt_set_13_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_13_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_13_07  = [None] * 25
wgt_set_13_815 = [None] * 25

for i in range(len(wgt_set_13_07)):
    wgt_set_13_07[i]  = bin2hex16(str(int2bin16(wgt_set_13_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_13_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_0[i])))
    wgt_set_13_815[i] = bin2hex16(str(int2bin16(wgt_set_13_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_13_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_13_chn_8[i])))

wgt_set_13 = wgt_set_13_07 + wgt_set_13_815

text_save(wgt_set_13_chn_0,'wgt_set_13_chn_0.txt')
text_save(wgt_set_13_chn_1,'wgt_set_13_chn_1.txt')
text_save(wgt_set_13_chn_2,'wgt_set_13_chn_2.txt')
text_save(wgt_set_13_chn_3,'wgt_set_13_chn_3.txt')
text_save(wgt_set_13_chn_4,'wgt_set_13_chn_4.txt')
text_save(wgt_set_13_chn_5,'wgt_set_13_chn_5.txt')
text_save(wgt_set_13_chn_6,'wgt_set_13_chn_6.txt')
text_save(wgt_set_13_chn_7,'wgt_set_13_chn_7.txt')
text_save(wgt_set_13_chn_8,'wgt_set_13_chn_8.txt')
text_save(wgt_set_13_chn_9,'wgt_set_13_chn_9.txt')
text_save(wgt_set_13_chn_10,'wgt_set_13_chn_10.txt')
text_save(wgt_set_13_chn_11,'wgt_set_13_chn_11.txt')
text_save(wgt_set_13_chn_12,'wgt_set_13_chn_12.txt')
text_save(wgt_set_13_chn_13,'wgt_set_13_chn_13.txt')
text_save(wgt_set_13_chn_14,'wgt_set_13_chn_14.txt')
text_save(wgt_set_13_chn_15,'wgt_set_13_chn_15.txt')

####### weight set_13 generation #######

####### weight set_14 generation #######

wgt_set_14_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_14_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_14_07  = [None] * 25
wgt_set_14_815 = [None] * 25

for i in range(len(wgt_set_14_07)):
    wgt_set_14_07[i]  = bin2hex16(str(int2bin16(wgt_set_14_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_14_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_0[i])))
    wgt_set_14_815[i] = bin2hex16(str(int2bin16(wgt_set_14_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_14_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_14_chn_8[i])))

wgt_set_14 = wgt_set_14_07 + wgt_set_14_815

text_save(wgt_set_14_chn_0,'wgt_set_14_chn_0.txt')
text_save(wgt_set_14_chn_1,'wgt_set_14_chn_1.txt')
text_save(wgt_set_14_chn_2,'wgt_set_14_chn_2.txt')
text_save(wgt_set_14_chn_3,'wgt_set_14_chn_3.txt')
text_save(wgt_set_14_chn_4,'wgt_set_14_chn_4.txt')
text_save(wgt_set_14_chn_5,'wgt_set_14_chn_5.txt')
text_save(wgt_set_14_chn_6,'wgt_set_14_chn_6.txt')
text_save(wgt_set_14_chn_7,'wgt_set_14_chn_7.txt')
text_save(wgt_set_14_chn_8,'wgt_set_14_chn_8.txt')
text_save(wgt_set_14_chn_9,'wgt_set_14_chn_9.txt')
text_save(wgt_set_14_chn_10,'wgt_set_14_chn_10.txt')
text_save(wgt_set_14_chn_11,'wgt_set_14_chn_11.txt')
text_save(wgt_set_14_chn_12,'wgt_set_14_chn_12.txt')
text_save(wgt_set_14_chn_13,'wgt_set_14_chn_13.txt')
text_save(wgt_set_14_chn_14,'wgt_set_14_chn_14.txt')
text_save(wgt_set_14_chn_15,'wgt_set_14_chn_15.txt')

####### weight set_14 generation #######

####### weight set_15 generation #######

wgt_set_15_chn_0   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_1   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_2   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_3   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_4   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_5   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_6   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_7   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_8   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_9   = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_10  = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_11  = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_12  = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_13  = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_14  = np.random.randint(-32768,32767,5*5)
wgt_set_15_chn_15  = np.random.randint(-32768,32767,5*5)

wgt_set_15_07  = [None] * 25
wgt_set_15_815 = [None] * 25

for i in range(len(wgt_set_15_07)):
    wgt_set_15_07[i]  = bin2hex16(str(int2bin16(wgt_set_15_chn_7[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_6[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_5[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_4[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_15_chn_3[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_2[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_1[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_0[i])))
    wgt_set_15_815[i] = bin2hex16(str(int2bin16(wgt_set_15_chn_15[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_14[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_13[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_12[i]))) + \
                       bin2hex16(str(int2bin16(wgt_set_15_chn_11[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_10[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_9[i]))) +  bin2hex16(str(int2bin16(wgt_set_15_chn_8[i])))

wgt_set_15 = wgt_set_15_07 + wgt_set_15_815

text_save(wgt_set_15_chn_0,'wgt_set_15_chn_0.txt')
text_save(wgt_set_15_chn_1,'wgt_set_15_chn_1.txt')
text_save(wgt_set_15_chn_2,'wgt_set_15_chn_2.txt')
text_save(wgt_set_15_chn_3,'wgt_set_15_chn_3.txt')
text_save(wgt_set_15_chn_4,'wgt_set_15_chn_4.txt')
text_save(wgt_set_15_chn_5,'wgt_set_15_chn_5.txt')
text_save(wgt_set_15_chn_6,'wgt_set_15_chn_6.txt')
text_save(wgt_set_15_chn_7,'wgt_set_15_chn_7.txt')
text_save(wgt_set_15_chn_8,'wgt_set_15_chn_8.txt')
text_save(wgt_set_15_chn_9,'wgt_set_15_chn_9.txt')
text_save(wgt_set_15_chn_10,'wgt_set_15_chn_10.txt')
text_save(wgt_set_15_chn_11,'wgt_set_15_chn_11.txt')
text_save(wgt_set_15_chn_12,'wgt_set_15_chn_12.txt')
text_save(wgt_set_15_chn_13,'wgt_set_15_chn_13.txt')
text_save(wgt_set_15_chn_14,'wgt_set_15_chn_14.txt')
text_save(wgt_set_15_chn_15,'wgt_set_15_chn_15.txt')

####### weight set_15 generation #######

wgt_set_0_8  = wgt_set_0 + wgt_set_8
wgt_set_1_9  = wgt_set_1 + wgt_set_9 
wgt_set_2_10 = wgt_set_2 + wgt_set_10
wgt_set_3_11 = wgt_set_3 + wgt_set_11
wgt_set_4_12 = wgt_set_4 + wgt_set_12
wgt_set_5_13 = wgt_set_5 + wgt_set_13
wgt_set_6_14 = wgt_set_6 + wgt_set_14
wgt_set_7_15 = wgt_set_7 + wgt_set_15

text_save(wgt_set_0_8, 'wgt_set_0_8.txt')
text_save(wgt_set_1_9, 'wgt_set_1_9.txt')
text_save(wgt_set_2_10,'wgt_set_2_10.txt')
text_save(wgt_set_3_11,'wgt_set_3_11.txt')
text_save(wgt_set_4_12,'wgt_set_4_12.txt')
text_save(wgt_set_5_13,'wgt_set_5_13.txt')
text_save(wgt_set_6_14,'wgt_set_6_14.txt')
text_save(wgt_set_7_15,'wgt_set_7_15.txt')