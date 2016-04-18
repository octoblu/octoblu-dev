#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)
export DNS=0.0.0.0

echo - rabbitmq
docker-compose stop
docker-compose rm --force --all
