#!/bin/bash

source ~/.profile
SERVICES_DIR="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='meshblu'
nvm use 5

PATH=$PATH:$HOME/Projects/Octoblu/octoblu-dev/commands.d

( cd "$HOME/Projects/Octoblu/octoblu-dev/commands.d"; ./start.sh)

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n haproxy
tmux new-window -t $SESSION:2 -n meshblu-old
tmux new-window -t $SESSION:3 -n server-http
tmux new-window -t $SESSION:4 -n core-dispatcher

tmux split-window -t $SESSION:4 -d -p 33
tmux split-window -t $SESSION:4 -d -p 50

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-haproxy" C-m
tmux send-keys -t $SESSION:2.0 "cd $SERVICES_DIR; ./run-service.sh meshblu" C-m
tmux send-keys -t $SESSION:3.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-server-http" C-m
tmux send-keys -t $SESSION:4.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-core-dispatcher whiskey" C-m
tmux send-keys -t $SESSION:4.1 "cd $SERVICES_DIR; ./run-service.sh meshblu-core-dispatcher tango" C-m
tmux send-keys -t $SESSION:4.2 "cd $SERVICES_DIR; ./run-service.sh meshblu-core-dispatcher foxtrot" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
