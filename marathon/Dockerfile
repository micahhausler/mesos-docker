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
    && apt-get -y install \
        openjdk-8-jre-headless \
        mesos \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove

# To build marathon from source, use the following

#    apt-get update \
#    && apt-get install -y apt-transport-https \
#    && echo "deb http://httpredir.debian.org/debian jessie-backports main" | \
#     tee -a /etc/apt/sources.list \
#    && echo "deb https://dl.bintray.com/sbt/debian /" | tee /etc/apt/sources.list.d/sbt.list \
#    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 \
#    && apt-get -y update \
#    && apt-get -y install \
#        openjdk-8-jre-headless \
#        unzip \
#        sbt  \
#        git \
#    && rm -rf /var/lib/apt/lists/* \
#    && cd /tmp \
#    && git clone https://github.com/mesosphere/marathon \
#    && cd /tmp/marathon \
#    && sbt assembly \
#    && mv target/marathon-runnable.jar / \
#    && apt-get remove sbt git \
#    && rm -rf /tmp/marathon \

ADD marathon-runnable.jar /marathon-runnable.jar

EXPOSE 8080

CMD ["java", "-jar", "/marathon-runnable.jar", "--zk=zk://zk1:2181/marathon", "--master=zk://zk1:2181/mesos"]
