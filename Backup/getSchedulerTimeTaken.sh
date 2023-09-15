
SECONDS=0
echo "col0 col1 col2 col3 col4 col5 col6 col7 col8 col9" > SchedulerConfigTimeTakenContinous.csv
while true
do
	if [ $SECONDS -gt 20 ];then
		echo "Elapsed Time (using \$SECONDS): $SECONDS seconds"
		break
	else
		#time nfp-reg xpb:Nbi0IsldXpbMap.NbiTopXpbMap.TrafficManager.TMQueueReg.QueueStatus0. >> QueueLevelStatusContinous.csv
		# time QueueStatus1,2,8
		echo $(nfp-rtsym _ts_store) >> SchedulerConfigTimeTakenContinous.csv
	fi
done


