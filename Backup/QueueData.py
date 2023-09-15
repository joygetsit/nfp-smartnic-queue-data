#!/usr/bin/env python3

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

df = pd.read_csv("QueueLevelStatusContinous.csv", sep=' ')

df["Time1"] = df.apply(lambda x: int(x["col1"],16) * 2**32 + int(x["col2"],16), axis=1)
df["Time2"] = df.apply(lambda x: int(x["col3"],16) * 2**32 + int(x["col4"],16), axis=1)
df["Time3"] = df.apply(lambda x: int(x["col6"],16) * 2**32 + int(x["col7"],16), axis=1)
df["Time4"] = df.apply(lambda x: int(x["col8"],16) * 2**32 + int(x["col9"],16), axis=1)
df['Func_Time_taken']=df.apply(lambda x: x['Time3'] - x['Time2'], axis=1)
df['Time_from_last_capture']=df.apply(lambda x: x['Time1'] - x['Time2'], axis=1)
df["Index"]=df.index
sns.relplot(data=df, x='Index', y='Func_Time_taken')
sns.relplot(data=df, x='Index', y='Time_from_last_capture')
sns.relplot(data=df, x='Index', y='Time4')
plt.show()
