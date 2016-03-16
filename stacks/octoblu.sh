#!/bin/bash

source ~/.profile

eval $(docker-machine env --shell=bash octoblu-dev)
export SERVICES="$HOME/Projects/Octoblu/octoblu-dev/services"
export SESSION='octoblu'

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux set-environment -t $SESSION SERVICES $SERVICES

tmux new-window -t $SESSION:1 -n app
tmux new-window -t $SESSION:2 -n api
tmux new-window -t $SESSION:3 -n email-pass-auth
tmux new-window -t $SESSION:4 -n email-pass-site

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"

tmux send-keys -t $SESSION:1.0 'cd ~/Projects/Octoblu/app-octoblu' C-m
tmux send-keys -t $SESSION:1.0 'eval $SERVICES/run-service.sh app-octoblu' C-m

tmux send-keys -t $SESSION:2.0 'cd ~/Projects/Octoblu/api-octoblu' C-m
tmux send-keys -t $SESSION:2.0 'eval $SERVICES/run-service.sh api-octoblu' C-m

tmux send-keys -t $SESSION:3.0 'cd ~/Projects/Octoblu/meshblu-authenticator-email-password' C-m
tmux send-keys -t $SESSION:3.0 'eval $SERVICES/run-service.sh meshblu-authenticator-email-password' C-m

tmux send-keys -t $SESSION:4.0 'cd ~/Projects/Octoblu/email-password-site' C-m
tmux send-keys -t $SESSION:4.0 'eval $SERVICES/run-service.sh email-password-site' C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
