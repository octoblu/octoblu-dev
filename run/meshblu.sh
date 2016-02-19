#!/bin/bash

source ~/.profile
SERVICES_DIR="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='meshblu'
nvm use 5

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n meshblu-haproxy
tmux new-window -t $SESSION:2 -n meshblu-old
tmux new-window -t $SESSION:3 -n meshblu-server-http
tmux new-window -t $SESSION:4 -n meshblu-core-dispatcher

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 "cd $SERVICES_DIR; ./run-service.sh meshblu" C-m
tmux send-keys -t $SESSION:2.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-old" C-m
tmux send-keys -t $SESSION:3.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-server-http" C-m
tmux send-keys -t $SESSION:4.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-core-dispatcher" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
