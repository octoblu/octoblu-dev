#!/bin/sh
cd $(dirname $0)
set -eE

./bootstrap-core.sh

docker-machine create \
  --driver virtualbox \
  --virtualbox-disk-size "100000" \
  --virtualbox-memory "4096" \
  --virtualbox-cpu-count "2" \
  octoblu-dev \
|| docker-machine start octoblu-dev \
|| true
