#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)

if [[ -z "$1" ]]; then
  echo "must provide a mongo container to connect to"
  exit -1
fi

files=(db-jsons/*/*/*.json)

function join { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }

jsFilesArray='["'$(join '","' "${files[@]}")$'"]'

docker run \
  -v `pwd`:/db-setup --link $1:mongo -it --rm mongo \
  sh -c "exec mongo mongo/local --quiet --eval 'var files=${jsFilesArray}' /db-setup/setup-mongo.js"
