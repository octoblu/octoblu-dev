#!/usr/bin/env bash

cd $(dirname $0)
SESSION='forwarder'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n ui
tmux new-window -t $SESSION:2 -n service
tmux new-window -t $SESSION:3 -n forwarders
tmux new-window -t $SESSION:4 -n oauth-provider

tmux split-window -t $SESSION:3 -d -p 25
tmux split-window -t $SESSION:3 -d -p 25
tmux split-window -t $SESSION:3 -d -p 50

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/forwarder-ui" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE forwarder-ui" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/forwarder-service" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE forwarder-service" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/data-forwarder-splunk" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE data-forwarder-splunk" C-m

tmux send-keys -t $SESSION:3.1 "cd ~/Projects/Octoblu/data-forwarder-elasticsearch" C-m
tmux send-keys -t $SESSION:3.1 "eval \$SERVICES/$RUN_SERVICE data-forwarder-elasticsearch" C-m

tmux send-keys -t $SESSION:3.2 "cd ~/Projects/Octoblu/data-forwarder-mongodb" C-m
tmux send-keys -t $SESSION:3.2 "eval \$SERVICES/$RUN_SERVICE data-forwarder-mongodb" C-m

tmux send-keys -t $SESSION:3.3 "cd ~/Projects/Octoblu/data-forwarder-azure-service-bus" C-m
tmux send-keys -t $SESSION:3.3 "eval \$SERVICES/$RUN_SERVICE data-forwarder-azure-service-bus" C-m

tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
