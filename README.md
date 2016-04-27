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

## This is Broken

Currently, if you run the `create-nginx.sh` script, it will create an app in marathon
consisting of a stock nginx docker container.

It never ends up running and the mesos slave emits a message like this over and over:

```
W0427 21:10:21.941206  4160 slave.cpp:4979] Failed to get resource statistics for executor
    'nginx.bfc4ba19-0cba-11e6-afb1-0242c0a82002' of framework f03be97a-455a-49ce-af1c-037504847537-0000:
    Failed to '/usr/local/bin/docker -H unix:///var/run/docker.sock inspect
    mesos-f03be97a-455a-49ce-af1c-037504847537-S0.353bef09-118b-4cae-a76a-dbc7ecb14d36':
    exit status = exited with status 1 stderr = Error: No such image or container:
    mesos-f03be97a-455a-49ce-af1c-037504847537-S0.353bef09-118b-4cae-a76a-dbc7ecb14d36
```

Now, when I run

```
docker inspect <container-name-above>.executor
```

I get a response.

Is this mesos just not knowing the name of the contianer it created?
