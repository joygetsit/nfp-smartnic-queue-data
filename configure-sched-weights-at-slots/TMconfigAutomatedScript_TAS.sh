#!/bin/bash

# Date - 8th Feb 2023
# Author - Joydeep Pal
# Description - Traffic Manager Configuration for TAS at defined timestamps, for our experiment.

CT=10
Cycles=2
TAS_Start=2
ST_Slot_start=3
EndTime=$((TAS_Start+$Cycles*CT))

TimingArray=($TAS_Start $EndTime)

#CT_TimingArray=({0..20..4})
#ST_TimingArray=({3..50..10})

SECONDS=0

<< COMMENT

nfp-reg \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}.Rate=0x3fff
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate3.Rate=1
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=0
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate3.Rate=0
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1

# To check the status
time nfp-reg \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.SchedulerEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate{{0..3},144}.

COMMENT

while true
do
if [ $SECONDS -eq ${TimingArray[0]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
watch -n $CT nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff &
sleep $ST_Slot_start
watch -n $CT nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0 &
elif [ $SECONDS -eq ${TimingArray[1]} ];then
killall -9 watch
echo "Done!!"
break
fi
sleep 1
done

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff

reset

<< comment
# Date - 19 Jan 2023
# Author - Joydeep Pal
# Description - Traffic Manager Configuration for our experiment

# We are currently using the first 2 queues out of the 1024 queues.
# TM Scheduler is already enabled
# TM shaper is enabled & TM Shaper '0' is given a BW becuase it handles the first 8 queues and
# TM Shaper '144' is also given a high BW because default is 0 and no packets will pass and queues will get filled up.
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate0.Rate=15 # i.e. x*10Mbps \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144.Rate=0x3fff

# Enable DWRR and assig 0h0n DWRR weights on TM Scheduler '0' which handles the first 8 queues
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=0x1 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0x588040 # =$((2**12))

# After the experiment run the following to remove the above configuration
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=0

#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig{0..2}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight{0..9}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit{0..9}. \

# For enabling DWRR
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=1

nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff

# To initialize all scheduler weights to 0.
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight{0..1023}.Weight=0
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit{0..1023}.Deficit=4000

# For enabling/disabling Strict Priority (SP=1/0)
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.SP0Enable=1
comment
