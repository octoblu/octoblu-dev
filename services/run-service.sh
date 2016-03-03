#!/bin/sh
eval $(docker-machine env --shell bash octoblu-dev)

PROJECT_JSON=$HOME/Projects/Octoblu/$1/meshblu.json
if [[ -f "$PROJECT_JSON" ]]; then
  echo "$PROJECT_JSON already exists, remove to continue."
  exit 1
fi

PROJECT=$1
if [[ -n "$2" ]]; then
  PROJECT=$1-$2
  sed -e "1 s|^\(.*\):|\1-$2:|" -e "s|\(container_name: .*\)|\1-$2|" \
    <$1-compose.yml >$1-$2-compose.yml
fi
COMPOSE=$PROJECT-compose.yml
CONTAINER=$(sed -n 's/^.*container_name: *\(.*\)/\1/p' $COMPOSE)

docker rm -f $CONTAINER
docker-compose -f $COMPOSE build
docker-compose -f $COMPOSE up
