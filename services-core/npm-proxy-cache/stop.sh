#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

echo - npm-proxy-cache
docker-compose kill
