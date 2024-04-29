import requests
import sys

if __name__ == "__main__":
    pfam = sys.argv[1]
    cath = sys.argv[2]
    interpro = sys.argv[3]
    minl = sys.argv[4]
    maxl = sys.argv[5]
    cth = sys.argv[6]
    #print(pfam, minl, maxl, cth)

    query = ""
    with open("pdb_query.json") as queryfile:
        query = queryfile.read()
    query = query.replace("PFAM-ID", pfam)
    query = query.replace("CATH-ID", cath)
    query = query.replace("IP-ID", interpro)
    query = query.replace('"MINLEN"', minl)
    query = query.replace('"MAXLEN"', maxl)
    query = query.replace('"SIMCUT"', cth)
    

    r = requests.get('http://search.rcsb.org/rcsbsearch/v2/query?json=%s' % requests.utils.requote_uri(query))
    j = r.json()

    ids = []
    for result in j["result_set"]:
        ids.append(result["identifier"])
    ids = str(ids).replace(" ","").replace("'",'"')

    graph_query = """
        {
            polymer_entities(entity_ids: %s)
            {
                rcsb_id
                entry {
                rcsb_entry_info {
                    resolution_combined
                }
                }
                entity_poly {
                pdbx_seq_one_letter_code_can
                }
                polymer_entity_instances {
                rcsb_polymer_entity_instance_container_identifiers {
                    auth_asym_id
                }
                }
                rcsb_polymer_entity_container_identifiers {
                entity_id
                entry_id
                }
            }
            }
    """ % ids

    r = requests.get('https://data.rcsb.org/graphql?query=%s' % requests.utils.requote_uri(graph_query))
    j = r.json()

    entities = []
    for entity in j["data"]["polymer_entities"]:
        # PDB ID
        pdb_id = entity["rcsb_polymer_entity_container_identifiers"]["entry_id"]
        # Chain ID
        chain_id = entity["polymer_entity_instances"][0]["rcsb_polymer_entity_instance_container_identifiers"]['auth_asym_id']
        # Sequence
        seq = entity["entity_poly"]['pdbx_seq_one_letter_code_can']
        entities.append((pdb_id, chain_id, seq))

    with open("pdb_query.ids", "w") as file:
        for e in entities:
            file.write(e[0] + ":" + e[1] + "\n")

    print(len(entities), "structures retrieved")
