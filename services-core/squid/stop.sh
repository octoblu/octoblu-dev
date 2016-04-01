#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)

echo - squid
docker-compose kill
docker-compose rm -f
