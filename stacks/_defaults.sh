set -eE

eval $(docker-machine env --shell=bash octoblu-dev)
SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
BOOTSTRAP_LOCAL_ENV=../bootstrap/bootstrap-local.env

if [[ -f "$BOOTSTRAP_LOCAL_ENV" ]]; then
  . $BOOTSTRAP_LOCAL_ENV
fi

RUN_SERVICE=$RUN_SERVICE_DEFAULT

while getopts ":ldh" opt; do
  case $opt in
    l)
      RUN_SERVICE="run-service-local.sh"
      ;;
    d)
      RUN_SERVICE="run-service-docker.sh"
      ;;
    h)
      echo "options: $0 [ -l | -d ]"
      echo "  -l   # local"
      echo "  -d   # docker"
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$RUN_SERVICE" ]]; then
  RUN_SERVICE="run-service-docker.sh"
fi

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux set-environment -t $SESSION SERVICES $SERVICES
tmux set-environment -t $SESSION DOCKER_CERT_PATH $DOCKER_CERT_PATH
tmux set-environment -t $SESSION DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY
tmux set-environment -t $SESSION DOCKER_HOST $DOCKER_HOST
tmux set-environment -t $SESSION DOCKER_MACHINE_NAME $DOCKER_MACHINE_NAME
tmux set-environment -t $SESSION RUN_SERVICE $RUN_SERVICE
