#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
docker run -d -p 50801:50801 -p 80:80 -v $PWD/traefik.toml:/traefik.toml -v $PWD/creds:/creds emilevauge/traefik
