#!/usr/bin/env bash
eval $(docker-machine env --shell bash octoblu-dev)

echo + squid
docker-compose up -d
PROXY_IP=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' \
  $(docker ps | grep /squid | cut -f1 -d\ ) | sed -e 's|\.[0-9]*$|.1|')

(
cat <<EOF
proxy=http://${PROXY_IP}:3128/
https-proxy=http://${PROXY_IP}:3128/
strict-ssl=false
EOF
)>npmrc-dev
