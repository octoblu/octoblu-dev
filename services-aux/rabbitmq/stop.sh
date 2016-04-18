#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)

echo - rabbitmq
docker-compose rm --all --force
