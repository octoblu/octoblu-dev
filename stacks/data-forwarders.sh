#!/usr/bin/env bash

cd $(dirname $0)
SESSION='data-forwarders'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n data-forwarders
tmux new-window -t $SESSION:2 -n splunk-event-collector
tmux new-window -t $SESSION:3 -n oauth-provider

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/data-forwarders" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE data-forwarders" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/meshblu-splunk-event-collector" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE meshblu-splunk-event-collector" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/oauth-provider" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE oauth-provider" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
