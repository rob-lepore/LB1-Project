python3 kfold-CV.py <(grep "1$" results/train_set.txt | sort -R) <(grep "0$" results/train_set.txt | sort -R)

for n in {1..5}; do
    printf "\n" >> "results/fold-$n.txt"
done

# Loop through output file numbers
for output_num in {1..5}; do
    # Initialize an empty variable to store the concatenated file name
    output_file="results/fold-${output_num}-train.txt"
    
    # Initialize an empty variable to store the files used in cat
    files_to_cat=""
    
    # Loop through fold files
    for i in {1..5}; do
        # Exclude the output file number
        if [ "$i" != "$output_num" ]; then
            files_to_cat+="results/fold-$i.txt "
        fi
    done
    
    # Concatenate files to the output file
    cat $files_to_cat > "$output_file"
done


printf "\nComputing performance on each fold... "
printf "" > "results/th_performances.txt"
for n in {1..5}
do
    th=`for i in 3.0e-7 1.0e-7 3.0e-8 1.0e-8 3.0e-9 1.0e-9 3.0e-10 1.0e-10 3e-11 1e-11; do python3 ./performance.py results/fold-$n-train.txt $i; done | sort -rk 2 | head -n 1 | cut -d " " -f 1`
    python3 ./performance.py results/fold-$n.txt $th >> "results/th_performances.txt"
done
printf "Done\n"

best=`cat results/th_performances.txt | sort -rk 2 | head -n 1`
best_th=`echo $best | cut -d " " -f 1`
best_p=`echo $best | cut -d " " -f 2`
printf "Optimal e-value threshold: $best_th (performance: $best_p)\n"

printf "\nPerformance on test set: "
python3 ./performance.py results/test_set.txt $best_th | cut -d " " -f 2
printf "\n"