#!/usr/bin/env bash

cd $(dirname $0)
SESSION='octoblu'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n app
tmux new-window -t $SESSION:2 -n api
tmux new-window -t $SESSION:3 -n email-auth
tmux new-window -t $SESSION:4 -n email-site
tmux new-window -t $SESSION:5 -n oauth

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/app-octoblu" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE app-octoblu" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/api-octoblu" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE api-octoblu" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/meshblu-authenticator-email-password" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE meshblu-authenticator-email-password" C-m

tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/email-password-site" C-m
tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE email-password-site" C-m

tmux send-keys -t $SESSION:5.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:5.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
