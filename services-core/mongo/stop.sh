#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
. ./servers

for SERVER in "${SERVERS[@]}"; do
  echo - $SERVER
  docker kill $SERVER >/dev/null 2>&1
  docker rm $SERVER >/dev/null 2>&1
done
