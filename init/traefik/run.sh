#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
OCTOBLU_DEV_IP=$(docker-machine ip octoblu-dev)
sed -e "s|192\.168\.99\.100|${OCTOBLU_DEV_IP}|" <traefik.toml.orig >traefik.toml
sed -e "s|192\.168\.99\.100|${OCTOBLU_DEV_IP}|" <../../dns/dnsmasq.conf >/usr/local/etc/dnsmasq.conf
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq

echo + Træfɪk
docker run \
  --name traefik \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $HOME/.docker/machine/certs:/creds \
  -p 50801:50801 \
  -p 80:80 \
  -d emilevauge/traefik >/dev/null 2>&1
