#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)
docker run -it --link $1:redis --rm redis sh -c 'exec redis-cli -h redis'
