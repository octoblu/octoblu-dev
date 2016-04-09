#!/usr/bin/env bash

cd $(dirname $0)
SESSION='cwc'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n proxy-service
tmux new-window -t $SESSION:2 -n store-octoblu
tmux new-window -t $SESSION:3 -n meshblu-authenticator-cwc-staging
tmux new-window -t $SESSION:4 -n meshblu-authenticator-cwc

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/cwc-authenticator-proxy-service" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE cwc-authenticator-proxy-service" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/store-octoblu" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE store-octoblu" C-m

# tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/meshblu-authenticator-cwc-staging" C-m
# tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE meshblu-authenticator-cwc-staging" C-m
#
# tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/meshblu-authenticator-cwc" C-m
# tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE meshblu-authenticator-cwc" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
