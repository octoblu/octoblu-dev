#!/bin/sh
set -eE
eval $(docker-machine env --shell bash octoblu-dev)

cd $HOME/Projects/Octoblu/octoblu-dev/services

if [[ ! -d "$1" ]]; then
  echo "Project $1 does not exist, aborting!"
  exit -1
fi
cd $1

OCTOBLU_DEV=$HOME/Projects/Octoblu/octoblu-dev
PROJECT_HOME=$HOME/Projects/Octoblu/$1
PROJECT_JSON=$PROJECT_HOME/meshblu.json

if [[ ! -d "$PROJECT_HOME" ]]; then
  echo "$PROJECT_HOME does not exist, aborting!"
  exit -1
fi

if [[ -f "$PROJECT_JSON" ]]; then
  echo "meshblu.json already exists, remove to continue."
  exit 1
fi

PROJECT=$1
if [[ -n "$2" ]]; then
  PROJECT=$1-$2
  sed -e "1 s|^\(.*\):|\1-$2:|" -e "s|\(container_name: .*\)|\1-$2|" \
    <$1-compose.yml >$1-$2-compose.yml
fi

COMPOSE=$PROJECT-compose.yml
CONTAINER=$(sed -n 's/^.*container_name: *\(.*\)/\1/p' $COMPOSE)

cp $1.dockerfile-dev $PROJECT_HOME/.$1.dockerfile-dev
cp $OCTOBLU_DEV/services-core/squid/npmrc-dev $PROJECT_HOME/.npmrc-dev

(
  cd $PROJECT_HOME
  git fetch origin
  GIT_LOG_CMD="git log HEAD..origin/master --oneline"
  GIT_LOG=$($GIT_LOG_CMD)
  if [[ -n "$GIT_LOG" ]]; then
    echo "¡WARNING: $1 is ahead of remote!"
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

export DNS=$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')

docker-compose -f $COMPOSE rm -f
docker-compose -f $COMPOSE build
docker-compose -f $COMPOSE up
