# Get PDB IDs 
printf "\n\nQuerying structures... "
python3 scripts/get_structures.py $1 $2 $3 $4 $5 $6

# Download PDB files
printf "\nDownloading PDB files...\n"
mkdir -p pdb_files
python3 scripts/download_pdbs.py &
# Progress bar 
tot_files=`wc -l pdb_query.ids | cut -d \  -f 1`
n_files=0
while [ $n_files -lt $tot_files ]
do
    n_files=`ls pdb_files/ | awk '{gsub(/ /, "\n"); print}' | wc -l | cut -d \  -f 1`
    n_files=$(( $n_files / 2 ))
    perc=$(( 100 * $n_files / tot_files ))
    printf "...$perc%% \r"
done

rm pdb_files/*_temp.pdb
echo `ls pdb_files/` | awk '{gsub(/ /, "\n"); print}' > list
printf "PDB files in pdb_files/ directory\n"

# USalign multiple structure alignment
printf "\nExecuting multiple structure alignment... "
mkdir -p alignments
./USalign/USalign -dir pdb_files/ list -mm 4 -outfmt 1 > ./alignments/msa_temp.fasta
grep -v "^[#$]" alignments/msa_temp.fasta | awk '{if (substr($0,1,1)==">") {print "\n"$1} else { printf "%s",$1 } }' | grep "." > alignments/msa.fasta
rm alignments/msa_temp.fasta
rm list
aln_length=`cat alignments/msa.fasta | awk 'NR==2 { print length($0); }'`
printf "Alignment length: $aln_length\n"