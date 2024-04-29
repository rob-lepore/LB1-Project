python3 scripts/kfold-CV.py <(grep "1$" sets/train_set.txt | sort -R) <(grep "0$" sets/train_set.txt | sort -R)

for n in {1..5}; do
    printf "\n" >> "sets/fold-$n.txt"
done

# Loop through output file numbers
for output_num in {1..5}; do
    # Initialize an empty variable to store the concatenated file name
    output_file="sets/fold-${output_num}-train.txt"
    
    # Initialize an empty variable to store the files used in cat
    files_to_cat=""
    
    # Loop through fold files
    for i in {1..5}; do
        # Exclude the output file number
        if [ "$i" != "$output_num" ]; then
            files_to_cat+="sets/fold-$i.txt "
        fi
    done
    
    # Concatenate files to the output file
    cat $files_to_cat > "$output_file"
done
