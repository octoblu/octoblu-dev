#!/usr/bin/env bash
set -eE
eval $(docker-machine env --shell bash octoblu-dev)

OCTOBLU_DEV="$HOME/Projects/Octoblu/octoblu-dev"
PROJECT_HOME="$HOME/Projects/Octoblu/$1"
PROJECT_JSON="$PROJECT_HOME/meshblu.json"
GROWL_NOTIFY="$OCTOBLU_DEV/tools/bin/growl-notify.sh"

notify () {
  $GROWL_NOTIFY "$@" >/dev/null &
}

cd "$OCTOBLU_DEV/services/generated"
if [[ ! -d "$1" ]]; then
  echo "Project $1 service definition does not exist, aborting!"
  exit -1
fi
cd "$1"

NAME="$1"
PROJECT="$1"
if [[ -n "$2" ]]; then
  PROJECT="$1-$2"
  sed -e "1 s|^\(.*\):|\1-$2:|" \
      -e "s|\(container_name: .*\)|\1-$2|" \
      -e "s|$1-local.env|$1-$2-local.env|" \
    <"$1-compose.yml" >"$1-$2-compose.yml"
fi

"$OCTOBLU_DEV/tools/bin/git-prompt.sh" "$PROJECT_HOME"

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

echo "MACHINE_HOST=$OCTOBLU_DEV_IP"$'\n'$"PROJECT_NAME=$PROJECT" >$PROJECT-local.env

cp "$1.dockerfile-dev" "$PROJECT_HOME/.$1.dockerfile-dev"
cp "$OCTOBLU_DEV/services-core/squid/npmrc-dev" "$PROJECT_HOME/.npmrc-dev"
cp -rfp "$OCTOBLU_DEV/tools/bin/" "$PROJECT_HOME/.bin-dev"

. ./$NAME-public.env

if [[ -z "$PORT" ]]; then
  PORT=80
fi

if [[ $PORT -ne 80 ]]; then
  PORT=$PORT:$PORT
fi

export SERVICE_PORT=$PORT
export DNS="$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')"
export COMPOSE_HTTP_TIMEOUT=180

lockfile=/tmp/octoblu-dev-run-service-docker-build-$NAME.lock
"$OCTOBLU_DEV/tools/bin/lock.sh" $lockfile 'docker-compose build'

docker-compose -f "$COMPOSE" kill
docker-compose -f "$COMPOSE" rm -f
docker-compose -f "$COMPOSE" build

rm $lockfile

(
  docker-compose -f "$COMPOSE" up
  STATUS_CODE=$(docker-compose -f "$COMPOSE" ps -q 2>/dev/null | xargs docker inspect -f '{{ .State.ExitCode }}')
  if [[ $STATUS_CODE -ne 0 ]]; then
    echo $'\n'$" ! docker exit code: $STATUS_CODE "$'\n'
    notify "{\"text\":\"$PROJECT\",\"options\":{\"label\":\"error\",\"title\":\"- docker exit ($STATUS_CODE)\"}}"
  fi
)
