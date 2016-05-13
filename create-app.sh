#!/bin/bash

create_app() {
    curl \
        -X POST \
        -H "Content-Type: application/json" \
        http://192.168.99.100:8080/v2/apps \
        -d@$1 \
        -s | jq .
}

case "$1" in
    chronos)
        create_app ./apps/chronos.json
        ;;
    nginx)
        create_app ./apps/nginx.json
        ;;
    marathon-lb)
        create_app ./apps/marathon-lb.json
        ;;
    *)
        echo $"Usage: $0 {chronos|nginx|marathon-lb}"
        exit 1
        ;;
esac
