#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)

if [[ -n "$1" ]]; then
  CONTAINER=$1
else
  CONTAINER=redis-tmp
fi
echo 'Connecting to container: '$CONTAINER$'\n'

docker run -it --link $CONTAINER:redis --rm redis sh -c 'exec redis-cli -h redis'
