FROM ubuntu:14.04
MAINTAINER lc
USER root
WORKDIR /root
#拷贝必要的文件配置
COPY /docker-config $WORKDIR
#构建参数设置
ARG AXEL=axel-2.4-9
# axel下载线程数
ARG AXELT=1000
ARG JDK=jdk-8u201-linux-x64.tar.gz
ARG ZOOKEEPER=apache-zookeeper-3.5.5.tar.gz
ARG HADOOP=hadoop-3.1.2.tar.gz
ARG SCALA=scala-2.13.0.tgz
ARG SPARK=spark-2.4.3-bin-hadoop2.7.tgz
#===环境变量相关
ARG JDK_FILE_HOME=jdk1.8.0_201
ARG ZOOKEEPER_FILE_HOME=apache-zookeeper-3.5.5
ARG ZOOKEEPER_V=zookeeper-3.5.5
ARG HADOOP_FILE_HOME=hadoop-3.1.2
ARG SCALA_FILE_HOME=scala-2.13.0
ARG SCALA_V=2.13.0
ARG SPARK_FILE_HOME=spark-2.4.3-bin-hadoop2.7
ARG SPARK_FILE_V=spark-2.4.3
#设置环境变量
ENV JAVA_HOME=/usr/java/$JDK_FILE_HOME
ENV JRE_HOME=$JAVA_HOME/jre
ENV JAVA_BIN=$JAVA_HOME/bin
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
ENV ZOOKEEPER_HOME=/usr/local/zookeeper/$ZOOKEEPER_FILE_HOME
ENV HADOOP_HOME=/usr/local/hadoop/$HADOOP_FILE_HOME
ENV SCALA_HOME=/usr/local/scala/$SCALA_FILE_HOME
ENV SPARK_HOME=/usr/local/spark/$SPARK_FILE_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$ZOOKEEPER_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SCALA_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin
#安装必要的工具
RUN apt-get update \
    && apt-get install -y wget vim openssh-server tar \
    #下载sunjdk
    && wget http://pubqn.ayouran.com/$JDK  \
    #安装jdk
    && mkdir /usr/java \
    && tar -zxvf $JDK -C /usr/java \
    #下载zookeeper
    && wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/$ZOOKEEPER_V/$ZOOKEEPER  \
    #创建zookeeper需要的文件目录
    && mkdir -p $ZOOKEEPER_HOME \
    #安装zookeeper
    && tar -zxvf $ZOOKEEPER -C /usr/local/zookeeper \
    #复制配置文件
    && cp -f zookeeper/zoo.cfg  $ZOOKEEPER_HOME/conf \
    #下载hadoop
    &&  wget http://mirror.bit.edu.cn/apache/hadoop/common/$HADOOP_FILE_HOME/$HADOOP  \
    #安装hadoop
    #创建hadoop需要的文件目录
    && mkdir -p ~/hdfs/namenode ~/hdfs/datanode $HADOOP_HOME/log \
    && tar -zxvf $HADOOP -C /usr/local/hadoop \
    #复制配置文件
    && cp -f hadoop/* $HADOOP_HOME/etc/hadoop \
    ##配置hadoop
    #格式化hdfs文件系统
    && hdfs namenode -format \
    #下载scala
    && wget https://downloads.lightbend.com/scala/${SCALA_V}/${SCALA} \
    #创建scala需要的文件目录
    && mkdir -p $SCALA_HOME \
    #安装scala
    && tar -zxvf $SCALA -C /usr/local/scala \
    #下载spark
    && wget http://mirror.bit.edu.cn/apache/spark/${SPARK_FILE_V}/${SPARK} \
    #创建spark需要的文件目录
    && mkdir -p $SPARK_HOME \
    #安装spark
    && tar -zxvf $SPARK -C /usr/local/spark \
    #复制配置文件
    && cp -f spark/* $SPARK_HOME/conf \
    #生成sshkey
    && ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
    #配置本机免密登录
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && cp -f ssh/ssh_config ~/.ssh/config \
    #清理
    && rm -rf  hadoop ssh  $JDK $ZOOKEEPER $HADOOP $SCALA $SPARK  \
    #增加可执行文件权限
    && chmod +x ~/start-spark.sh  \
    && chmod +x ~/run-wordcount.sh  \
    && chmod +x $ZOOKEEPER_HOME/bin/zkServer.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-all.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-dfs.sh  \
    && chmod +x $HADOOP_HOME/sbin/start-yarn.sh

CMD [ "sh", "-c", "service ssh start; bash"]