import sys

def create_fold(rows, number):
    with open(f"results/fold-{number}.txt", "w") as file:
        file.write("\n".join(rows))


if __name__ == "__main__":
    positives = open(sys.argv[1]).read().strip().split("\n")
    negatives = open(sys.argv[2]).read().strip().split("\n")

    n_pos = len(positives)
    n_neg = len(negatives)
    
    k = 5

    for i in range(k-1):
        pos_start =  i * (n_pos // k)
        pos_end = (i + 1) * (n_pos // k)
        neg_start = i * (n_neg // k)
        neg_end = (i + 1) * (n_neg // k)
        entries = positives[pos_start:pos_end]
        entries.extend(negatives[neg_start:neg_end])
        create_fold(entries, i+1)
        
        
    
    pos_start =  pos_end
    pos_end = n_pos
    neg_start = neg_end
    neg_end = n_neg
    entries = positives[pos_start:pos_end]
    entries.extend(negatives[neg_start:neg_end])
    create_fold(entries, 5)

            

    """
    print(pos_start, pos_end, pos_end - pos_start)
    print(neg_start, neg_end, neg_end - neg_start)
    print()
    """ 






