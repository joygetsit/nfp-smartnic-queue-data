#!/usr/bin/env python3

import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
matplotlib.use('Qt5Agg')

df = pd.read_csv("QueueLevelStatusContinuous.csv", header=None, sep='\s+')
# df.drop(index=0, inplace=True)
# df.reset_index(drop=True, inplace=True)

ColumnNames = [str(df[column][0].split('=')[0].split('.')[-2] + '_' +
                   df[column][0].split('=')[0].split('.')[-1]) for column in df]
# df[i][0].split('=')[0].split('.')[-2] # To check one cell instead of whole column
df = df.apply(lambda x: x.str.split('=').str[1])
df.columns = ColumnNames
df.rename(columns={'MacTimeStampNsec_MacTimeStampNsec': 'MacTimeStampNsec',
                   'MacTimeStampSec_MacTimeStampSec': 'MacTimeStampSec'}, inplace=True)
df2 = df.copy()
for column in df2:
    df2[column] = df2[column].apply(lambda x: int(x, 16))

df2.columns += '_D'

df2['Mac_Ts'] = df2['MacTimeStampSec_D'] + df2['MacTimeStampNsec_D'] / (10 ** 9)
df2['Mac_Ts'] = pd.to_timedelta(df2['Mac_Ts'], unit='s')

TimeSlope = (df2.Mac_Ts.max() - df2.Mac_Ts.min()) / (len(df2) - 1)
df2['Mac_Ts_normalize'] = df2['Mac_Ts'].sub(df2['Mac_Ts'][0])
# df2['Mac_Ts_deviation'] = df2['Mac_Ts_normalize'] - TimeSlope*df2.index
# df2['Mac_Ts_deviation'].plot()
df2['Mac_Ts_diff'] = df2['Mac_Ts'].diff()
# df2.plot(x='Mac_Ts', y='Mac_Ts_diff', kind='scatter')

fig, ax = plt.subplots(8, 1, sharex='col', sharey='row')
df2['TrafficManagerConfig_SchedulerEnable_D'].plot(ax=ax[0], legend=True)
df2['TrafficManagerConfig_ShaperEnable_D'].plot(ax=ax[1], legend=True)
df2['SchedulerConfig0_DWRREnable_D'].plot(ax=ax[2], legend=True)
df2['SchedulerConfig0_SP0Enable_D'].plot(ax=ax[3], legend=True)
df2['SchedulerConfig0_SP1Enable_D'].plot(ax=ax[4], legend=True)
df2['QueueConfig0_DropEnable_D'].plot(ax=ax[5], legend=True)
df2['QueueConfig1_DropEnable_D'].plot(ax=ax[6], legend=True)
df2['QueueConfig8_DropEnable_D'].plot(ax=ax[7], legend=True)

fig1, ax1 = plt.subplots(4, 1, sharex='col')
df2['SchedulerWeight0_Weight_D'].plot(ax=ax1[0], legend=True)
df2['SchedulerWeight1_Weight_D'].plot(ax=ax1[1], legend=True)
df2['ShaperRate0_Rate_D'].plot(ax=ax1[2], legend=True)
df2['ShaperRate144_Rate_D'].plot(ax=ax1[3], legend=True)

fig2, ax2 = plt.subplots(3, 4, sharex='col')
df2['QueueDropCount0_DropCount_D'].plot(ax=ax2[0, 0], legend=True)
df2['QueueDropCount1_DropCount_D'].plot(ax=ax2[1, 0], legend=True)
df2['QueueDropCount8_DropCount_D'].plot(ax=ax2[2, 0], legend=True)
df2['QueueDropCountClear0_DropCountClear_D'].plot(ax=ax2[0, 1], legend=True)
df2['QueueDropCountClear1_DropCountClear_D'].plot(ax=ax2[1, 1], legend=True)
df2['QueueDropCountClear8_DropCountClear_D'].plot(ax=ax2[2, 1], legend=True)
df2['QueueStatus0_QueueFull_D'].plot(ax=ax2[0, 2], legend=True)
df2['QueueStatus1_QueueFull_D'].plot(ax=ax2[1, 2], legend=True)
df2['QueueStatus8_QueueFull_D'].plot(ax=ax2[2, 2], legend=True)
df2['QueueConfig0_QueueSize_D'].plot(ax=ax2[0, 3], legend=True)
df2['QueueConfig1_QueueSize_D'].plot(ax=ax2[1, 3], legend=True)
df2['QueueConfig8_QueueSize_D'].plot(ax=ax2[2, 3], legend=True)

fig3, ax3 = plt.subplots(3, 1, sharex='col')
df2['QueueStatus0_QueueLevel_D'].plot(ax=ax3[0], legend=True)
df2['QueueStatus1_QueueLevel_D'].plot(ax=ax3[1], legend=True)
df2['QueueStatus8_QueueLevel_D'].plot(ax=ax3[2], legend=True)

fig4, ax4 = plt.subplots(3, 1, sharex='col')
df2['SchedulerDeficit0_Deficit_D'].plot(ax=ax4[0], legend=True)
df2['SchedulerDeficit1_Deficit_D'].plot(ax=ax4[1], legend=True)
df2['SchedulerDeficit8_Deficit_D'].plot(ax=ax4[2], legend=True)

plt.show()

# df.plot(y=['4decimal', '10decimal', '16decimal'], use_index=True)
