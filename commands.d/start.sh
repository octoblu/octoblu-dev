#!/bin/bash

docker-machine start octoblu-dev
sleep 5
(cd $HOME/Projects/Octoblu/octoblu-dev/traefik; ./run.sh)
(cd $HOME/Projects/Octoblu/octoblu-dev/redis; ./run.sh)
(cd $HOME/Projects/Octoblu/octoblu-dev/mongo; ./run.sh)
