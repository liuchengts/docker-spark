#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start spark-master container..."
sudo docker run -itd \
                --net=spark \
                -p 50070:50070 \
                -p 8088:8088 \
                --name spark-master \
                --hostname hadoop-master \
                registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 &> /dev/null


# start hadoop slave container
i=1
while [[ ${i} -lt ${N} ]]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start spark-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name spark-slave$i \
	                --hostname hadoop-slave$i \
	                registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it spark-master bash