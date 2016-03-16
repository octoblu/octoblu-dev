#!/bin/bash

source ~/.profile

eval $(docker-machine env --shell=bash octoblu-dev)
export SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
export SESSION='meshblu'

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux set-environment -t $SESSION SERVICES $SERVICES DOCKER_HOST $DOCKER_HOST DOCKER_CERT_PATH $DOCKER_CERT_PATH DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY DOCKER_MACHINE_NAME $DOCKER_MACHINE_NAME

tmux new-window -t $SESSION:1 -n proxy
tmux new-window -t $SESSION:2 -n old
tmux new-window -t $SESSION:3 -n http
tmux new-window -t $SESSION:4 -n core

tmux split-window -t $SESSION:4 -d -p 33
tmux split-window -t $SESSION:4 -d -p 50

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 'cd ~/Projects/Octoblu/meshblu-haproxy' C-m
tmux send-keys -t $SESSION:1.0 'eval $SERVICES/run-service.sh meshblu-haproxy' C-m

tmux send-keys -t $SESSION:2.0 'cd ~/Projects/Octoblu/meshblu' C-m
tmux send-keys -t $SESSION:2.0 'eval $SERVICES/run-service.sh meshblu' C-m

tmux send-keys -t $SESSION:3.0 'cd ~/Projects/Octoblu/meshblu-server-http' C-m
tmux send-keys -t $SESSION:3.0 'eval $SERVICES/run-service.sh meshblu-server-http' C-m

tmux send-keys -t $SESSION:4.0 'cd ~/Projects/Octoblu/meshblu-core-dispatcher' C-m
tmux send-keys -t $SESSION:4.0 'eval $SERVICES/run-service.sh meshblu-core-dispatcher whiskey' C-m
tmux send-keys -t $SESSION:4.1 'cd ~/Projects/Octoblu/meshblu-core-dispatcher' C-m
tmux send-keys -t $SESSION:4.1 'eval $SERVICES/run-service.sh meshblu-core-dispatcher tango' C-m
tmux send-keys -t $SESSION:4.2 'cd ~/Projects/Octoblu/meshblu-core-dispatcher' C-m
tmux send-keys -t $SESSION:4.2 'eval $SERVICES/run-service.sh meshblu-core-dispatcher foxtrot' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
