#!/bin/bash

eval $(docker-machine env --shell=bash octoblu-dev)
SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='nanocyte'

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux set-environment -t $SESSION SERVICES $SERVICES
tmux set-environment -t $SESSION DOCKER_CERT_PATH $DOCKER_CERT_PATH
tmux set-environment -t $SESSION DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY
tmux set-environment -t $SESSION DOCKER_HOST $DOCKER_HOST
tmux set-environment -t $SESSION DOCKER_MACHINE_NAME $DOCKER_MACHINE_NAME

tmux new-window -t $SESSION:1 -n engine
tmux new-window -t $SESSION:2 -n interval
tmux new-window -t $SESSION:3 -n deploy
tmux new-window -t $SESSION:4 -n registry
tmux new-window -t $SESSION:5 -n credentials

tmux split-window -t $SESSION:1 -d -p 66
tmux split-window -t $SESSION:2 -d -p 66
tmux split-window -t $SESSION:5 -d -p 66

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 'cd ~/Projects/Octoblu/nanocyte-engine-http' C-m
tmux send-keys -t $SESSION:1.0 'eval $SERVICES/run-service-docker.sh nanocyte-engine-http' C-m
tmux send-keys -t $SESSION:1.1 'cd ~/Projects/Octoblu/nanocyte-engine-worker' C-m
tmux send-keys -t $SESSION:1.1 'eval $SERVICES/run-service-docker.sh nanocyte-engine-worker' C-m

tmux send-keys -t $SESSION:2.0 'cd ~/Projects/Octoblu/nanocyte-interval-redis' C-m
tmux send-keys -t $SESSION:2.0 'eval $SERVICES/run-service-docker.sh nanocyte-interval-redis' C-m
tmux send-keys -t $SESSION:2.1 'cd ~/Projects/Octoblu/nanocyte-interval-service' C-m
tmux send-keys -t $SESSION:2.1 'eval $SERVICES/run-service-docker.sh nanocyte-interval-service' C-m

tmux send-keys -t $SESSION:3.0 'cd ~/Projects/Octoblu/nanocyte-flow-deploy-service' C-m
tmux send-keys -t $SESSION:3.0 'eval $SERVICES/run-service-docker.sh nanocyte-flow-deploy-service' C-m

tmux send-keys -t $SESSION:4.0 'cd ~/Projects/Octoblu/nanocyte-node-registry' C-m
tmux send-keys -t $SESSION:4.0 'eval $SERVICES/run-service-docker.sh nanocyte-node-registry' C-m

tmux send-keys -t $SESSION:5.0 'cd ~/Projects/Octoblu/credentials-worker' C-m
tmux send-keys -t $SESSION:5.0 'eval $SERVICES/run-service-docker.sh credentials-worker' C-m
tmux send-keys -t $SESSION:5.1 'cd ~/Projects/Octoblu/credentials-service' C-m
tmux send-keys -t $SESSION:5.1 'eval $SERVICES/run-service-docker.sh credentials-service' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
