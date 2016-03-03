#!/bin/bash

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
(
  cd $OCTOBLU_DEV/commands.d;
  for project in $(ls generate-*.json | sed -e 's|^generate-||' -e 's|\.json$||'); do
    ./generate.sh $project;
  done
)
cp $OCTOBLU_DEV/generators/output/* $OCTOBLU_DEV/services
