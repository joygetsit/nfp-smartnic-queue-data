#!/usr/bin/env python3

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

df = pd.read_csv("TimestampAllContinuous.csv", sep=' ')
df2 = pd.read_csv("TimestampAllContinuous2.csv", sep=' ')
df.drop(index=0, inplace=True)
df.reset_index(drop=True, inplace=True)
df2.drop(index=0, inplace=True)
df2.reset_index(drop=True, inplace=True)

cols = ['col0', 'col1', 'col2', 'col3']
# df11 = pd.DataFrame()
for i in cols:
    df[i] = df[i].str.split('=').str[1]
    df2[i] = df2[i].str.split('=').str[1]

df['ME_High_dec'] = df['col3'].apply(lambda x: int(x, 16))
df['ME_Low_dec'] = df['col2'].apply(lambda x: int(x, 16))
df['Mac_Sec_dec'] = df['col1'].apply(lambda x: int(x, 16))
df['Mac_Nsec_dec'] = df['col0'].apply(lambda x: int(x, 16))
df['Mac_Ts'] = df['Mac_Sec_dec'] + df['Mac_Nsec_dec'] / (10 ** 9)
df['ME_Ts'] = (df['ME_High_dec'] * (2 ** 32) + df['ME_Low_dec']) * 16 / (633 * (10 ** 6))

df['Epoch_Ts_normalize'] = df['col4'].sub(df['col4'][0])
df['ME_Ts_normalize'] = df['ME_Ts'].sub(df['ME_Ts'][0])
df['Mac_Ts_normalize'] = df['Mac_Ts'].sub(df['Mac_Ts'][0])

df['Epoch-ME_normalize'] = df['Epoch_Ts_normalize'] - df['ME_Ts_normalize']
df['Mac-ME_normalize'] = df['Mac_Ts_normalize'] - df['ME_Ts_normalize']


df2['ME_High_dec'] = df2['col3'].apply(lambda x: int(x, 16))
df2['ME_Low_dec'] = df2['col2'].apply(lambda x: int(x, 16))
df2['Mac_Sec_dec'] = df2['col1'].apply(lambda x: int(x, 16))
df2['Mac_Nsec_dec'] = df2['col0'].apply(lambda x: int(x, 16))
df2['Mac_Ts'] = df2['Mac_Sec_dec'] + df2['Mac_Nsec_dec'] / (10 ** 9)
df2['ME_Ts'] = (df2['ME_High_dec'] * (2 ** 32) + df2['ME_Low_dec']) * 16 / (633 * (10 ** 6))

df2['Epoch_Ts_normalize'] = df2['col4'].sub(df2['col4'][0])
df2['ME_Ts_normalize'] = df2['ME_Ts'].sub(df2['ME_Ts'][0])
df2['Mac_Ts_normalize'] = df2['Mac_Ts'].sub(df2['Mac_Ts'][0])

df2['Epoch-ME_normalize'] = df2['Epoch_Ts_normalize'] - df2['ME_Ts_normalize']
df2['Mac-ME_normalize'] = df2['Mac_Ts_normalize'] - df2['ME_Ts_normalize']

''' Simply plottng using below commands give wrong plots 
because of different sampling frequencies. So, first merge properly '''
# df2.plot(y=['Epoch_Ts_normalize1', 'Epoch_Ts_normalize'], use_index=True)

df3 = pd.merge_asof(df, df2, on='ME_Ts_normalize', direction='nearest')
df4 = pd.merge_asof(df2, df, on='ME_Ts_normalize', direction='nearest')

df.plot(y=['Epoch-ME_normalize', 'Mac-ME_normalize'], use_index=True)
df.plot(x='ME_Ts_normalize', y=['Epoch-ME_normalize', 'Mac-ME_normalize'])
df.plot(y=['Epoch_Ts_normalize', 'ME_Ts_normalize', 'Mac_Ts_normalize'], use_index=True)
df2.plot(y=['Epoch-ME_normalize', 'Mac-ME_normalize'], use_index=True)
df2.plot(x='ME_Ts_normalize', y=['Epoch-ME_normalize', 'Mac-ME_normalize'])
df2.plot(y=['Epoch_Ts_normalize', 'ME_Ts_normalize', 'Mac_Ts_normalize'], use_index=True)

df3.plot(x='ME_Ts_normalize', y=['Epoch-ME_normalize_x', 'Mac-ME_normalize_x', 'Epoch-ME_normalize_y', 'Mac-ME_normalize_y'])
df4.plot(x='ME_Ts_normalize', y=['Epoch-ME_normalize_x', 'Mac-ME_normalize_x', 'Epoch-ME_normalize_y', 'Mac-ME_normalize_y'])

plt.show()
