#!/bin/bash

# Date - 27 Jan 2023
# Author - Joydeep Pal
# Description - Traffic Manager Configuration at defined timestamps, for our experiment.

Duration=120
Interval=$((Duration/5))
TimingArray=({30..300..30})
#TimingArray=(10 40 15 30 80 60 50 52 60 62)
#TimingArray=($(for ((i=$Interval;i<=$Duration;i+=$Interval)); do echo "${i}"; echo "$((i+2))" ; done))
WeightArray=(100 100 40)
SECONDS=0

while true
do
if [ $SECONDS -eq ${TimingArray[0]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Let's get TM Shaper initialized and then enabled"
echo "Assign TM Shaper 144's (That 1 Lo shaper) weight to highest value"
echo "Assign TM Shaper 0's (1st L2 Shaper) weight to 150Mbps"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate0.Rate=15 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144.Rate=0x3fff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=1
elif [ $SECONDS -eq ${TimingArray[1]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Assign Strict Priority to Scheduler 0"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.SP0Enable=1
elif [ $SECONDS -eq ${TimingArray[2]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Disable Strict Priority to Scheduler 0"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.SP0Enable=0
elif [ $SECONDS -eq ${TimingArray[3]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Enable DWRR and assign DWRR weights on TM Scheduler '0' which handles the first 8 queues"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=1 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0x0 # =$((2**12))
elif [ $SECONDS -eq ${TimingArray[4]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Assign different DWRR weights on TM Scheduler '0'"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff
elif [ $SECONDS -eq ${TimingArray[5]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Assign different DWRR weights on TM Scheduler '0'"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0x7fffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff
elif [ $SECONDS -eq ${TimingArray[6]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Assign different DWRR weights on TM Scheduler '0'"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0x7fffff
elif [ $SECONDS -eq ${TimingArray[7]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Disable DWRR on Scheduler 0"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0xffffff
elif [ $SECONDS -eq ${TimingArray[8]} ];then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
echo "Disable TM Shapers"
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=0
elif [ $SECONDS -eq ${TimingArray[9]} ];then
echo "Done!!"
break
fi
sleep 1
done

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

# Enable DWRR and assign DWRR weights on TM Scheduler '0' which handles the first 8 queues
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=0x1 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0.Weight=0xffffff \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1.Weight=0x588040 # =$((2**12))

# After the experiment run the following to remove the above configuration
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.DWRREnable=0 \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable=0

# To check the status
time nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.SchedulerEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TrafficManagerReg.TrafficManagerConfig.ShaperEnable \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit1. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit8. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate0. \
xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMShaperReg.ShaperRate144.

# For enabling/disabling Strict Priority (SP=1/0)
nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0.SP0Enable=1
comment
