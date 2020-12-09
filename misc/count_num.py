import os
import sys

def is_firm(filename):
    #l = ['.zip', '.bin', '.img', '.dmg', '.rar', '.pat', '.pkg']
    l = ['.pkg']
    for i in l:
        if filename.upper().endswith(i.upper()):
            #print(filename)
            return True
    return False

num = 0
def print_files(path):
    global num
    lsdir = os.listdir(path)
    dirs = [i for i in lsdir if os.path.isdir(os.path.join(path, i))]
    if dirs:
        for i in dirs:
            print_files(os.path.join(path, i))
    files = [i for i in lsdir if os.path.isfile(os.path.join(path,i))]
    for f in files:
        if is_firm(f):
            num +=1


print_files(sys.argv[1])
print(num)
