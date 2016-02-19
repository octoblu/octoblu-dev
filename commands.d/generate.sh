#!/bin/bash

if [[ -z "$1" ]]; then
  echo "must provide name to generate from"
  exit -1
fi

GENERATE_FILE=`pwd`/generate-$1.json
if [[ ! -f "$GENERATE_FILE" ]]; then
  echo "$GENERATE_FILE does not exist"
  exit -1
fi

(
  cd $HOME/Projects/Octoblu/octoblu-dev/generators
  npm install
  for i in $(seq 0 $(jq '.|length-1' <$GENERATE_FILE)); do
    jq ".[$i]" <$GENERATE_FILE | coffee generate.coffee -j -
  done
)
