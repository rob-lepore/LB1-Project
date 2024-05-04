python3 scripts/kfold-CV.py <(grep "1$" sets/train_set.txt | sort -R) <(grep "0$" sets/train_set.txt | sort -R)

for n in {1..5}; do
    printf "\n" >> "sets/fold-$n.txt"
done

for output_num in {1..5}; do
    output_file="sets/fold-${output_num}-train.txt"
    files_to_cat=""
    
    for i in {1..5}; do
        if [ "$i" != "$output_num" ]; then
            files_to_cat+="sets/fold-$i.txt "
        fi
    done
    
    cat $files_to_cat > "$output_file"
done
