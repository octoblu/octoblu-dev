#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

eval $(docker-machine env --shell bash octoblu-dev)

if [[ -n "$1" ]]; then
  CONTAINER=$1
else
  CONTAINER=mongo-persist
fi
echo 'Connecting to container: '$CONTAINER$'\n'

files=(db-jsons/*/*/*.json)

function join { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }

jsFilesArray='["'$(join '","' "${files[@]}")$'"]'

docker run \
  -v `pwd`:/db-setup --link $CONTAINER:mongo -it --rm mongo \
  sh -c "exec mongo mongo/local --quiet --eval 'var files=${jsFilesArray}' /db-setup/setup-mongo.js"
