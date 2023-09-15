#!/bin/bash

# Author: Joydeep Pal
# Date: 24 Jan 2023
# Description: Broadly, it gets Timestamp data from both Netronome's CSRs
# for a limited time
# Use relevant python script to analyze the performance.

RemoteIP=10.114.64.117
RemotePath=~/Documents/Joy/Joyy/TimestampData
SECONDS=0
echo "col0 col1 col2 col3 col4" > TimestampAllContinuous.csv

while true
do
	if [ $SECONDS -gt 60 ];then
		echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
		break
	else
		echo $(nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.MacGlbAdrMap.MacCsr.MacTimeStampNsec. xpb:Nbi0IsldXpbMap.NbiTopXpbMap.MacGlbAdrMap.MacCsr.MacTimeStampSec.  mecsr:i32.me0.TimestampLow. mecsr:i32.me0.TimestampHgh) `date +%s.%N` >> TimestampAllContinuous.csv
	fi
done
sleep 10
scp zenlab@10.114.64.117:$RemotePath/TimestampAllContinuous2.csv TimestampAllContinuous2.csv
echo Done
