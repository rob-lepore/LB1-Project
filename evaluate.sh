printf "\nComputing performance on each fold... "
mkdir results
printf "" > "results/th_performances.txt"
for n in {1..5}
do
    th=`for i in 3.0e-7 1.0e-7 3.0e-8 1.0e-8 3.0e-9 1.0e-9 3.0e-10 1.0e-10 3e-11 1e-11; do python3 scripts/performance.py sets/fold-$n-train.txt $i; done | sort -rk 2 | head -n 1 | cut -d " " -f 1`
    python3 scripts/performance.py sets/fold-$n.txt $th >> "results/th_performances.txt"
done
printf "Done\n"

best=`cat results/th_performances.txt | sort -rk 2 | head -n 1`
best_th=`echo $best | cut -d " " -f 1`
best_p=`echo $best | cut -d " " -f 2`
printf "Optimal e-value threshold: $best_th (performance: $best_p)\n"

printf "\nPerformance on test set: "
python3 scripts/performance.py sets/test_set.txt $best_th | cut -d " " -f 2
printf "\n"