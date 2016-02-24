#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
OCTOBLU_DEV_IP=$(docker-machine ip octoblu-dev)

sed -e "s|{{IP}}|${OCTOBLU_DEV_IP}|" \
  <traefik.toml.template >traefik.toml

(cd ../../dns; ./setup-conf.sh ${OCTOBLU_DEV_IP})
pkill dnsmasq

echo + Træfɪk
docker run \
  --name traefik \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $HOME/.docker/machine/certs:/creds \
  -p 50801:50801 \
  -p 80:80 \
  -d emilevauge/traefik >/dev/null 2>&1
