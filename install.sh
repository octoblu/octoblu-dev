#!/bin/sh
cd $(dirname $0)
set -eE

./tools/bin/git-prompt.sh "$(pwd)"
./bootstrap/bootstrap.sh
./start-core.sh

(cd db-setup && ./setup-mongo.sh mongo-persist)
(cd generator/bin && npm install && ./generate-all.sh)
