#!/bin/sh
set -eE
trap "exit" INT

(
  git fetch origin
  GIT_LOG_CMD="git log HEAD..origin/master --oneline"
  GIT_LOG=$($GIT_LOG_CMD)
  if [[ -n "$GIT_LOG" ]]; then
    echo "¡WARNING: octoblu-dev is behind remote!"
    echo
    echo "$GIT_LOG"
    echo
    read -s -p 'press "y" to pull, any other key continue'$'\n' -n 1 GIT_PULL
    if [[ "$GIT_PULL" == "y" ]]; then
      echo "pulling..."
      git pull
      exit 1
    fi
  fi
)

(cd bootstrap && ./bootstrap.sh)

./start-core.sh
(cd db-setup && ./setup-mongo.sh mongo-persist)
(cd generator/bin && npm install && ./generate_all.sh)
