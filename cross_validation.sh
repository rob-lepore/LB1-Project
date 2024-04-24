printf "Computing performance...\n"
for i in 3.0e-7 1.0e-7 3.0e-8 1.0e-8 3.0e-9 1.0e-9 3.0e-10 1.0e-10; do python3 ./performance.py results/train_set.txt $i; done | sort -rk 5