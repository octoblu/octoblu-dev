#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)

if [[ -n "$1" ]]; then
  CONTAINER=$1
else
  CONTAINER=mongo-persist
fi
echo 'Connecting to container: '$CONTAINER$'\n'

docker run -it --link $CONTAINER:mongo --rm mongo sh -c 'exec mongo -host mongo'
