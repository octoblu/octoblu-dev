#!/bin/bash
trap "exit" INT

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
DNS=$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')
if [[ -z "$DNS" ]]; then
  echo 'Unable to determine DNS value, aborting'
  exit -1
fi

for project in $OCTOBLU_DEV/generator/projects/*.json; do
  $OCTOBLU_DEV/generator/bin/generate.sh "$project" $DNS;
done
