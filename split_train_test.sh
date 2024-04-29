# Separate sets in 2 subsets (train and test)
scale=2

printf "\nCreating positive train and test sets...\n"
n_pos=`grep ">" ./sets/selected.fasta |wc -l`
size_p1=$(( n_pos / scale ))
size_p2=$(( n_pos - size_p1 ))
cat sets/selected.ids | sort -R > sets/random_selected.ids
printf "Positives in train set: $size_p1 - Positives in test set: $size_p2\n"
head -n $size_p1 sets/random_selected.ids > sets/positives_train.ids
tail -n $size_p2 sets/random_selected.ids > sets/positives_test.ids
python3 scripts/remove_entries.py sets/positives_test.ids sets/selected.fasta sets/positives_train.fasta
python3 scripts/remove_entries.py sets/positives_train.ids sets/selected.fasta sets/positives_test.fasta
printf "Done\n"

printf "\nCreating negative train and test sets...\n"
zgrep ">" sets/all_negatives.fasta.gz | tr -d ">" | cut -d " " -f 1 > sets/all_negatives.ids
n_neg=`cat sets/all_negatives.ids | wc -l`
size_n1=$(( n_neg / scale ))
size_n2=$(( n_neg - size_n1 ))
printf "Negatives in train set: $size_n1 - Negatives in test set: $size_n2\n"
cat sets/all_negatives.ids | sort -R > sets/random_negatives.ids
head -n $size_n1 sets/random_negatives.ids > sets/negatives_train.ids
tail -n $size_n2 sets/random_negatives.ids > sets/negatives_test.ids
python3 scripts/remove_entries.py sets/negatives_test.ids <(zcat sets/all_negatives.fasta.gz) sets/negatives_train.fasta
python3 scripts/remove_entries.py sets/negatives_train.ids <(zcat sets/all_negatives.fasta.gz) sets/negatives_test.fasta
printf "Done\n"