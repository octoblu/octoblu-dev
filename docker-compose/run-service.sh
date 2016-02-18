#!/bin/sh
eval $(docker-machine env --shell bash octoblu-dev)

docker-compose build
docker-compose up
