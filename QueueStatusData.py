#!/usr/bin/env python3

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from cycler import cycler
import seaborn as sns
import numpy as np
import pandas as pd
import datetime as dt
matplotlib.use('Qt5Agg')

ST_BW = '5' + 'M'
BE_BW = '5' + 'M'
LinkBW = 'Low'  # 'High'  # 'Low'
TAS = 'on'  # 'on'
Duration = 50
print(dt.datetime.now())
FileDate = dt.datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
FigureNameExtra = '../TempFigures/Exp_Queue_' + FileDate + '.png'

FigTitle = 'ST' + ST_BW + '_BE' + BE_BW + '_LinkBW' + LinkBW + '_TAS' + TAS + '_Duration_' + str(Duration) +'s'
# 'TAS_NoData_DWRRoff | Duration - 10s'  # 'TAS_Data_S50M_B5M_HighLinkBW | Duration - 15s'
FigureNameDeficit = '../TempFigures/DeficitChanges/DWRRon/' + FigTitle + '_Deficit_' + FileDate + '.png'
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
# for columns in ['TrafficManagerConfig_SchedulerEnable', 'TrafficManagerConfig_ShaperEnable',
#                 'SchedulerConfig0_SP1Enable', 'SchedulerConfig0_SP0Enable', 'SchedulerConfig0_DWRREnable',
#                 'QueueStatus0_QueueFull', 'QueueStatus1_QueueFull', 'QueueStatus8_QueueFull',
#                 'QueueConfig0_DropEnable', 'QueueConfig1_DropEnable', 'QueueConfig8_DropEnable',
#                 'QueueConfig0_QueueSize', 'QueueConfig1_QueueSize', 'QueueConfig8_QueueSize']:
#     df2[columns] = df2[columns].astype(np.int8)
# for columns in ['TrafficManagerConfig_SchedulerEnable', 'TrafficManagerConfig_ShaperEnable',
#                 'SchedulerConfig0_SP1Enable', 'SchedulerConfig0_SP0Enable', 'SchedulerConfig0_DWRREnable',
#                 'QueueStatus0_QueueFull', 'QueueStatus1_QueueFull', 'QueueStatus8_QueueFull',
#                 'QueueConfig0_DropEnable', 'QueueConfig1_DropEnable', 'QueueConfig8_DropEnable',
#                 'QueueConfig0_QueueSize', 'QueueConfig1_QueueSize', 'QueueConfig8_QueueSize']:
#     df2[columns] = df2[columns].astype(np.int8)

# df2.columns += '_D'  # to identify as decimal
# df2['Mac_Ts'] = df2['MacTimeStampSec_D'] + df2['MacTimeStampNsec_D'] / (10 ** 9)
df2['Mac_Ts'] = df2['MacTimeStampSec'] + df2['MacTimeStampNsec'] / (10 ** 9)
df2['Mac_Ts'] = pd.to_datetime(df2['Mac_Ts'], unit='s')

TimeSlope = (df2.Mac_Ts.max() - df2.Mac_Ts.min()) / (len(df2) - 1)
df2['Mac_Ts_normalize'] = df2['Mac_Ts'].sub(df2['Mac_Ts'][0])
df2['Mac_Ts_diff'] = df2['Mac_Ts'].diff()

TableValues = pd.DataFrame(columns=['Date', 'Name', 'SingleValue', 'Value'])

fig3, ax3 = plt.subplots(3, 1, tight_layout=True, sharex='col')
df2.plot(x='Mac_Ts', y=['QueueStatus0_QueueLevel'], ax=ax3[0])
df2.plot(x='Mac_Ts', y=['QueueStatus8_QueueLevel'], ax=ax3[0])
df2.plot(x='Mac_Ts', y=['QueueStatus16_QueueLevel'], ax=ax3[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['QueueStatus24_QueueLevel'], ax=ax3[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['ShaperStatus0_Level'], ax=ax3[1])
df2.plot(x='Mac_Ts', y=['ShaperStatus1_Level'], ax=ax3[1])
df2.plot(x='Mac_Ts', y=['ShaperStatus2_Level'], ax=ax3[2])
df2.plot(x='Mac_Ts', y=['ShaperStatus3_Level'], ax=ax3[2])
df2.plot(x='Mac_Ts', y=['ShaperStatus144_Level'], ax=ax3[2], secondary_y=True)
# df2.plot(x='Mac_Ts', y=['SchedulerDeficit0_Deficit'], ax=ax3[1])
# df2.plot(x='Mac_Ts', y=['SchedulerDeficit1_Deficit'], ax=ax3[1])
# df2.plot(x='Mac_Ts', y=['SchedulerWeight0_Weight'], ax=ax3[2])
# df2.plot(x='Mac_Ts', y=['SchedulerWeight1_Weight'], ax=ax3[2])
locator = mdates.SecondLocator(interval=5)
# locator = mdates.AutoDateLocator(minticks=3, maxticks=10)
# locator = mdates.MicrosecondLocator(interval=100000)
formatter = mdates.ConciseDateFormatter(locator)
ax3[2].xaxis.set_major_locator(locator)
ax3[2].xaxis.set_major_formatter(formatter)
ax3[2].xaxis.grid()
plt.title(FigTitle)
# plt.title('Slot - 40ms,60ms | Duration - 4s')
figure = plt.gcf()
figure.set_size_inches(18, 9)
plt.savefig(FigureNameDeficit, bbox_inches='tight')


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

TableValues.to_csv('TMData.csv', mode='a')

fig2, ax2 = plt.subplots(4, 1, tight_layout=True, sharex='col')
df2.plot(x='Mac_Ts', y=['QueueDropCount0_DropCount'], ax=ax2[0])
df2.plot(x='Mac_Ts', y=['QueueDropCount1_DropCount'], ax=ax2[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['QueueDropCount8_DropCount'], ax=ax2[0])
df2.plot(x='Mac_Ts', y=['QueueStatus8_QueueLevel'], ax=ax2[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['QueueDropCountClear0_DropCountClear'], ax=ax2[0])
df2.plot(x='Mac_Ts', y=['QueueDropCountClear1_DropCountClear'], ax=ax2[0], secondary_y=True)
df2.plot(x='Mac_Ts', y=['QueueDropCountClear8_DropCountClear'], ax=ax2[0])
df2.plot(x='Mac_Ts', y=['QueueStatus0_QueueFull'], ax=ax2[1])
df2.plot(x='Mac_Ts', y=['QueueStatus1_QueueFull'], ax=ax2[1], secondary_y=True)
df2.plot(x='Mac_Ts', y=['QueueStatus8_QueueFull'], ax=ax2[1])
df2.plot(x='Mac_Ts', y=['SchedulerWeight2_Weight'], ax=ax2[2])
df2.plot(x='Mac_Ts', y=['SchedulerWeight3_Weight'], ax=ax2[2])
df2.plot(x='Mac_Ts', y=['SchedulerWeight8_Weight'], ax=ax2[2], secondary_y=True)
df2.plot(x='Mac_Ts', y=['SchedulerWeight9_Weight'], ax=ax2[2], secondary_y=True)
df2.plot(x='Mac_Ts', y=['SchedulerDeficit2_Deficit'], ax=ax2[3])
df2.plot(x='Mac_Ts', y=['SchedulerDeficit3_Deficit'], ax=ax2[3])
df2.plot(x='Mac_Ts', y=['SchedulerDeficit8_Deficit'], ax=ax2[3], secondary_y=True)
df2.plot(x='Mac_Ts', y=['SchedulerDeficit9_Deficit'], ax=ax2[3], secondary_y=True)
ax2[2].xaxis.set_major_locator(locator)
ax2[2].xaxis.set_major_formatter(formatter)
figure = plt.gcf()
figure.set_size_inches(18, 9)
plt.savefig(FigureNameExtra)

# fig4, ax4 = plt.subplots(3, 1, sharex='col')
# df2['SchedulerDeficit0_Deficit'].plot(ax=ax4[0])
# df2['SchedulerDeficit1_Deficit'].plot(ax=ax4[1])
# df2['SchedulerDeficit8_Deficit'].plot(ax=ax4[2])
# df.plot(y=['4decimal', '10decimal', '16decimal'], use_index=True)


plt.show()
