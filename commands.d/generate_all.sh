#!/bin/bash

(
  cd $HOME/Projects/Octoblu/octoblu-dev/commands.d;
  for project in meshblu octoblu nanocyte; do
    ./generate.sh $project;
  done
  cp $HOME/Projects/Octoblu/octoblu-dev/generators/output/* $HOME/Projects/Octoblu/octoblu-dev/services/
)
