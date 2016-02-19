#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

if [[ -z "$1" ]]; then
  echo "must provide a mongo container to connect to"
  exit -1
fi

docker run \
  -v `pwd`:/js --link $1:mongo -it --rm mongo \
  sh -c 'exec mongo mongo/skynet /js/setup-mongo.js'
