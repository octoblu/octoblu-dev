#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
. ./servers

DOCKER_RUN='docker run --name $SERVER -d'
DATA_VOLUME='-v `pwd`/data/${SERVER}:/data'
DOCKER_PERSIST_CMD="$DOCKER_RUN $DATA_VOLUME redis redis-server --appendonly yes"
DOCKER_TEMP_CMD="$DOCKER_RUN redis"

for SERVER in "${SERVERS[@]}"; do
  echo + $SERVER
  if [[ "${SERVER}" =~ "persist" ]]; then
    mkdir -m a+w -p ./data/$SERVER
    touch ./data/$SERVER/appendonly.aof
    chmod a+w ./data/$SERVER/appendonly.aof
    eval $DOCKER_PERSIST_CMD >/dev/null 2>&1
  else
    eval $DOCKER_TEMP_CMD >/dev/null 2>&1
  fi
done
