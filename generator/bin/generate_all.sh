#!/bin/bash
trap "exit" INT

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
DNS=$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')

for project in $OCTOBLU_DEV/generator/projects/*.json; do
  $OCTOBLU_DEV/generator/bin/generate.sh "$project" $DNS;
done
cp $OCTOBLU_DEV/generator/output/* $OCTOBLU_DEV/services
