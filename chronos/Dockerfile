FROM debian:jessie
MAINTAINER Micah Hausler, <hausler.m@gmail.com>

RUN \
    apt-get update \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF \
    && echo "deb http://repos.mesosphere.com/debian jessie main" | \
     tee /etc/apt/sources.list.d/mesosphere.list \
    && echo "deb http://httpredir.debian.org/debian jessie-backports main" | \
     tee -a /etc/apt/sources.list \
    && apt-get -y update \
    && apt-get -y install openjdk-8-jre-headless unzip iptables \
    && apt-get -y install chronos


ENV MESOS_WORK_DIR /var/mesos/work
ENV MESOS_ZK_FILE /etc/mesos/zk

ADD zk.conf $MESOS_ZK_FILE
ADD quorum /etc/mesos-master/quorum


RUN mkdir -p $MESOS_WORK_DIR

VOLUME $MESOS_WORK_DIR

EXPOSE 4400

CMD ["/usr/bin/chronos"]
