#!/bin/bash

# Date - 8th Feb 2023
# Author - Joydeep Pal
# Description - Traffic Manager Configuration at defined timestamps, for our experiment.

CT=10
STSlotStarts=3
EndTime=30

Duration=60
Interval=$((Duration/5))
TimingArray=(100 2000)

CT_TimingArray=({0..20..4})
ST_TimingArray=({3..50..10})

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
watch -n $CT nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff &
sleep $STSlotStarts
watch -n $CT nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0 &
elif [ $SECONDS -eq ${TimingArray[1]} ];then
killall -9 watch
#nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff
echo "Done!!"
break
fi
sleep 1
done

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff
