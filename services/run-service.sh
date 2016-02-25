#!/bin/sh
eval $(docker-machine env --shell bash octoblu-dev)

docker rm $1
docker-compose -f $1-compose.yml build
docker-compose -f $1-compose.yml up
