#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
docker run -it --link $1:mongo --rm mongo sh -c 'exec mongo -host mongo'
