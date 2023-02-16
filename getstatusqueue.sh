#!/bin/bash

# Date - 22 Jan 2023
# Author - Joydeep Pal
# Description - Get Queue, Scheduler, Shaper Status continuously for a specific time.

#Duration
SECONDS=0
echo " " > QueueLevelStatusContinuous.csv

while true
do
if [ $SECONDS -eq 30 ]; then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
break
else
echo $(nfp-reg \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.MacGlbAdrMap.MacCsr.MacTimeStampNsec. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.MacGlbAdrMap.MacCsr.MacTimeStampSec. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCount0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCountClear0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig0.DropEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig0.QueueSize \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCount1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCountClear1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig1.DropEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig1.QueueSize \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCount8. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueDropCountClear8. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus8. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig8.DropEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueConfig8.QueueSize \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.SchedulerEnable. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit8. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144. \
) >> QueueLevelStatusContinuous.csv
fi
done

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