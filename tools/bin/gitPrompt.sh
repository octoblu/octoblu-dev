#!/usr/bin/env bash
set -eE

REPO_DIR=$1
REPO=$(basename $1)
ORG_DIR=$(dirname $1)
ORG=$(basename $ORG_DIR)
NAME="$ORG/$REPO"

if [[ ! -d "ORG_DIR" ]]; then
  mkdir -p "$ORG_DIR" 2>/dev/null
fi

(
  if [[ ! -d "$REPO_DIR" ]]; then
    echo "¡ERROR: Project directory $NAME does not exist!"
    echo
    read -s -p "press 'y' to clone or any other key to abort"$'\n' -n 1 GIT_CLONE
    if [[ "$GIT_CLONE" == "y" ]]; then
        cd "$ORG_DIR"
        git clone git@github.com:$NAME
    else
      exit -1
    fi
  fi
)
(
  cd "$REPO_DIR"
  git fetch origin
  GIT_LOG_CMD="git log HEAD..origin/master --oneline"
  GIT_LOG="$($GIT_LOG_CMD)"
  if [[ -n "$GIT_LOG" ]]; then
    echo "¡WARNING: $NAME is behind remote!"
    echo
    echo "$GIT_LOG"
    echo
    read -s -p "press 'y' to pull, any other key to continue"$'\n' -n 1 GIT_PULL
    if [[ "$GIT_PULL" == "y" ]]; then
      echo "pulling..."
      git pull
    fi
  else
    echo "+ $NAME is up to date"
  fi
)