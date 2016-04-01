#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)

echo - Træfɪk
docker-compose kill
docker-compose rm -f
