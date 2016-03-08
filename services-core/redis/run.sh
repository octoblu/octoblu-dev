#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
. ./servers

DOCKER_RUN='docker run --name $SERVER -d'
DATA_VOLUME='--volumes-from ${SERVER}.data'
DOCKER_PERSIST_CMD="$DOCKER_RUN $DATA_VOLUME redis redis-server --appendonly yes"
DOCKER_TMP_CMD="$DOCKER_RUN redis"

for SERVER in "${SERVERS[@]}"; do
  echo + $SERVER
  if [[ "${SERVER}" =~ "persist" ]]; then
    docker create -v /data --name ${SERVER}.data redis /bin/true >/dev/null 2>&1
    eval $DOCKER_PERSIST_CMD
  else
    eval $DOCKER_TMP_CMD
  fi
done
