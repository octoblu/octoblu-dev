#!/usr/bin/env bash

cd $(dirname $0)
SESSION='channel-device'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n oauth
tmux new-window -t $SESSION:2 -n mailer
tmux new-window -t $SESSION:3 -n editor

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/device-mailer" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE device-mailer" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/device-editor-octoblu" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE device-editor-octoblu" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
