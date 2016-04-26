#!/usr/bin/env bash
set -eE

home=$HOME
user=$USER
path=$PATH
term=$TERM
for e in $(env | cut -f1 -d=); do
  unset $e
done
export HOME=$home
export USER=$user
export PATH=$path
export TERM=$term

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
      <"$1-compose-local.yml" >"$1-$2-compose-local.yml"
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

COMPOSE="$PROJECT-compose-local.yml"
CONTAINER="$(sed -n 's/^.*container_name: *\(.*\)/\1/p' $COMPOSE)"
CMD=$(grep "^CMD" "$NAME.dockerfile-dev" |
  sed -e 's|^CMD *||' -e 's|^ *\[ *"||' -e 's|" *, *"| |g' -e 's|" *\] *$||')

DEFAULT_PORT_MIN=49152
DEFAULT_PORT_MAX=65535
DEFAULT_PORT_RANGE=$((DEFAULT_PORT_MAX-DEFAULT_PORT_MIN))
OCTOBLU_DEV_IP="$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')"

cp -rfp "$OCTOBLU_DEV/tools/bin/" "$PROJECT_HOME/.bin-dev"

set -a
. ./$NAME-public.env
. ./$NAME-private.env

if [[ -n "$PORT" ]]; then

  SERVICE_PORT=$PORT
  if [[ $PORT -eq 80 ]]; then
    PORT="$((RANDOM%DEFAULT_PORT_RANGE+DEFAULT_PORT_MIN))"
  fi
  LOCAL_PORT=$PORT

  ( cat << EOF
MACHINE_HOST=$OCTOBLU_DEV_IP
SERVICE_PORT=$SERVICE_PORT
LOCAL_PORT=$LOCAL_PORT
EOF
  ) >$PROJECT-local.env

  PROJECT_NAME=$PROJECT
  COMPOSE_HTTP_TIMEOUT=180

  lockfile=/tmp/octoblu-dev-run-service-local.lock
  "$OCTOBLU_DEV/tools/bin/lock.sh" $lockfile 'docker-compose build'

  grep -Ei '^ *add +https?://' $NAME.dockerfile-dev | \
  while IFS= read -r add; do
    URL=$(echo $add | awk '{print $2}')
    FILE=$(echo $add | awk '{gsub(/^\/usr\/src\/app\//, "", $3); print $3}')
    echo "FETCHING $URL to $FILE"
    curl -s $URL >$PROJECT_HOME/$FILE
  done

  docker-compose -f "$COMPOSE" kill
  docker-compose -f "$COMPOSE" rm -f
  docker-compose -f "$COMPOSE" build
  (
    docker-compose -f "$COMPOSE" up
    STATUS_CODE=$(docker-compose -f "$COMPOSE" ps -q 2>/dev/null | xargs docker inspect -f '{{ .State.ExitCode }}')
    if [[ $STATUS_CODE -ne 0 ]]; then
      echo $'\n'$" ! docker exit code: $STATUS_CODE "$'\n'
      notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"error\",\"title\":\"- docker exit ($STATUS_CODE)\"}}"
    fi
  ) &

  rm $lockfile
fi

cd $PROJECT_HOME

lockfile=/tmp/octoblu-dev-run-service-local-npm-$NAME.lock
"$OCTOBLU_DEV/tools/bin/lock.sh" $lockfile 'npm install'

npm install

(sleep 5; rm $lockfile) &

echo $CMD
$CMD
