#!/bin/bash
#1BUN:B,1DTX:A,1FAK:I,1KTH:A,4BQD:A,4ISO:B,4U30:X,4U32:X,5M4V:A,6Q61:A,1AAP:A,1YC0:I,1ZR0:B,3BYB:A,3M7Q:B,4DTG:K,4NTW:B,5NX1:D,5PTI:A,5YV7:A,6YHY:A
printf "\nRetrieving UniProt Accession IDS corresponding to the PDB structures... "
JOB_ID=`curl -s --form 'from="PDB"' \
     --form 'to="UniProtKB-Swiss-Prot"' \
     --form ids="$1" \
     https://rest.uniprot.org/idmapping/run`;

JOB_ID=`echo $JOB_ID | cut -d ":" -f 2 | tr -d "}\""`

while [ "$STATUS" != "FINISHED" ]
do
    STATUS_LONG=`curl -s -i "https://rest.uniprot.org/idmapping/status/$JOB_ID"`
    STATUS=`echo $STATUS_LONG | cut -d "\"" -f 4`
done
curl -s -i "https://rest.uniprot.org/idmapping/status/$JOB_ID" > mapping.log

RES_URL=`grep "location" mapping.log | cut -d " " -f 2 | rev | cut -c2- | rev`
curl -s $RES_URL > id_mapping_results.json
python3 scripts/extract_id_mapping.py
rm mapping.log
rm id_mapping_results.json