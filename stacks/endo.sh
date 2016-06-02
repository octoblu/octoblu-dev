#!/usr/bin/env bash

cd $(dirname $0)
SESSION='endo'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n manager
tmux new-window -t $SESSION:2 -n endos
tmux new-window -t $SESSION:3 -n oauth-provider

tmux split-window -t $SESSION:2 -d -p 25
tmux split-window -t $SESSION:2 -d -p 25
tmux split-window -t $SESSION:2 -d -p 50

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/endo-manager" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE endo-manager" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/endo-github" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE endo-github" C-m

tmux send-keys -t $SESSION:2.1 "cd ~/Projects/Octoblu/endo-twitter" C-m
tmux send-keys -t $SESSION:2.1 "eval \$SERVICES/$RUN_SERVICE endo-twitter" C-m

tmux send-keys -t $SESSION:2.2 "cd ~/Projects/Octoblu/endo-facebook" C-m
tmux send-keys -t $SESSION:2.2 "eval \$SERVICES/$RUN_SERVICE endo-facebook" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
