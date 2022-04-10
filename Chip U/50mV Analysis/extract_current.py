import pandas as pd
import os

for filename in os.listdir("C:/Users/labmin/Desktop/Joshua/Clampfit2/Chip U/50mV Analysis"):
    if filename.endswith("EXPORT.csv"):
        df = pd.read_csv(filename, header=None)
        current = df.iloc[:,1] * 10 ** 9
        current.to_csv(filename[:-4] + "_current.csv", index=False, header=False)
        print("finished one csv")

print("done")