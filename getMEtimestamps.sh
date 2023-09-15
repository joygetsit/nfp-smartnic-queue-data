#!/bin/bash

# Date - 12 March 2023
# Author - Joydeep Pal
# Description - Get ME continuously for a specific time.

Duration=1
SECONDS=0
echo " " > ME_Timestamp_Continuous.csv

while true
do
if [ $SECONDS -eq $((Duration+5)) ]; then
echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
break
else
echo $(nfp-reg \
mecsr:i32.me0.TimestampLow.CountLower. \
mecsr:i32.me0.TimestampHgh.CountUpper.
) >> ME_Timestamp_Continuous.csv
fi
done

#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMSchedulerReg.SchedulerConfig0. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit{0..3}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Deficit.SchedulerDeficit{8..9}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight{0..3}. \
#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.SchedulerL2Weight.SchedulerWeight{8..9}. \

#xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus{0..1} \ {0,1,2,8} \ {{0..8..8},2} \

#./venv/bin/python3.8 QueueStatusData.py

