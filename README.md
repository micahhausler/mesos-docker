# Mesos in Docker

This is a short introduction to Mesos meant to get you familiar with spinning up
and running a small mesos cluster.

* Video of this demo: https://www.youtube.com/watch?v=PdSmMT0IGx4
* Slides - https://speakerdeck.com/micahhausler/introduction-to-mesos

## Installation

This guide requires Docker installed from
[docker-toolbox](https://www.docker.com/products/docker-toolbox) with at least
version 1.11.0. Older versions may work, but no guarantees are made.

## Assumptions

The following links and the provided configuration files assume that your
default and secondary docker VM's have the addresses of `192.168.99.100` and
`192.168.99.101`. If yours differ, you will have to modify the configuration
and compose files with your docker VM IP addresses.

## Setup

```
docker-compose build
docker-compose create
docker-compose start zookeeper
```

You'll have to wait a minute for Zookeeper to spin up, which you can
watch at the exhibitor endpoint, on port 8181.

* [Zookeeper Exhibitor](http://192.168.99.100:8181)

Once zookeeper is in a "serving" state, you can start the rest of the services:

```
docker-compose start
```

You can then open:

* [Mesos Master](http://192.168.99.100:5050)
* [Marathon](http://192.168.99.100:8080)

## Second Slave

Runing a second slave is entirely optional, but will help demonstrate load
balancing later on. To run a second slave using docker-machine, first create
the machine:

```
./create-machines.sh
eval $(docker-machine env mesos2)
docker-compose -f docker-compose-slave.yml build
docker-compose -f docker-compose-slave.yml up -d
```

You may have to edit the `docker-compose-slave.yml` to update the IP addresses
for your VMs if the address is not `192.168.99.101`

## Update `resolv.conf` to use mesos-dns

[mesos-dns](https://mesosphere.github.io) is an open-source DNS that uses Mesos
for describing where tasks are running.

Run the provided `update-resolv.sh` script in order for each VM to use the
mesos-dns resolver.

```
./update_resolv.sh setup
```

After you are done running mesos, run the cleanup command so the VM reverts to
its original nameserver

```
./update_resolv.sh cleanup
```

## Running Chronos

[Chronos](https://github.com/mesos/chronos) is a distributed cron system that
runs on Mesos. You can run it on marathon with the `create-app.sh` script.

```
./create-app.sh chronos
```

This POSTs the contents of `./apps/chronos.json` over to marathon to run the task.

Open the app in the [Marathon UI](http://192.168.99.100:8080/ui/#/apps/%2Fchronos)
and after a minute you should see a running task with the status of "Healthy".
In the "ID" column, you'll see a task-name and with an IP address and port.
Click the IP address and you'll be redirected to the Chronos UI.

You can also use mesos-dns to find where chronos is running. See the
[mesos-dns](https://mesosphere.github.io/mesos-dns/docs/naming.html) docs for
more information.

```
dig _chronos._tcp.marathon.mesos @192.168.99.100 SRV
```

## Running an Nginx app

The file `./apps/nginx.json` is an example application that just runs a docker
image of nginx.

```
./create-app.sh nginx
```

If you navigate to the [Marathon UI](http://192.168.99.100:8080/ui/#/apps/%2Fnginx),
You should see 2 instances of nginx staging and eventually running. You can
also query the mesos-dns to see where each instance is running:

```
dig _nginx._tcp.marathon.mesos @192.168.99.100 SRV
```

Also be sure to check out the Mesos master UI, and click the "Sandbox" link for
each running task. There you can see the STDERR and STDOUT of each task.

## Running a Load Balancer

Like the previous tasks, the file `./apps/marathon-lb.json` contains a
definition for running [marathon-lb](https://github.com/mesosphere/marathon-lb)
load balancer on Mesos. Marathon-lb is [HAProxy](http://www.haproxy.org/) that
gets updated based on events from Marathon.

```
./create-app.sh marathon-lb
```

You now have a loadbalancer that is running on Mesos! You can see the HAProxy
stats page running on each of your load balancers at the endpoint
`:9090/haproxy?stats` or [http://192.168.99.100:9090/haproxy?stats](http://192.168.99.100:9090/haproxy?stats)

**Tip**: Add the following two lines to you're host machine's `/etc/hosts` file
to easily navigate to the load balancer in your web browser.

```
192.168.99.100 nginx.docker.local
192.168.99.101 nginx.docker.local
```

or run

```
echo "\n192.168.99.100 nginx.docker.local\n192.168.99.101 nginx.docker.local" | sudo tee -a /etc/hosts
```

Once you have that `/etc/hosts` entry in place, you can go to
[http://nginx.docker.local](http://nginx.docker.local) and your traffic will be
load balanced!

## Configuration notes

I've found that when running the Mesos agent in docker, it _must_ be run with
the following docker flags:

```
--pid=host --net=host --privileged
```

and the mesos agent flags as provided in `docker-compose.yml`

## License

MIT License. See [LICENSE](LICENSE)
