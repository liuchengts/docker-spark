#!/bin/bash

# N is the node number of spark cluster
N=$1

if [[ $# = 0 ]]
then
	echo "Please specify the node number of spark cluster!"
	exit 1
fi

# change slaves file
i=1
echo > docker-config/hadoop/workers
echo >  docker-config/spark/slaves
echo >  docker-config/zookeeper/zoo.cfg
echo "spark-master" >> docker-config/hadoop/workers
echo "dataDir=/usr/local/zookeeper/apache-zookeeper-3.5.5/tmp" >> docker-config/zookeeper/zoo.cfg
echo "server.1 = spark-master:2888:3888" >> docker-config/zookeeper/zoo.cfg
while [[ ${i} -lt ${N} ]]
do
	echo "spark-slave$i" >> docker-config/hadoop/workers
	j=i+1
	echo "server.$j=spark-slave$i:2888:3888" >> docker-config/zookeeper/zoo.cfg
	((i++))
done 
mv -f docker-config/hadoop/workers docker-config/spark/slaves
echo ""

echo -e "\nbuild docker spark image\n"

# rebuild spark image
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 .

echo ""
