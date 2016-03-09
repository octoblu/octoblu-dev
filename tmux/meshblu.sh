#!/bin/bash

source ~/.profile
SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='meshblu'
nvm use 5

cd $SERVICES;

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n proxy
tmux new-window -t $SESSION:2 -n old
tmux new-window -t $SESSION:3 -n http
tmux new-window -t $SESSION:4 -n core

tmux split-window -t $SESSION:4 -d -p 33
tmux split-window -t $SESSION:4 -d -p 50

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 './run-service.sh meshblu-haproxy' C-m
tmux send-keys -t $SESSION:2.0 './run-service.sh meshblu' C-m
tmux send-keys -t $SESSION:3.0 './run-service.sh meshblu-server-http' C-m
tmux send-keys -t $SESSION:4.0 './run-service.sh meshblu-core-dispatcher whiskey' C-m
tmux send-keys -t $SESSION:4.1 './run-service.sh meshblu-core-dispatcher tango' C-m
tmux send-keys -t $SESSION:4.2 './run-service.sh meshblu-core-dispatcher foxtrot' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
