import pandas as pd
import numpy as np
import sys

def get_CM(file, th):
    df_in = pd.read_csv(file,sep="\t", names=["ID","E-value", "label"])

    df = pd.DataFrame()
    df["pred"] = df_in["E-value"].map(lambda a: 1 if a < th else 0)
    df["real"] = df_in["label"]
    CM = pd.DataFrame(np.zeros((2,2), dtype=int), columns=["pred_pos", "pred_neg"], index=["actu_pos", "actu_neg"])

    CM["pred_pos"]["actu_pos"] = ((df["pred"] == 1) & (df["real"] == 1)).sum()
    CM["pred_neg"]["actu_pos"] = ((df["pred"] == 0) & (df["real"] == 1)).sum()
    CM["pred_pos"]["actu_neg"] = ((df["pred"] == 1) & (df["real"] == 0)).sum()
    CM["pred_neg"]["actu_neg"] = ((df["pred"] == 0) & (df["real"] == 0)).sum()


    print("False negatives:\n",df_in[(df["pred"] == 0) & (df["real"] == 1)], file=open("results/wrong_predictions.txt", "w"))
    print("\nFalse positives:\n",df_in[(df["pred"] == 1) & (df["real"] == 0)], file=open("results/wrong_predictions.txt", "a"))
    
    return CM

def get_values(CM):
    return CM["pred_pos"]["actu_pos"], CM["pred_pos"]["actu_neg"], CM["pred_neg"]["actu_neg"], CM["pred_neg"]["actu_pos"]

def MCC(CM):
    TP, FP, TN, FN = get_values(CM)
    return (TP * TN - FP * FN) / np.sqrt( (TP+FP)*(TP+FN)*(TN+FP)*(TN+FN) )

def F1_score(CM):
    TP, FP, TN, FN = get_values(CM)
    return 2*TP / (2*TP + FP + FN)

def recall(CM):
    TP, FP, TN, FN = get_values(CM)
    return TP / (TP+FN)

if __name__ == "__main__":
    filename = sys.argv[1]
    th = float(sys.argv[2])
    CM = get_CM(filename, th)
    print("\n\nConfusion matrix:\n",CM, file=open("results/wrong_predictions.txt", "a"))
    p = MCC(CM)
    print(f"{th} {p}")