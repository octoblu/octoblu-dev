#!/bin/bash
trap "exit" INT

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
GENERATOR_PATH=$HOME/Projects/Octoblu/octoblu-dev/generator/bin

jq -s add $OCTOBLU_DEV/generator/projects/*.json |
  coffee $GENERATOR_PATH/generate.coffee -j -
