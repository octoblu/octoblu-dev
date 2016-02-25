#!/bin/bash

docker-machine start octoblu-dev

DOCKER_ENV="docker-machine env --shell bash octoblu-dev"
DOCKER_REGEN="docker-machine regenerate-certs -f octoblu-dev"
eval "(${DOCKER_ENV} || (${DOCKER_REGEN} >/dev/null && ${DOCKER_ENV}))" 2>/dev/null

$HOME/Projects/Octoblu/octoblu-dev/commands.d/generate_all.sh

(
  cd $HOME/Projects/Octoblu/octoblu-dev/init
  for d in $(ls -d */); do
    (cd $d; ./stop.sh; ./run.sh)
  done
)
