#!/bin/bash

source ~/.profile

eval $(docker-machine env --shell=bash octoblu-dev)
export SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
export SESSION='nanocyte'

tmux start-server
tmux new-session -d -s $SESSION -n √ø

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
tmux send-keys -t $SESSION:1.0 '(cd $SERVICES; ./run-service.sh nanocyte-engine-http)' C-m
tmux send-keys -t $SESSION:1.1 'cd ~/Projects/Octoblu/nanocyte-engine-worker' C-m
tmux send-keys -t $SESSION:1.1 '(cd $SERVICES; ./run-service.sh nanocyte-engine-worker)' C-m

tmux send-keys -t $SESSION:2.0 'cd ~/Projects/Octoblu/nanocyte-interval-redis' C-m
tmux send-keys -t $SESSION:2.0 '(cd $SERVICES; ./run-service.sh nanocyte-interval-redis)' C-m
tmux send-keys -t $SESSION:2.1 'cd ~/Projects/Octoblu/nanocyte-interval-service' C-m
tmux send-keys -t $SESSION:2.1 '(cd $SERVICES; ./run-service.sh nanocyte-interval-service)' C-m

tmux send-keys -t $SESSION:3.0 'cd ~/Projects/Octoblu/nanocyte-flow-deploy-service' C-m
tmux send-keys -t $SESSION:3.0 '(cd $SERVICES; ./run-service.sh nanocyte-flow-deploy-service)' C-m

tmux send-keys -t $SESSION:4.0 'cd ~/Projects/Octoblu/nanocyte-node-registry' C-m
tmux send-keys -t $SESSION:4.0 '(cd $SERVICES; ./run-service.sh nanocyte-node-registry)' C-m

tmux send-keys -t $SESSION:5.0 'cd ~/Projects/Octoblu/credentials-worker' C-m
tmux send-keys -t $SESSION:5.0 '(cd $SERVICES; ./run-service.sh credentials-worker)' C-m
tmux send-keys -t $SESSION:5.1 'cd ~/Projects/Octoblu/credentials-service' C-m
tmux send-keys -t $SESSION:5.1 '(cd $SERVICES; ./run-service.sh credentials-service)' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
