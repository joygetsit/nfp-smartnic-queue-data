#!/home/zenlab/Documents/venv/bin/python3

# Author:       Joydeep Pal
# Date:         16-Feb-2023
# Description:  Plots latency for ST snd BE flows

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from cycler import cycler
import seaborn as sns
import numpy as np
import pandas as pd
import datetime as dt

Plotting = "Subplots" # "Subplots"  # "Separate"
flierprops = dict(marker='o', markersize=1)  # Define outlier properties of boxplots
sns.set_theme(style='white', context='notebook',
              font_scale=0.75, rc={'figure.figsize': (16, 9)})

print(dt.datetime.now())
FileDate = dt.datetime.now().strftime("%Y_%m_%d_%H")

LOGFOLDER = '/media/joy/TeraByte/tsn-project-backup/data-pcap-csv/csv-temp'
df = pd.read_csv(f'{LOGFOLDER}/nfp-queue-status/QueueLevelStatusContinuous.csv', header=None, sep='\s+')
SUMMARYLOG = f'{LOGFOLDER}/nfp-queue-status/TMData.csv'
# 'TAS_NoData_DWRRoff | Duration - 10s'  # 'TAS_Data_S50M_B5M_HighLinkBW | Duration - 15s'
# FigureNameDeficit = '../TempFigures/DeficitChanges/DWRRon/' + FigTitle + '_Deficit_' + FileDate + '.png'
# df.drop(index=0, inplace=True)
# df.reset_index(drop=True, inplace=True)

ColumnNames = [str(df[column][0].split('=')[0].split('.')[-2] + '_' +
                   df[column][0].split('=')[0].split('.')[-1]) for column in df]
df = df.apply(lambda x: x.str.split('=').str[1])
df.columns = ColumnNames
df.rename(columns={'MacTimeStampNsec_MacTimeStampNsec': 'MacTimeStampNsec',
                   'MacTimeStampSec_MacTimeStampSec': 'MacTimeStampSec'}, inplace=True)

df2 = df.applymap(lambda x: int(x, 16))
df2['Mac_Ts'] = df2['MacTimeStampSec'] + df2['MacTimeStampNsec'] / (10 ** 9)
df2['Mac_Ts'] = pd.to_datetime(df2['Mac_Ts'], unit='s')

TimeSlope = (df2.Mac_Ts.max() - df2.Mac_Ts.min()) / (len(df2) - 1)
df2['Mac_Ts_normalize'] = df2['Mac_Ts'].sub(df2['Mac_Ts'][0])
df2['Mac_Ts_diff'] = df2['Mac_Ts'].diff()

TableValues = pd.DataFrame(columns=['Date', 'Name', 'SingleValue', 'Value'])

fig1, ax1 = plt.subplots(3, 1, tight_layout=True, sharex='col')
df2.plot(x='Mac_Ts', y=['QueueStatus0_QueueLevel'], ax=ax1[0])
df2.plot(x='Mac_Ts', y=['QueueStatus8_QueueLevel'], ax=ax1[0])
df2.plot(x='Mac_Ts', y=['QueueStatus16_QueueLevel'], ax=ax1[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['QueueStatus24_QueueLevel'], ax=ax1[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['ShaperStatus0_Level'], ax=ax1[1])
df2.plot(x='Mac_Ts', y=['ShaperStatus1_Level'], ax=ax1[1])
df2.plot(x='Mac_Ts', y=['ShaperStatus2_Level'], ax=ax1[2])
df2.plot(x='Mac_Ts', y=['ShaperStatus3_Level'], ax=ax1[2])
df2.plot(x='Mac_Ts', y=['ShaperStatus144_Level'], ax=ax1[2], secondary_y=True)
# df2.plot(x='Mac_Ts', y=['SchedulerDeficit0_Deficit'], ax=ax1[1])
# df2.plot(x='Mac_Ts', y=['SchedulerDeficit1_Deficit'], ax=ax1[1])
# df2.plot(x='Mac_Ts', y=['SchedulerWeight0_Weight'], ax=ax1[2])
# df2.plot(x='Mac_Ts', y=['SchedulerWeight1_Weight'], ax=ax1[2])
locator = mdates.SecondLocator(interval=5)
# locator = mdates.AutoDateLocator(minticks=3, maxticks=10)
# locator = mdates.MicrosecondLocator(interval=100000)
formatter = mdates.ConciseDateFormatter(locator)
ax1[2].xaxis.set_major_locator(locator)
ax1[2].xaxis.set_major_formatter(formatter)
ax1[2].xaxis.grid()
# plt.title('Slot - 40ms,60ms | Duration - 4s')
figure = plt.gcf()
figure.set_size_inches(18, 9)
# plt.savefig(FigureNameDeficit, bbox_inches='tight')


default_cycler = (cycler(color=list('rgbyb')) +
                  cycler(linestyle=['-', '--', ':', '-.', '-']) +
                  cycler(linewidth=[5, 4, 3, 2, 1]))
plt.rc('axes', prop_cycle=default_cycler)

# fig, ax = plt.subplots(2, 1, tight_layout=True, sharex='col', sharey='row')
# for col in ['TrafficManagerConfig_SchedulerEnable', 'TrafficManagerConfig_ShaperEnable',
#             'SchedulerConfig0_DWRREnable', 'SchedulerConfig0_SP0Enable', 'SchedulerConfig0_SP1Enable',
#             'QueueConfig0_DropEnable', 'QueueConfig1_DropEnable', 'QueueConfig1_DropEnable',
#             'ShaperRate0_Rate', 'ShaperRate144_Rate',
#             'QueueConfig0_QueueSize', 'QueueConfig1_QueueSize', 'QueueConfig8_QueueSize']:
for col in ['TrafficManagerConfig_SchedulerEnable', 'TrafficManagerConfig_ShaperEnable',
            'ShaperStatus0_ShaperOpen', 'ShaperStatus1_ShaperOpen', 'ShaperStatus2_ShaperOpen',
            'ShaperStatus3_ShaperOpen', 'ShaperStatus144_ShaperOpen',
            'ShaperMaxOvershoot0_MaxOvershoot', 'ShaperMaxOvershoot1_MaxOvershoot', 'ShaperMaxOvershoot2_MaxOvershoot',
            'ShaperMaxOvershoot3_MaxOvershoot', 'ShaperMaxOvershoot144_MaxOvershoot',
            'ShaperRate0_Rate', 'ShaperRate1_Rate', 'ShaperRate2_Rate', 'ShaperRate3_Rate', 'ShaperRate144_Rate',
            'QueueStatus0_QueueFull', 'QueueStatus8_QueueFull',
            'QueueStatus16_QueueFull', 'QueueStatus24_QueueFull',
            'QueueConfig0_DropEnable', 'QueueConfig8_DropEnable', 'QueueConfig16_DropEnable',
            'QueueConfig24_DropEnable', 'QueueConfig0_QueueSize',
            'QueueConfig8_QueueSize', 'QueueConfig16_QueueSize', 'QueueConfig24_QueueSize']:
    if df2[col].value_counts().size == 1:
        list_row = [FileDate, col, True, df2[col].value_counts().index[0]]
        TableValues.loc[len(TableValues)] = list_row
    else:
        list_row = [FileDate, col, False, df2[col].value_counts().index[0]]
        TableValues.loc[len(TableValues)] = list_row

TableValues.to_csv(SUMMARYLOG, mode='a')

fig2, ax2 = plt.subplots(2, 1, tight_layout=True, sharex='col')
df2.plot(x=df2.columns[48], y=df2.columns[4], ax=ax2[0])
df2.plot(x=df2.columns[48], y=df2.columns[5], ax=ax2[0], secondary_y=True)
df2.plot(x=df2.columns[48], y=df2.columns[6], ax=ax2[0])
df2.plot(x=df2.columns[48], y=df2.columns[15], ax=ax2[0], secondary_y=True)
df2.plot(x=df2.columns[48], y=df2.columns[8], ax=ax2[0])
df2.plot(x=df2.columns[48], y=df2.columns[9], ax=ax2[0], secondary_y=True)
df2.plot(x=df2.columns[48], y=df2.columns[10], ax=ax2[0])
df2.plot(x=df2.columns[48], y=df2.columns[12], ax=ax2[1])
df2.plot(x=df2.columns[48], y=df2.columns[14], ax=ax2[1], secondary_y=True)
df2.plot(x=df2.columns[48], y=df2.columns[16], ax=ax2[1])
# df2.plot(x=df2.columns[48], y=['SchedulerWeight2_Weight'], ax=ax2[2])
# df2.plot(x=df2.columns[48], y=['SchedulerWeight3_Weight'], ax=ax2[2])
# df2.plot(x=df2.columns[48], y=['SchedulerWeight8_Weight'], ax=ax2[2], secondary_y=True)
# df2.plot(x=df2.columns[48], y=['SchedulerWeight9_Weight'], ax=ax2[2], secondary_y=True)
# df2.plot(x=df2.columns[48], y=['SchedulerDeficit2_Deficit'], ax=ax2[3])
# df2.plot(x=df2.columns[48], y=['SchedulerDeficit3_Deficit'], ax=ax2[3])
# df2.plot(x=df2.columns[48], y=['SchedulerDeficit8_Deficit'], ax=ax2[3], secondary_y=True)
# df2.plot(x=df2.columns[48], y=['SchedulerDeficit9_Deficit'], ax=ax2[3], secondary_y=True)
ax2[1].xaxis.set_major_locator(locator)
ax2[1].xaxis.set_major_formatter(formatter)
figure = plt.gcf()

plt.show()
