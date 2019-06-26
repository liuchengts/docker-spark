#!/bin/bash

# N is the node number of hadoop cluster
N=$1

if [[ $# = 0 ]]
then
	echo "Please specify the node number of spark cluster!"
	exit 1
fi

# change slaves file
i=1
rm docker-config/hadoop/workers
rm docker-config/spark/slaves
rm docker-config/zookeeper/zoo.cfg
echo "dataDir=/usr/local/zookeeper/apache-zookeeper-3.5.5/tmp" >> docker-config/zookeeper/zoo.cfg
while [[ ${i} -lt ${N} ]]
do
	echo "spark-slave$i" >> docker-config/hadoop/workers
	echo "spark-slave$i" >> docker-config/spark/slaves
	echo "server.$i=spark-slave$i:2888:3888" >> docker-config/zookeeper/zoo.cfg
	((i++))
done 

echo ""

echo -e "\nbuild docker spark image\n"

# rebuild kiwenlau/hadoop image
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 .

echo ""
