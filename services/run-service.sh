#!/bin/sh
(
  rm $1-compose.yml;
  rm $1.env;
  cd "$HOME/Projects/Octoblu/octoblu-dev/commands.d";
  ./generate.sh octoblu;
  cd "$HOME/Projects/Octoblu/octoblu-dev/services";
  cp "$HOME/Projects/Octoblu/octoblu-dev/generators/output/$1-compose.yml" .;
  cp "$HOME/Projects/Octoblu/octoblu-dev/generators/output/$1.env" .;
)
eval $(docker-machine env --shell bash octoblu-dev)

docker rm $1
docker-compose -f $1-compose.yml build
docker-compose -f $1-compose.yml up
