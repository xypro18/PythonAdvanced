source = '/users/python/Documents/PYA001/04.Filesystems/matches_dataset/'
destination = '/users/python/Documents/PYA001/04.Filesystems/combinado.csv'
files = []


for x in os.walk(source):
    if len(x[2]) != 0:        
        for item in x[2]:
            if item.endswith(".csv"):
                files.append(x[0] + "/" + item)

with open(destination, 'w', encoding="utf-8") as outfile:
    firstFile = True
    for fname in files:
        with open(fname, encoding="utf-8") as infile:
            firstLine = True
            for line in infile:
                if firstFile == True or firstLine == False:
                    outfile.write(line)
                firstLine = False
        
        firstFile = False