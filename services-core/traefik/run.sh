#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
OCTOBLU_DEV_IP=$(docker-machine ip octoblu-dev)

sed -e "s|{{IP}}|${OCTOBLU_DEV_IP}|" \
  <traefik.toml.template >traefik.toml

echo + Træfɪk
docker-compose build >/dev/null
docker-compose up -d
