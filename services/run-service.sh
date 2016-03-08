#!/bin/sh
eval $(docker-machine env --shell bash octoblu-dev)

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
PROJECT_HOME=$HOME/Projects/Octoblu/$1
PROJECT_JSON=$PROJECT_HOME/meshblu.json

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

cp $1.dockerfile-dev $PROJECT_HOME
cp $OCTOBLU_DEV/services-core/npm-proxy-cache/npmrc-dev $PROJECT_HOME/npmrc-dev

docker-compose -f $COMPOSE stop
docker-compose -f $COMPOSE build
docker-compose -f $COMPOSE up
