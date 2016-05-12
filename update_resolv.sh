#!/bin/bash

setup_resolv() {
    for vm in default mesos2;  do
        IP=$(docker-machine ip ${vm})
        command="echo nameserver ${IP} | sudo tee /etc/resolv.conf";

        echo "Updating /etc/resolv.conf on ${vm}"
        docker-machine ssh $vm sudo cp /etc/resolv.conf /etc/resolv.conf.bak
        docker-machine ssh $vm "$command"

        echo "checking that mesos-DNS is resolving corectly"
        dig @$(docker-machine ip ${vm}) master.mesos

        # If it failed, try to bring up mesos-DNS
        if [ $? -ne 0 ]; then
            docker-compose -H tcp://$(docker-machine ip ${vm}):2376 start mesos_dns
        fi
    done
}
cleanup_resolv() {
    for vm in default mesos2;  do
        echo "Resetting /etc/resolv.conf on ${vm}"
        docker-machine ssh $vm sudo mv /etc/resolv.conf.bak /etc/resolv.conf
        docker-machine ssh $vm "$command"
    done
}

case "$1" in
    setup)
        ;;
    cleanup)
        ;;
    *)
        echo $"Usage: $0 {setup|cleanup}"
        echo "    /etc/resolv.conf updater for mesos-dns."
        ;;
esac
