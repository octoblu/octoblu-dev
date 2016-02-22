#!/bin/bash

docker-machine start octoblu-dev
sleep 5
(
  cd $HOME/Projects/Octoblu/octoblu-dev/init
  for d in $(ls -d */); do
    (cd $d; ./stop.sh; ./run.sh)
  done
)
