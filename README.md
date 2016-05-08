# Mesos in Docker

This is a short introduction to Mesos meant to get you familiar with spinning up and running a small mesos cluster. 

## Assumptions

The following links and the provided configuration files assume that your
default and secondary docker VM's have the addresses of `192.168.99.100` and
`192.168.99.101`. If yours differ, you will have to modify the configuration
and compose files with your docker VM IP addresses.

This project also assumes you're running the standard docker toolbox
installation.

## Setup

```
docker-compose build
docker-compose up -d
```

You'll have to wait a few seconds for Zookeeper to spin up, which you can
watch at the exhibitor endpoint, on port 8181. You can then open:

* [Zookeeper Exhibitor](http://192.168.99.100:8181)
* [Mesos](http://192.168.99.100:5050)
* [Marathon](http://192.168.99.100:8080)

## Second Slave

To run a second slave using docker-machine, first create the machine:

```
docker-machine create -d virtualbox --virtualbox-cpu-count 1 --virtualbox-memory=1024 slave2
eval $(docker-machine  env slave2)
docker-compose -f docker-compose-slave.yml build
docker-compose -f docker-compose-slave.yml up -d
```

You may have to edit the `docker-compose-slave.yml` to update the IP addresses
for your VMs if the address is not `192.168.99.101`

## Update `resolv.conf` to use mesos-dns

[mesos-dns](https://mesosphere.github.io) is an open-source DNS that uses Mesos
for describing where tasks are running.

Run the provided `update_resolv.sh` script in order for each VM to use the
mesos-dns resolver.

```
bash update_resolv.sh
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
dig _chronos._tcp.marathon.mesos @$(docker-machine ip) SRV
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
dig _nginx._tcp.marathon.mesos @$(docker-machine ip slave2) SRV
```

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

Once you have that `/etc/hosts` entry in place, you can go to
[http://nginx.docker.local](http://nginx.docker.local) and your traffic will be
loadbalanced!

## Configuration notes

I've found that when running the Mesos agent in docker, it _must_ be run with
the following docker flags:

```
--pid=host --net=host --privileged
```

and the mesos agent flags as provided in `docker-compose.yml`

## License

MIT License. See [LICENSE](LICENSE)
