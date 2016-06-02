#!/usr/bin/env bash

cd $(dirname $0)
SESSION='endo'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n manager
tmux new-window -t $SESSION:2 -n endos
tmux new-window -t $SESSION:3 -n oauth-provider

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/endo-manager" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE endo-manager" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/endo-github" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE endo-github" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
