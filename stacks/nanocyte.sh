#!/usr/bin/env bash

cd $(dirname $0)
SESSION='nanocyte'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n engine
tmux new-window -t $SESSION:2 -n interval
tmux new-window -t $SESSION:3 -n deploy
tmux new-window -t $SESSION:4 -n registry
tmux new-window -t $SESSION:5 -n credentials

tmux split-window -t $SESSION:1 -d -p 66
tmux split-window -t $SESSION:2 -d -p 66
tmux split-window -t $SESSION:5 -d -p 66

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/nanocyte-engine-http" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE nanocyte-engine-http" C-m
tmux send-keys -t $SESSION:1.1 "cd ~/Projects/Octoblu/nanocyte-engine-worker" C-m
tmux send-keys -t $SESSION:1.1 "eval \$SERVICES/$RUN_SERVICE nanocyte-engine-worker" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/interval-service" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE interval-service" C-m
tmux send-keys -t $SESSION:2.1 "cd ~/Projects/Octoblu/interval-worker" C-m
tmux send-keys -t $SESSION:2.1 "eval \$SERVICES/$RUN_SERVICE interval-worker" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/nanocyte-flow-deploy-service" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE nanocyte-flow-deploy-service" C-m

tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/nanocyte-node-registry" C-m
tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE nanocyte-node-registry" C-m

tmux send-keys -t $SESSION:5.0 "cd ~/Projects/Octoblu/credentials-worker" C-m
tmux send-keys -t $SESSION:5.0 "eval \$SERVICES/$RUN_SERVICE credentials-worker" C-m
tmux send-keys -t $SESSION:5.1 "cd ~/Projects/Octoblu/credentials-service" C-m
tmux send-keys -t $SESSION:5.1 "eval \$SERVICES/$RUN_SERVICE credentials-service" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
