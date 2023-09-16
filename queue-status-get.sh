#!/bin/bash

# Date:	22-Jan-2023
# Author:	Joydeep Pal
# Description:	Get Queue, Scheduler, Shaper Status continuously for a specific time.

source ~/Documents/tsn-project/configuration-variables.sh
LOGFILE=${PROJECT_FOLDER}/data-pcap-csv/csv-temp/QueueLevelStatusContinuous22.csv
truncate -s 0 $LOGFILE
DURATION=10
SECONDS=0

while true
do
if [ $SECONDS -ge $DURATION ]; then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
sleep 1
echo 'Data measurement complete'
break
else
{
nfp-rtsym _customData
} >> $LOGFILE
# echo $(nfp-rtsym _customData) \
# >> QueueLevelStatusContinuous22.csv

#echo $(nfp-reg \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.MacGlbAdrMap.MacCsr.MacTimeStampNsec. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.MacGlbAdrMap.MacCsr.MacTimeStampSec. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.SchedulerEnable. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCount{0..31..8}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCountClear{0..31..8} \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus{0..31..8} \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig{0..31..8}.DropEnable \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig{0..31..8}.QueueSize \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperStatus{{0..3},144}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperMaxOvershoot{{0..3},144}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}. \
#) >> QueueLevelStatusContinuous.csv

fi
done

#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit{0..3}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit{8..9}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight{0..3}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight{8..9}. \

#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus{0..1} \ {0,1,2,8} \ {{0..8..8},2} \

#./venv/bin/python3.8 QueueStatusData.py

<< COMMENT
# QueueSize: 8 means queue size of 256
# 4 means 16

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig0.QueueSize=0x4 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig1.QueueSize=0x3 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig8.QueueSize=0x4

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig0.QueueSize \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig1.QueueSize \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig8.QueueSize

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig0.DropEnable=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig1.DropEnable=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig8.DropEnable=0

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig0.DropEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig1.DropEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig8.DropEnable

COMMENT
