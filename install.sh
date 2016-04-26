#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

./tools/bin/git-prompt.sh "$(pwd)"
./bootstrap/bootstrap.sh
./start-core.sh
