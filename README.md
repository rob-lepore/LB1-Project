# Structure-based Hidden Markov Model for the Kunitz-type protease inhibitor domain

Profile-Hidden Markov Models are a powerful tool to identify homology between sequences and automatically annotate the presence of functional domains inside proteins. Here, a profile-HMM based on structural information is built to model the Kunitz/BPTI domain and identify members of the Kunitz-type serine protease inhibitors family. The obtained profile-HMM shows excellent ability in identifying the Kunitz domain in protein sequences, proving the power of profile-HMMs as tools for automatic protein family annotation. Comparing this to a sequence-based HMM suggests that structural information slightly enhances the model’s performance.

The whole process of building and evaluating the profile-HMM can be replicated executing the following command:

```sh
./mdomain --pfam PF00014 --cath "4.10.410.10" --ip IPR002223 --min-length 50 --max-length 80 --clust-th 70 --hmm-name kunitz
```

## Workflow
1. Retrieve PDB structures based on PFAM, CATH and Interpro
2. Structures are clustered using PDB representatives
3. Multiple structural alignment (USalign)
4. HMM based on the alignment (HMMER)
5. Get dataset of positive and negative from UniProt
6. Remove the positive entries corresponding to the structures used in the alignment (UniProt ID Mapping)
7. Use 50% of the records as training set and the remaining as test set
8. Match the sets against the HMM
9. Find optimal e-value threshold for classification using 5-fold CV on the training set
10. Evaluate performance on the test set
11. List false predictions

To evaluate the profile-HMM against the test set with a threshold ```th```:
```sh
python3 scripts/performance.py sets/test_set.txt th
```
