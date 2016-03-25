#!/usr/bin/env bash
set -eE
trap "exit" INT

STACK_PROD=$HOME/Projects/Octoblu/the-stack-env-production
OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
GENERATOR_PATH=$HOME/Projects/Octoblu/octoblu-dev/generator/bin

"$OCTOBLU_DEV/tools/bin/gitPrompt.sh" "$STACK_PROD"

jq -s add $OCTOBLU_DEV/generator/projects/*.json |
  $GENERATOR_PATH/generate.coffee -j -
