#!/bin/bash

source ~/.profile
SERVICES_DIR="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='octoblu'
nvm use 5

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n app
tmux new-window -t $SESSION:2 -n api
tmux new-window -t $SESSION:3 -n email-pass-auth
tmux new-window -t $SESSION:4 -n email-pass-site

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 "cd $SERVICES_DIR; ./run-service.sh app-octoblu" C-m
tmux send-keys -t $SESSION:2.0 "cd $SERVICES_DIR; ./run-service.sh api-octoblu" C-m
tmux send-keys -t $SESSION:3.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-authenticator-email-password" C-m
tmux send-keys -t $SESSION:4.0 "cd $SERVICES_DIR; ./run-service.sh email-password-site" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
