#!/bin/sh
eval $(docker-machine env --shell bash octoblu-dev)

PROJECT_JSON=$HOME/Projects/Octoblu/$1/meshblu.json

if [[ -f "$PROJECT_JSON" ]]; then
  echo "$PROJECT_JSON already exists, remove to continue."
  exit 1
fi


docker-compose -p $1-$2 -f $1-compose.yml build
docker-compose -p $1-$2 -f $1-compose.yml up
