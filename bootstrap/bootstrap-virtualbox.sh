#!/bin/sh
. ./bootstrap-core.sh

docker-machine create \
  --driver virtualbox \
  --virtualbox-disk-size "100000" \
  --virtualbox-memory "4096" \
  --virtualbox-cpu-count "4" \
  octoblu-dev
