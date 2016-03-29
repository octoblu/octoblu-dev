#!/bin/sh
#set -eE
trap "exit" INT

./tools/bin/git-prompt.sh "$(pwd)" || exit 1
(cd bootstrap && ./bootstrap.sh)
./start-core.sh || exit 1
(cd db-setup && ./setup-mongo.sh mongo-persist)
(cd generator/bin && npm install && ./generate-all.sh)
