#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

echo - Træfɪk
docker-compose kill
