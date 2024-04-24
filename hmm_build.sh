# HMMER model build
printf "\nBuilding HMM... "
hmm_name=$1
mkdir -p hmm
hmmbuild -o hmm/hmmbuild.log -n $hmm_name hmm/$hmm_name.hmm alignments/msa.fasta
hmm_length=`grep "^LENG" hmm/$hmm_name.hmm | awk '{print $NF}'`
printf "Model length: $hmm_length\n"