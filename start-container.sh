#!/bin/bash

# the default node number is 3
N=${1:-3}


# start spark master container
sudo docker rm -f spark-master &> /dev/null
echo "start spark-master container..."
sudo docker run -itd \
                --net=spark \
                -p 50070:50070 \   ## HDFS
                -p 8088:8088 \     ## Yarn
                -p 8080:8080 \     ## Spark
                --name spark-master \
                --hostname spark-master \
                registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 &> /dev/null


# start hadoop slave container
i=1
while [[ ${i} -lt ${N} ]]
do
	sudo docker rm -f spark-slave$i &> /dev/null
	echo "start spark-slave$i container..."
	sudo docker run -itd \
	                --net=spark \
	                --name spark-slave$i \
	                --hostname spark-slave$i \
	                registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into spark master container
sudo docker exec -it spark-master bash
