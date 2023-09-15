#!/bin/bash

# Date - 22 Jan 2023
# Author - Joydeep Pal
# Description - Get Queue, Scheduler, Shaper Status continuously for a specific time.

Duration=1
SECONDS=0
echo " " > QueueLevelStatusContinuous22.csv

while true
do
if [ $SECONDS -eq $((Duration+5)) ]; then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
break
else
# echo $(nfp-rtsym _customData) \
# >> QueueLevelStatusContinuous22.csv
nfp-rtsym _customData
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
