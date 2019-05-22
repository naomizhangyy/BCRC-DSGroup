hits_number_N_4 = 0
hits_number_N_16 = 0
hits_number_N_32 = 0
hits_number_N_64 = 0


filename = 'history.txt'
with open(filename) as file_object:
    lines = file_object.readlines()

info = []
for line in lines:
    info.append(line.rstrip())

def get_index_N_4(str0):
    sum = 0
    if ord(str0) >=48 and ord(str0) <=57:
        sum = sum + (ord(str0) - 48)%4
    if ord(str0) >=97 and ord(str0) <= 102:
        sum = sum + (ord(str0) - 87)%4
    
    return sum

def get_index_N_16(str0):
    sum = 0
    if ord(str0) >=48 and ord(str0) <=57:
        sum = sum + (ord(str0) - 48)
    if ord(str0) >=97 and ord(str0) <= 102:
        sum = sum + (ord(str0) - 87)
    
    return sum

def get_index_N_32(str1,str0):
    sum = 0
    if ord(str0) >=48 and ord(str0) <=57:
        sum = sum + (ord(str0) - 48)
    if ord(str0) >=97 and ord(str0) <= 102:
        sum = sum + (ord(str0) - 87)
    
    if ord(str1) >=48 and ord(str1) <=57:
        sum = sum + ((ord(str1) - 48)%2)*16
    if ord(str1) >=97 and ord(str1) <= 102:
        sum = sum + ((ord(str1) - 87)%2)*16
    return sum

def get_index_N_64(str1, str0):
    sum = 0
    if ord(str0) >=48 and ord(str0) <=57:
        sum = sum + ord(str0) - 48
    if ord(str0) >=97 and ord(str0) <= 102:
        sum = sum + ord(str0) - 87

    if ord(str1) >=48 and ord(str1) <=57:
        sum = sum + ((ord(str1) - 48)%4)*16
    if ord(str1) >=97 and ord(str1) <= 102:
        sum = sum + ((ord(str1) - 87)%4)*16
    
    return sum

#--------------------------------------------

N = 4
branch_addr = ['0xxxxxxxxx']*N
target_addr = ['0xxxxxxxxx']*N
valid       = [0]*N ## 1-bit * N

for i in range(0,len(info)):
    index_N_4 = get_index_N_4(info[i][9])
    token     = ord(info[i][23]) - 48

    if branch_addr[index_N_4] == info[i][0:10] and valid[index_N_4] == token :
        hits_number_N_4 = hits_number_N_4 + 1
    
    branch_addr[index_N_4] = info[i][0:10]
    valid[index_N_4] = token
    
print('When N=4, the hit rate is:',hits_number_N_4/len(info))

#---------------------------------------------

N = 16
branch_addr = ['0xxxxxxxxx']*N
target_addr = ['0xxxxxxxxx']*N
valid       = [0]*N ## 1-bit * N
for i in range(0,len(info)):
    index_N_16 = get_index_N_16(info[i][9])
    token     = ord(info[i][23]) - 48

    if branch_addr[index_N_16] == info[i][0:10] and valid[index_N_16] == token :
        hits_number_N_16 = hits_number_N_16 + 1
    
    branch_addr[index_N_16] = info[i][0:10]
    valid[index_N_16] = token
print('When N=16, the hit rate is:',hits_number_N_16/len(info))

#----------------------------------------

N = 32
branch_addr = ['0xxxxxxxxx']*N
target_addr = ['0xxxxxxxxx']*N
valid       = [0]*N ## 1-bit * N
for i in range(0,len(info)):
    index_N_32 = get_index_N_32(info[i][8],info[i][9])
    token     = ord(info[i][23]) - 48

    if branch_addr[index_N_32] == info[i][0:10] and valid[index_N_32] == token :
        hits_number_N_32 = hits_number_N_32 + 1
    
    branch_addr[index_N_32] = info[i][0:10]
    valid[index_N_32] = token
print('When N=32, the hit rate is:',hits_number_N_32/len(info))

#-----------------------------------------

N = 64
branch_addr = ['0xxxxxxxxx']*N
target_addr = ['0xxxxxxxxx']*N
valid       = [0]*N ## 1-bit * N
for i in range(0,len(info)):
    index_N_64 = get_index_N_64(info[i][8],info[i][9])
    token     = ord(info[i][23]) - 48

    if branch_addr[index_N_64] == info[i][0:10] and valid[index_N_64] == token :
        hits_number_N_64 = hits_number_N_64 + 1
    
    branch_addr[index_N_64] = info[i][0:10]
    valid[index_N_64] = token
print('When N=32, the hit rate is:',hits_number_N_32/len(info))




