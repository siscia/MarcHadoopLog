#!/bin/bash

replication="$1"
blocksize="$2"
dimension="$3"

HADOOP_DIR="/opt/hadoop-3.0.0-SNAPSHOT/share/hadoop/mapreduce"

dir=$(printf "%s_%s_%s" $replication $blocksize $dimension)

hadoop \
	jar $HADOOP_DIR/hadoop-mapreduce-examples-3.0.0-SNAPSHOT.jar \
	teragen \
	-Ddfs.blocksize="$blocksize" \
	-Ddfs.replication="$replication" \
	-Dmapred.map.tasks=50 \
	"$dimension" \
	$dir | tee $(printf "/root/marc_log/teragen/%s_%s_%s.txt" $replication $blocksize $dimension)

sleep 30

log_file=$(printf "marc_log/%s_%s_%s.csv" $replication $blocksize $dimension)

ssh root@clovertown00 ./dstat-daemon.sh start $log_file
ssh root@clovertown01 ./dstat-daemon.sh start $log_file
ssh root@clovertown02 ./dstat-daemon.sh start $log_file
ssh root@clovertown03 ./dstat-daemon.sh start $log_file

sleep 30

result_dir=$(printf "%s/result/" $dir)

hadoop \
	jar $HADOOP_DIR/hadoop-mapreduce-examples-3.0.0-SNAPSHOT.jar \
	terasort \
	-Dmapred.reduce.tasks=12 \
	$dir \
	$result_dir | tee $(printf "/root/marc_log/terasort/%s_%s_%s.txt" $replication $blocksize $dimension)

sleep 30

ssh root@clovertown00 ./dstat-daemon.sh stop
ssh root@clovertown01 ./dstat-daemon.sh stop
ssh root@clovertown02 ./dstat-daemon.sh stop
ssh root@clovertown03 ./dstat-daemon.sh stop

hadoop fs -rm -R $result_dir
hadoop fs -rm -R $dir

sleep 180
