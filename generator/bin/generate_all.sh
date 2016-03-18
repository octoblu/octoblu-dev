#!/bin/bash
trap "exit" INT

(
  cd $HOME/Projects/Octoblu/the-stack-env-production
  git fetch origin
  GIT_LOG_CMD="git log HEAD..origin/master --oneline"
  GIT_LOG=$($GIT_LOG_CMD)
  if [[ -n "$GIT_LOG" ]]; then
    echo "¡WARNING: the-stack-env-production is behind remote!"
    echo
    echo "$GIT_LOG"
    echo
    read -s -p 'press "y" to pull, any other key continue'$'\n' -n 1 GIT_PULL
    if [[ "$GIT_PULL" == "y" ]]; then
      echo "pulling..."
      git pull || exit 1
    fi
  fi
)

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
GENERATOR_PATH=$HOME/Projects/Octoblu/octoblu-dev/generator/bin

jq -s add $OCTOBLU_DEV/generator/projects/*.json |
  coffee $GENERATOR_PATH/generate.coffee -j -
