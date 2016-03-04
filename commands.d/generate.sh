#!/bin/bash
trap "exit" INT

GENERATE_FILE=$1

if [[ -z "$GENERATE_FILE" ]] || [[ ! -f "$GENERATE_FILE" ]]; then
  echo "must provide json file to generate from"
  exit -1
fi

GENERATOR_PATH=$HOME/Projects/Octoblu/octoblu-dev/generators
for i in $(seq 0 $(jq '.|length-1' <$GENERATE_FILE)); do
  jq ".[$i]" <$GENERATE_FILE | coffee $GENERATOR_PATH/generate.coffee -j -
done
