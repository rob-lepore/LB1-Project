#!/bin/bash

printf "\nMatching HMM against positive/negative train/test sets... "
mkdir -p results
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/positives_train.out hmm/$1.hmm sets/positives_train.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/negatives_train.out hmm/$1.hmm sets/negatives_train.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/positives_test.out hmm/$1.hmm sets/positives_test.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout results/negatives_test.out hmm/$1.hmm sets/negatives_test.fasta > /dev/null
printf "Done\n"

printf "\nBuilding train and test sets with E-value and labels... "
# Negatives train set
grep -v "#" results/negatives_train.out | awk '{print $1"\t"$8"\t0"}' > results/tmp_negatives_train.txt
comm -23 <(sort sets/negatives_train.ids) <(cut -f 1 results/tmp_negatives_train.txt | sort)  | awk '{print $1"\t10\t0"}' >> results/tmp_negatives_train.txt

# Negatives test set
grep -v "#" results/negatives_test.out | awk '{print $1"\t"$8"\t0"}' > results/tmp_negatives_test.txt
comm -23 <(sort sets/negatives_test.ids) <(cut -f 1 results/tmp_negatives_test.txt | sort)  | awk '{print $1"\t10\t0"}' >> results/tmp_negatives_test.txt

# Add positives to sets
cat results/tmp_negatives_train.txt > results/train_set.txt
grep -v "#" results/positives_train.out | awk '{print $1"\t"$8"\t1"}' >> results/train_set.txt
cat results/tmp_negatives_test.txt > results/test_set.txt
grep -v "#" results/positives_test.out | awk '{print $1"\t"$8"\t1"}' >> results/test_set.txt

shopt -q -s extglob
rm results/!(*_set.txt)
shopt -q -u extglob
printf "Done\n"