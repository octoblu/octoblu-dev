#!/usr/bin/env bash

cd $(dirname $0)
SESSION='canary'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n canary
tmux new-window -t $SESSION:2 -n triggers

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/flow-canary" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE flow-canary" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/triggers-service" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE triggers-service" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
