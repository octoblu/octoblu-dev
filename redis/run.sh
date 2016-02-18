#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
docker kill octoblu-redis
docker rm octoblu-redis
docker run --name octoblu-redis -d redis
