#!/bin/bash

printf "\nMatching HMM against positive/negative train/test sets... "
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/positives_1.out hmm/$1.hmm sets/positives_1.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/negatives_1.out hmm/$1.hmm sets/negatives_1.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/positives_2.out hmm/$1.hmm sets/positives_2.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/negatives_2.out hmm/$1.hmm sets/negatives_2.fasta > /dev/null
printf "Done\n"

printf "\nBuilding train and test sets with E-value and labels... "
# Negatives train set
grep -v "#" results/negatives_1.out | awk '{print $1"\t"$8"\t0"}' > results/tmp_negatives_1.txt
comm -23 <(sort sets/negatives_1.ids) <(cut -f 1 results/tmp_negatives_1.txt | sort)  | awk '{print $1"\t10\t0"}' >> results/tmp_negatives_1.txt

# Negatives test set
grep -v "#" results/negatives_2.out | awk '{print $1"\t"$8"\t0"}' > results/tmp_negatives_2.txt
comm -23 <(sort sets/negatives_2.ids) <(cut -f 1 results/tmp_negatives_2.txt | sort)  | awk '{print $1"\t10\t0"}' >> results/tmp_negatives_2.txt

# Add positives to sets
cat results/tmp_negatives_1.txt > results/train_set.txt
grep -v "#" results/positives_1.out | awk '{print $1"\t"$8"\t1"}' >> results/train_set.txt
cat results/tmp_negatives_2.txt > results/test_set.txt
grep -v "#" results/positives_1.out | awk '{print $1"\t"$8"\t1"}' >> results/test_set.txt

printf "Done\n"