#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
echo + Træfɪk
docker run \
  --name traefik \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $HOME/.docker/machine/certs:/creds \
  -p 50801:50801 \
  -p 80:80 \
  -d emilevauge/traefik >/dev/null 2>&1
