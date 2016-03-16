#!/bin/bash
trap "exit" INT

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
DNS=$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')
if [[ -z "$DNS" ]]; then
  echo 'Unable to determine DNS value, aborting'
  exit -1
fi

GENERATOR_PATH=$HOME/Projects/Octoblu/octoblu-dev/generator/bin

jq -s add $OCTOBLU_DEV/generator/projects/*.json |
  coffee $GENERATOR_PATH/generate.coffee -d $DNS -j -
