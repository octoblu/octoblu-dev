#!/usr/bin/env bash
set -eE

home=$HOME
user=$USER
path=$PATH
for i in $(env | awk -F"=" '{print $1}') ; do
  unset $i;
done
export HOME=$home
export USER=$user
export PATH=$path

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

NAME="$1"
PROJECT="$1"
if [[ -n "$2" ]]; then
  PROJECT="$1-$2"
  sed -e "1 s|^\(.*\):|\1-$2:|" \
      -e "s|\(container_name: .*\)|\1-$2|" \
      -e "s|-local\.env|-$2-local.env|" \
      <"$1-compose-local.yml" >"$1-$2-compose-local.yml"
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

COMPOSE="$PROJECT-compose-local.yml"
CONTAINER="$(sed -n 's/^.*container_name: *\(.*\)/\1/p' $COMPOSE)"
CMD=$(grep "^CMD" "$NAME.dockerfile-dev" |
  sed -e 's|^CMD *||' -e 's|^ *\["||' -e 's|" *, *"| |g' -e 's|"\] *$||')

DEFAULT_PORT_MIN=49152
DEFAULT_PORT_MAX=65535
DEFAULT_PORT_RANGE=$((DEFAULT_PORT_MAX-DEFAULT_PORT_MIN))
OCTOBLU_DEV_IP="$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')"

set -a
. ./$NAME-public.env
. ./$NAME-private.env

PORT="$((RANDOM%DEFAULT_PORT_RANGE+DEFAULT_PORT_MIN))"
echo "HOST=$OCTOBLU_DEV_IP"$'\n'$"PORT=$PORT" >$PROJECT-local.env

docker-compose -f "$COMPOSE" rm -f
docker-compose -f "$COMPOSE" build
docker-compose -f "$COMPOSE" up -d

cd $PROJECT_HOME
#npm install
echo "$CMD"
$CMD
