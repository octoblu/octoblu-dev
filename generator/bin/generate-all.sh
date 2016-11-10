#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

echo
STACK_PROD=$HOME/Projects/Octoblu/the-stack-env-production
../../tools/bin/git-prompt.sh "$STACK_PROD"

npm install
jq -s add ../projects/*.json | ./generate.coffee -j -
