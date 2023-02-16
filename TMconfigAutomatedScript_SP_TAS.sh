#!/bin/bash

# Date - 27 Jan 2023
# Author - Joydeep Pal
# Description - Traffic Manager Configuration at defined timestamps, for our experiment.

CT=10
STSlotStarts=3
#EndTime=30
TimingArray=(10 20 25 30 60 70)

SECONDS=0

<< COMMENT
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate0.Rate=15 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144.Rate=0x3fff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=1

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff
COMMENT

while true
do
if [ $SECONDS -eq ${TimingArray[0]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.SP0Enable=1
elif [ $SECONDS -eq ${TimingArray[1]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.SP0Enable=0
elif [ $SECONDS -eq ${TimingArray[2]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=1
elif [ $SECONDS -eq ${TimingArray[3]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
watch -n $CT nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff &
sleep $STSlotStarts
watch -n $CT nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0 &
elif [ $SECONDS -eq ${TimingArray[4]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
killall -9 watch
sleep 1
elif [ $SECONDS -eq ${TimingArray[5]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=0
sleep 1
break
fi
echo "Hey2"
sleep 1
done
