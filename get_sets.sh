# Get positive set with UniProt API
printf "Downloading positive set... \n"
pfam_id=$1
cath_id=$2
ip_id=$3
mkdir -p sets
curl  "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=%28%28reviewed%3Atrue%29+AND+%28+%28xref%3Apfam-$pfam_id%29+OR+%28xref%3Agene3d-$cath_id%29+OR+%28xref%3Ainterpro-$ip_id%29+%29%29" --output sets/all_positives.fasta.gz
gunzip sets/all_positives.fasta.gz
printf "\nDone\n"
# Get negative set with UniProt API
printf "Downloading negative set... \n"
curl "https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=%28%28reviewed%3Atrue%29+NOT+%28xref%3Apfam-$pfam_id%29+NOT+%28xref%3Agene3d-$cath_id%29+NOT+%28xref%3Ainterpro-$ip_id%29%29" --output sets/all_negatives.fasta.gz
printf "\nDone\n"

# Get UniProt IDs of the structures used in the training
L=`cat pdb_query.ids`
ids=`echo $L | awk '{gsub(" ", ","); print}'`
./id_mapping.sh $ids

# Remove the sequences from the positive set
python3 scripts/remove_entries.py sets/to_remove.ids sets/all_positives.fasta sets/selected.fasta
grep ">" sets/selected.fasta | tr -d ">" | cut -d " " -f 1 > sets/selected.ids
final_size=`grep ">" ./sets/selected.fasta |wc -l`
printf "Selected positive set size: $final_size\n"
n_neg=`zgrep ">" sets/all_negatives.fasta.gz | wc -l`
printf "Negative set size: $n_neg"

