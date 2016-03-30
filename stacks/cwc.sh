#!/bin/bash

eval $(docker-machine env --shell=bash octoblu-dev)
SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='cwc'

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux set-environment -t $SESSION SERVICES $SERVICES
tmux set-environment -t $SESSION DOCKER_CERT_PATH $DOCKER_CERT_PATH
tmux set-environment -t $SESSION DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY
tmux set-environment -t $SESSION DOCKER_HOST $DOCKER_HOST
tmux set-environment -t $SESSION DOCKER_MACHINE_NAME $DOCKER_MACHINE_NAME

tmux new-window -t $SESSION:1 -n proxy-service
tmux new-window -t $SESSION:2 -n meshblu-authenticator-cwc-staging
tmux new-window -t $SESSION:3 -n meshblu-authenticator-cwc

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 'cd ~/Projects/Octoblu/cwc-authenticator-proxy-service' C-m
tmux send-keys -t $SESSION:1.0 'eval $SERVICES/run-service-docker.sh cwc-authenticator-proxy-service' C-m

# tmux send-keys -t $SESSION:2.0 'cd ~/Projects/Octoblu/meshblu-authenticator-cwc-staging' C-m
# tmux send-keys -t $SESSION:2.0 'eval $SERVICES/run-service-docker.sh meshblu-authenticator-cwc-staging' C-m
#
# tmux send-keys -t $SESSION:3.0 'cd ~/Projects/Octoblu/meshblu-authenticator-cwc' C-m
# tmux send-keys -t $SESSION:3.0 'eval $SERVICES/run-service-docker.sh meshblu-authenticator-cwc' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
