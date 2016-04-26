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
    && apt-get -y install openjdk-8-jre-headless curl unzip iptables locales \
    && apt-get -y install mesos marathon \
    && rm -rf /var/lib/apt/lists/* \
    && curl -so /usr/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 && chmod +x /usr/bin/docker


ENV MESOS_WORK_DIR /var/mesos/work
ENV MESOS_ZK_FILE /etc/mesos/zk
ENV MESOS_LOG_DIR /var/log/mesos

ADD zk.conf $MESOS_ZK_FILE
ADD quorum /etc/mesos-master/quorum


RUN mkdir -p $MESOS_WORK_DIR
RUN mkdir -p $MESOS_LOG_DIR
RUN mkdir -p /var/log/mesos_external

VOLUME $MESOS_WORK_DIR
VOLUME $MESOS_LOG_DIR

EXPOSE 5050
EXPOSE 8080

ENV CLUSTER_NAME MesosInDocker

CMD ["/usr/bin/mesos", "master", "--work_dir=$MESOS_WORK_DIR", "--zk=file://$MESOS_ZK_FILE", "--quorum=1", "--cluster=$CLUSTER_NAME", "--log_dir=$MESOS_LOG_DIR"]
