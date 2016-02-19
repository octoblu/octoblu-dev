#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
docker run \
  --name traefik \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $HOME/.docker/machine/certs:/creds \
  -p 50801:50801 \
  -p 80:80 \
  -d emilevauge/traefik
