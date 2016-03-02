#!/bin/bash

source ~/.profile
SERVICES_DIR="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='channel-device'
nvm use 5

PATH=$PATH:$HOME/Projects/Octoblu/octoblu-dev/commands.d

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n oauth
tmux new-window -t $SESSION:2 -n mailer
tmux new-window -t $SESSION:3 -n editor

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 "cd $SERVICES_DIR; ./run-service.sh oauth-provider" C-m
tmux send-keys -t $SESSION:2.0 "cd $SERVICES_DIR; ./run-service.sh device-mailer" C-m
tmux send-keys -t $SESSION:3.0 "cd $SERVICES_DIR; ./run-service.sh device-editor-octoblu" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
