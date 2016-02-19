#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
. ./servers

DOCKER_RUN='docker run --name $SERVER -d'
DATA_VOLUME='--volumes-from ${SERVER}.data'
DOCKER_PERSIST_CMD="$DOCKER_RUN $DATA_VOLUME mongo"
DOCKER_TMP_CMD="$DOCKER_RUN mongo"

for SERVER in "${SERVERS[@]}"; do
  echo + $SERVER
  if [[ "${SERVER}" =~ "persist" ]]; then
    docker create -v /data/db --name ${SERVER}.data mongo /bin/true >/dev/null 2>&1
    eval $DOCKER_PERSIST_CMD >/dev/null 2>&1
  else
    eval $DOCKER_TMP_CMD >/dev/null 2>&1
  fi
done
