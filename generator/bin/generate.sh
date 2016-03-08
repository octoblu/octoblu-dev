#!/bin/bash
trap "exit" INT

GENERATE_FILE=$1
DNS=$2

if [[ -z "$GENERATE_FILE" ]] || [[ ! -f "$GENERATE_FILE" ]]; then
  echo "must provide json file to generate from"
  exit -1
fi

GENERATOR_PATH=$HOME/Projects/Octoblu/octoblu-dev/generator/bin
for i in $(seq 0 $(jq '.|length-1' <$GENERATE_FILE)); do
  jq ".[$i]" <$GENERATE_FILE | coffee $GENERATOR_PATH/generate.coffee -d $DNS -j -
done
