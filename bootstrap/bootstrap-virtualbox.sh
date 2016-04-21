#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

./bootstrap-core.sh
. ./bootstrap-local.env

docker-machine create \
  --driver virtualbox \
  --virtualbox-disk-size "$DISK" \
  --virtualbox-memory "$MEM" \
  --virtualbox-cpu-count "$CPU" \
  octoblu-dev \
|| docker-machine start octoblu-dev \
|| true
