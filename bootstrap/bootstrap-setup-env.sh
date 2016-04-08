#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

MIN_CPU=4
MIN_MEM=4096
ENV_FILE=./bootstrap-local.env

if [[ ! -f "$ENV_FILE" ]]; then
  CPU=$(expr $(sysctl -n hw.ncpu) / 2)
  MEM=$(expr $(sysctl -n hw.memsize) / 1024 / 1024 / 2)
  RUN_SERVICE_DEFAULT=run-service-docker.sh

  echo -n "# Wow, setting up defaults for such a "

  if [[ "$CPU" -ge "$MIN_CPU" ]] && [[ "$MEM" -ge "$MIN_MEM" ]]; then
    echo "large machine!"
  else
    echo "puny machine!"
    CPU=1
    MEM=512
    RUN_SERVICE_DEFAULT=run-service-local.sh
  fi

  ( cat << EOF
CPU=$CPU
MEM=$MEM
DISK=100000
RUN_SERVICE_DEFAULT=$RUN_SERVICE_DEFAULT
EOF
  ) >$ENV_FILE
fi

echo "# Using machine defaults:"
cat $ENV_FILE
