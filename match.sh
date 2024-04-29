#!/bin/bash

printf "\nMatching HMM against positive/negative train/test sets... "
hmmsearch --max --noali -Z 1 --domZ 1 --tblout sets/positives_train.out hmm/$1.hmm sets/positives_train.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout sets/negatives_train.out hmm/$1.hmm sets/negatives_train.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout sets/positives_test.out hmm/$1.hmm sets/positives_test.fasta > /dev/null
hmmsearch --max --noali -Z 1 --domZ 1 --tblout sets/negatives_test.out hmm/$1.hmm sets/negatives_test.fasta > /dev/null
printf "Done\n"

printf "\nBuilding train and test sets with E-value and labels... "
# Negatives train set
grep -v "#" sets/negatives_train.out | awk '{print $1"\t"$8"\t0"}' > sets/tmp_negatives_train.txt
comm -23 <(sort sets/negatives_train.ids) <(cut -f 1 sets/tmp_negatives_train.txt | sort)  | awk '{print $1"\t10\t0"}' >> sets/tmp_negatives_train.txt

# Negatives test set
grep -v "#" sets/negatives_test.out | awk '{print $1"\t"$8"\t0"}' > sets/tmp_negatives_test.txt
comm -23 <(sort sets/negatives_test.ids) <(cut -f 1 sets/tmp_negatives_test.txt | sort)  | awk '{print $1"\t10\t0"}' >> sets/tmp_negatives_test.txt

# Add positives to sets
cat sets/tmp_negatives_train.txt > sets/train_set.txt
grep -v "#" sets/positives_train.out | awk '{print $1"\t"$8"\t1"}' >> sets/train_set.txt
cat sets/tmp_negatives_test.txt > sets/test_set.txt
grep -v "#" sets/positives_test.out | awk '{print $1"\t"$8"\t1"}' >> sets/test_set.txt

shopt -q -s extglob
#rm results/!(*_set.txt)
rm sets/tmp_*
rm sets/*.out
shopt -q -u extglob
printf "Done\n"