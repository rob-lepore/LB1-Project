import requests
import subprocess

if __name__ == "__main__":

    with open("pdb_query.ids") as idsfile:
        for line in idsfile:
            id, chain = line.rstrip().split(":")
            url = "https://files.rcsb.org/download/" + id + ".pdb"
            #print(url)
            res = requests.get(url)
            with open("pdb_files/"+id+"_"+chain+"_temp.pdb", "wb") as pdbfile:
                pdbfile.write(res.content)

            subprocess.run('egrep "^ATOM.{17}%s" pdb_files/%s_temp.pdb > pdb_files/%s.pdb' % (chain, id+"_"+chain, id+"_"+chain), shell=True)

