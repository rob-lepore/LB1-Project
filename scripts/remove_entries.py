import sys

if __name__ == "__main__":

    remove_ids = open(sys.argv[1]).read().rstrip().split("\n")
    ids_dict = {}
    for id in remove_ids:
        ids_dict[id] = True
    
    fastafile = open(sys.argv[2])
    selectedfile = open(sys.argv[3], "w")

    found = False
    for line in fastafile:
        if line[0] == ">":
            if line.split()[0][1:] in ids_dict:
                found = True
            else:
                found = False
        if not found:
            selectedfile.write(line)

    selectedfile.close()