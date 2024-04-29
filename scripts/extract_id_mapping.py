import json

j = json.loads(open("id_mapping_results.json").read())

print(len(j["results"]), "matches found")

with open("sets/to_remove.ids", "w") as file:
    for res in j["results"]:
        id = "sp|"
        id += res["to"]["primaryAccession"] + "|" + res["to"]["uniProtkbId"]
        file.write(id + "\n")