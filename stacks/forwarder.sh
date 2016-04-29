#!/usr/bin/env bash

cd $(dirname $0)
SESSION='forwarder-ui'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n forwarder-ui
tmux new-window -t $SESSION:2 -n forwarder-service
tmux new-window -t $SESSION:3 -n splunk-event-collector
tmux new-window -t $SESSION:4 -n oauth-provider

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/forwarder-ui" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE forwarder-ui" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/forwarder-service" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE forwarder-service" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/meshblu-splunk-event-collector" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE meshblu-splunk-event-collector" C-m

tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m



tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
