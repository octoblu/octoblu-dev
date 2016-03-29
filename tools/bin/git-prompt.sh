#!/usr/bin/env bash
set -eE

REPO_DIR=$1
REPO=$(basename $1)
ORG_DIR=$(dirname $1)
ORG=$(basename $ORG_DIR)
NAME="$ORG/$REPO"
PROJECT_NAME=$2
if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME=$REPO
fi

notify() {
  cmd='curl -vvv -s -H "Content-Type: application/json" -X POST \
            -d '$"'$@'"$' http://'$"$MACHINE_HOST"$':23054/notify'
  eval "$cmd" >/dev/null 2>&1 &
}

mkdir -p "$ORG_DIR" 2>/dev/null
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
    notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"title\":\"? git pull\",\"sticky\":true}}"
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
