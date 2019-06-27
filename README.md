# docker-spark
* hadoop版本为hadoop-3.1.2.tar.gz
* jdk版本为jdk-8u201-linux-x64.tar.gz
* zookeeper版本为apache-zookeeper-3.5.5.tar.gz
* scala版本为scala-2.13.0.tgz
* spark版本为spark-2.4.3-bin-hadoop2.7.tgz

# 使用步骤
## 创建网络 
```
 sudo docker network create --driver=bridge spark
```
## 下载源代码 
```
 git clone https://github.com/liuchengts/docker-spark.git
```
## 获取镜像有2种方式:
* 从仓库拉取 
```
 sudo docker pull registry.cn-hangzhou.aliyuncs.com/lcts/spark:1.0
```
* 编译镜像，执行 
```
./build-image.sh
```
## 默认是1主2从总共3个节点 如果需要更多节点 请先执行 
```
./resize-cluster.sh 5
```
* 指定参数> 1：2,3 ..
* 这个脚本只是用不同的从属文件重建spark镜像，以节点名称当做容器名称
## 创建容器，执行 如果需要更多节点 可增加执行参数
```
./start-container.sh
或
./start-container.sh 5
```
* 指定参数> 1：2,3 ..
* 这个脚本只是用不同的从属文件重建spark镜像，以节点名称当做容器名称

**output:**
```
start spark-master container...
start spark-slave1 container...
start spark-slave2 container...
root@spark-master:~# 
```
## 启动 spark，执行
```
./start-spark.sh
```

## 启动测试hadoop程序，执行
```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

