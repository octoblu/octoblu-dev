#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

STACK_PROD=$HOME/Projects/Octoblu/the-stack-env-production
../../tools/bin/git-prompt.sh "$STACK_PROD"

jq -s add ../projects/*.json | ./generate.coffee -j -
