#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

./bootstrap-core.sh

docker-machine create \
  --driver virtualbox \
  --virtualbox-disk-size "100000" \
  --virtualbox-memory "4096" \
  --virtualbox-cpu-count "2" \
  octoblu-dev \
|| docker-machine start octoblu-dev \
|| true
