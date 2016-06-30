#!/usr/bin/env bash

cd $(dirname $0)
SESSION='zooids'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n zooid
tmux new-window -t $SESSION:2 -n zooid-app

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/" C-m
tmux send-keys -t $SESSION:1.0 "npm install --global generator-zooid" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/" C-m
tmux send-keys -t $SESSION:2.0 "npm install --global generator-zooid-app" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
