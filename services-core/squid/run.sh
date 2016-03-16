#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

echo + squid
docker-compose up -d
PROXY_IP=$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')

(
cat <<EOF
proxy=http://${PROXY_IP}:3128/
https-proxy=http://${PROXY_IP}:3128/
strict-ssl=false
EOF
)>npmrc-dev
