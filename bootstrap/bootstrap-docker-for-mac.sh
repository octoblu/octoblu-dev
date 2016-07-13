#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

./bootstrap-core.sh
. ./bootstrap-local.env
