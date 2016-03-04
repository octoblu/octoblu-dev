#!/bin/bash
trap "exit" INT

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev

for project in $OCTOBLU_DEV/commands.d/generate-*.json; do
  $OCTOBLU_DEV/commands.d/generate.sh "$project";
done
cp $OCTOBLU_DEV/generators/output/* $OCTOBLU_DEV/services
