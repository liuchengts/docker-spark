#!/bin/bash

echo ""

echo -e "\nbuild docker spark image\n"
sudo docker build -t registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0 .

echo ""