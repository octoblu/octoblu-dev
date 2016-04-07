#!/usr/bin/env bash

eval $(docker-machine env --shell=bash octoblu-dev)
SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='octoblu'
DOCKER_OR_LOCAL="run-service-docker.sh"

while getopts ":l" opt; do
  case $opt in
    l)
      DOCKER_OR_LOCAL="run-service-local.sh"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux set-environment -t $SESSION SERVICES $SERVICES
tmux set-environment -t $SESSION DOCKER_CERT_PATH $DOCKER_CERT_PATH
tmux set-environment -t $SESSION DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY
tmux set-environment -t $SESSION DOCKER_HOST $DOCKER_HOST
tmux set-environment -t $SESSION DOCKER_MACHINE_NAME $DOCKER_MACHINE_NAME
tmux set-environment -t $SESSION DOCKER_OR_LOCAL $DOCKER_OR_LOCAL

tmux new-window -t $SESSION:1 -n app
tmux new-window -t $SESSION:2 -n api
tmux new-window -t $SESSION:3 -n email-auth
tmux new-window -t $SESSION:4 -n email-site

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 'cd ~/Projects/Octoblu/app-octoblu' C-m
tmux send-keys -t $SESSION:1.0 'eval $SERVICES/$DOCKER_OR_LOCAL app-octoblu' C-m

tmux send-keys -t $SESSION:2.0 'cd ~/Projects/Octoblu/api-octoblu' C-m
tmux send-keys -t $SESSION:2.0 'eval $SERVICES/$DOCKER_OR_LOCAL api-octoblu' C-m

tmux send-keys -t $SESSION:3.0 'cd ~/Projects/Octoblu/meshblu-authenticator-email-password' C-m
tmux send-keys -t $SESSION:3.0 'eval $SERVICES/$DOCKER_OR_LOCAL meshblu-authenticator-email-password' C-m

tmux send-keys -t $SESSION:4.0 'cd ~/Projects/Octoblu/email-password-site' C-m
tmux send-keys -t $SESSION:4.0 'eval $SERVICES/$DOCKER_OR_LOCAL email-password-site' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
