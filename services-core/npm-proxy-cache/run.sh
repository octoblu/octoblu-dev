#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

echo + npm-proxy-cache
docker-compose build >/dev/null
docker-compose up -d
CONTAINER=$(docker ps | grep npm-proxy-cache | cut -f1 -d\ )
PROXY_IP=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' $CONTAINER)

(
cat <<EOF
proxy=http://${PROXY_IP}:80/
https-proxy=http://${PROXY_IP}:80/
strict-ssl=false
EOF
)>npmrc-dev
