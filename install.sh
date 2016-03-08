#!/bin/sh
trap "exit" INT
(cd bootstrap && ./bootstrap.sh)

docker-machine-nfs octoblu-dev \
  --shared-folder=/Users \
  --mount-opts="vers=3,udp"

./start-core.sh || exit -1
(cd db-setup && ./setup-mongo.sh mongo-persist)
(cd generator/bin && npm install && ./generate_all.sh)
