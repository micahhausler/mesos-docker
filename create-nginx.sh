#!/bin/bash
curl -X POST -H "Content-Type: application/json" http://192.168.99.100:8080/v2/apps -d@nginx-app.json -s | jq .
