#!/bin/bash

for vm in $(docker-machine ls --filter STATE=Running -q); do
    IP=$(docker-machine ip ${vm})
    command="echo nameserver ${IP} | sudo tee /etc/resolv.conf";

    echo "Updating /etc/resolv.conf on ${vm}"
    docker-machine ssh $vm sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    docker-machine ssh $vm "$command"

    echo "checking that mesos-DNS is resolving corectly"
    dig @$(docker-machine ip ${vm}) master.mesos

    # If it failed, try to bring up mesos-DNS
    if [ $? -ne 0 ]; then
        docker-compose -H tcp://$(docker-machine ip slave2):2376 start mesos_dns
    fi
done
