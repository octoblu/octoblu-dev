#!/bin/bash
eval $(docker-machine env --shell bash tech-com)
docker run -d -p 50801:50801 -p 80:80 -p 1833:1833 -p 5683:5683/udp -v $PWD/traefik.toml:/traefik.toml -v $PWD/creds:/creds emilevauge/traefik
