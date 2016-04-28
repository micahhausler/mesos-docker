# Mesos in Docker

## Setup

```
docker-compose build
docker-compose up -d
```

You can then open (assuming your docker machine ip is 192.168.99.100)

* [Mesos](http://192.168.99.100:5050)
* [Zookeeper Exhibitor](http://192.168.99.100:8181)
* [Marathon](http://192.168.99.100:8080)
* [Chronos](http://192.168.99.100:4400)


## Configuration notes

I've found that when running the Mesos agent in docker, it _must_ be run with
the following docker flags:

```
--pid=host --net=host --privileged
```

and the mesos agent flags as provided in `docker-compose.yml`


## Second Slave

To run a second slave using docker-machine, first create the machine:

```
docker-machine create -d virtualbox --virtualbox-cpu-count 1 --virtualbox-memory=1024 slave2
eval $(docker-machine  env slave2)
docker-compose -f docker-compose-slave.yml build
docker-compose -f docker-compose-slave.yml up -d
```

You may have to edit the `docker-compose-slave.yml` to update the IP addresses for your
VMs
