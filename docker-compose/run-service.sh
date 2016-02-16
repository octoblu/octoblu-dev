#!/bin/sh
eval $(docker-machine env --shell bash tech-com)

docker-compose build
docker-compose up
