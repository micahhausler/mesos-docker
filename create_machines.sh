#!/bin/bash

docker-machine ls -q | grep -q "default"
DEFAULT_EXISTS=$?

if [ $DEFAULT_EXISTS -eq 1 ]; then
    echo "Creating the default machine"
    docker-machine create \
        -d virtualbox \
        --virtualbox-cpu-count 2 \
        --virtualbox-memory=2048 \
        default
fi

docker-machine ls -q | grep -q "mesos2"
SLAVE_EXISTS=$?

if [ $SLAVE_EXISTS -eq 1 ]; then
    echo "Creating the mesos slave machine"
    docker-machine create \
        -d virtualbox \
        --virtualbox-cpu-count 1 \
        --virtualbox-memory=1024 \
        mesos2
fi
