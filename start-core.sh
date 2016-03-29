#!/bin/bash
set -eE
trap "exit" INT

docker-machine start octoblu-dev || true
if [[ -z "$(docker-machine inspect octoblu-dev)" ]]; then
  exit -1
fi

DOCKER_ENV="docker-machine env --shell bash octoblu-dev"
DOCKER_REGEN="docker-machine regenerate-certs -f octoblu-dev"
eval "(${DOCKER_ENV} || (${DOCKER_REGEN} >/dev/null && ${DOCKER_ENV}) || \
  (echo 'Unable to regenerate certs! Please destroy and retry. :(' && false))" 2>/dev/null

(
  cd $HOME/Projects/Octoblu/octoblu-dev/services-core
  for d in $(ls -d */); do
    (cd $d; ./stop.sh || true; ./run.sh)
  done
)
