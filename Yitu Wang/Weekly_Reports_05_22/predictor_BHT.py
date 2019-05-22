branch_pre = [[0 for i in range(4)] for j in range(64)]
history_record = [0]*2
mispredictions = 0

filename = 'history.txt'
with open(filename) as file_object:
    lines = file_object.readlines()

info = []
for line in lines:
    info.append(line.rstrip())

def get_row_addr(str1, str0):
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


for i in range(0,len(info)):
    row_addr = get_row_addr(info[i][8],info[i][9])
    token    = info[i][23]
    history_record [i%2] = ord(token) - 48
    col_addr = history_record[1]*2 + history_record[0]

    if branch_pre[row_addr][col_addr] != token:
        mispredictions = mispredictions + 1

    branch_pre[row_addr][col_addr] = token



print('The number of mispredictions are:',mispredictions)
print('The misprediction rate is:',mispredictions/len(info))


