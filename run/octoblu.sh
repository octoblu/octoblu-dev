#!/bin/bash

source ~/.profile
SERVICES_DIR="$HOME/Projects/Octoblu/octoblu-dev/services"
SESSION='meshblu'
nvm use 5

PATH=$PATH;$HOME/Projects/Octoblu/octoblu-dev/commands.d

( cd "$HOME/Projects/Octoblu/octoblu-dev/commands.d"; ./start.sh)

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n app-octoblu
tmux new-window -t $SESSION:2 -n api-octoblu
tmux new-window -t $SESSION:3 -n meshblu-authenticator-email-password
tmux new-window -t $SESSION:4 -n email-password-site

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 "cd $SERVICES_DIR; ./run-service.sh app-octoblu" C-m
tmux send-keys -t $SESSION:2.0 "cd $SERVICES_DIR; ./run-service.sh api-octoblu" C-m
tmux send-keys -t $SESSION:3.0 "cd $SERVICES_DIR; ./run-service.sh meshblu-authenticator-email-password" C-m
tmux send-keys -t $SESSION:4.0 "cd $SERVICES_DIR; ./run-service.sh email-password-site" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
