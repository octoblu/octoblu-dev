#!/bin/sh
set -eE
eval $(docker-machine env --shell bash octoblu-dev)

OCTOBLU_DEV="$HOME/Projects/Octoblu/octoblu-dev"
PROJECT_HOME="$HOME/Projects/Octoblu/$1"
PROJECT_JSON="$PROJECT_HOME/meshblu.json"

cd "$OCTOBLU_DEV/services"
if [[ ! -d "$1" ]]; then
  echo "Project $1 service definition does not exist, aborting!"
  exit -1
fi
cd "$1"

PROJECT="$1"
if [[ -n "$2" ]]; then
  PROJECT="$1-$2"
  sed -e "1 s|^\(.*\):|\1-$2:|" -e "s|\(container_name: .*\)|\1-$2|" \
    <"$1-compose.yml" >"$1-$2-compose.yml"
fi

"$OCTOBLU_DEV/tools/bin/gitPrompt.sh" "$PROJECT_HOME"

if [[ -f "$PROJECT_JSON" ]]; then
  read -s -p "meshblu.json exists, press 'y' to remove or any other key to abort!"$'\n' -n 1 RM_MESHBLU_JSON
  if [[ "$RM_MESHBLU_JSON" == "y" ]]; then
    rm "$PROJECT_JSON"
  else
    exit 1
  fi
fi

COMPOSE="$PROJECT-compose.yml"
CONTAINER="$(sed -n 's/^.*container_name: *\(.*\)/\1/p' $COMPOSE)"
OCTOBLU_DEV_IP="$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')"
echo "MACHINE_HOST=$OCTOBLU_DEV_IP" >$PROJECT-local.env

cp "$1.dockerfile-dev" "$PROJECT_HOME/.$1.dockerfile-dev"
cp "$OCTOBLU_DEV/services-core/squid/npmrc-dev" "$PROJECT_HOME/.npmrc-dev"

export DNS="$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')"

docker-compose -f "$COMPOSE" rm -f
docker-compose -f "$COMPOSE" build
docker-compose -f "$COMPOSE" up
