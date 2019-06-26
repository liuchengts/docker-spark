#!/bin/bash

echo -e "\n"
${ZOOKEEPER_HOME}/bin/zkServer.sh start
echo -e "\n"
${HADOOP_HOME}/sbin/hadoop-daemons.sh  start journalnode
echo -e "\n"
hdfs zkfc -formatZK
echo -e "\n"
${HADOOP_HOME}/sbin/start-all.sh
echo -e "\n"

