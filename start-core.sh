#!/usr/bin/env bash
cd $(dirname $0)
set -eE

docker-machine start octoblu-dev || true
if [[ -z "$(docker-machine inspect octoblu-dev)" ]]; then
  exit -1
fi

DOCKER_ENV="docker-machine env --shell bash octoblu-dev"
DOCKER_REGEN="docker-machine regenerate-certs -f octoblu-dev"
eval "(${DOCKER_ENV} || (${DOCKER_REGEN} >/dev/null && ${DOCKER_ENV}) || \
  (echo 'Unable to regenerate certs! Please destroy and retry. :(' && false))" 2>/dev/null

for d in $(ls -d services-core/*/); do
  (cd $d; ./stop.sh || true; ./run.sh)
done
