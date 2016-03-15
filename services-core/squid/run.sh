#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

echo + squid
docker-compose build >/dev/null
docker-compose up -d
CONTAINER=$(docker ps | grep /squid | cut -f1 -d\ )
PROXY_IP=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' $CONTAINER)

(
cat <<EOF
proxy=http://${PROXY_IP}:3128/
https-proxy=http://${PROXY_IP}:3128/
strict-ssl=false
EOF
)>npmrc-dev
