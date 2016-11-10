#!/usr/bin/env bash

cd $(dirname $0)
SESSION='nanocyte'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n engine
tmux new-window -t $SESSION:2 -n interval
tmux new-window -t $SESSION:3 -n minutemen
tmux new-window -t $SESSION:4 -n secondmen
tmux new-window -t $SESSION:5 -n nowmen
tmux new-window -t $SESSION:6 -n deploy
tmux new-window -t $SESSION:7 -n registry
tmux new-window -t $SESSION:8 -n credentials

tmux split-window -t $SESSION:1 -d -p 66
tmux split-window -t $SESSION:3 -d -p 50
tmux split-window -t $SESSION:4 -d -p 50
tmux split-window -t $SESSION:5 -d -p 50
tmux split-window -t $SESSION:8 -d -p 66

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/nanocyte-engine-http" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE nanocyte-engine-http" C-m
tmux send-keys -t $SESSION:1.1 "cd ~/Projects/Octoblu/nanocyte-engine-worker" C-m
tmux send-keys -t $SESSION:1.1 "eval \$SERVICES/$RUN_SERVICE nanocyte-engine-worker" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/interval-service" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE interval-service" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/minutemen-worker" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE minutemen-worker whiskey" C-m
tmux send-keys -t $SESSION:3.1 "cd ~/Projects/Octoblu/minutemen-worker" C-m
tmux send-keys -t $SESSION:3.1 "eval \$SERVICES/$RUN_SERVICE minutemen-worker tango" C-m

tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/secondmen-worker" C-m
tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE secondmen-worker whiskey" C-m
tmux send-keys -t $SESSION:4.1 "cd ~/Projects/Octoblu/secondmen-worker" C-m
tmux send-keys -t $SESSION:4.1 "eval \$SERVICES/$RUN_SERVICE secondmen-worker tango" C-m

tmux send-keys -t $SESSION:5.0 "cd ~/Projects/Octoblu/nowmen-worker" C-m
tmux send-keys -t $SESSION:5.0 "eval \$SERVICES/$RUN_SERVICE nowmen-worker whiskey" C-m
tmux send-keys -t $SESSION:5.1 "cd ~/Projects/Octoblu/nowmen-worker" C-m
tmux send-keys -t $SESSION:5.1 "eval \$SERVICES/$RUN_SERVICE nowmen-worker tango" C-m

tmux send-keys -t $SESSION:6.0 "cd ~/Projects/Octoblu/nanocyte-flow-deploy-service" C-m
tmux send-keys -t $SESSION:6.0 "eval \$SERVICES/$RUN_SERVICE nanocyte-flow-deploy-service" C-m

tmux send-keys -t $SESSION:7.0 "cd ~/Projects/Octoblu/nanocyte-node-registry" C-m
tmux send-keys -t $SESSION:7.0 "eval \$SERVICES/$RUN_SERVICE nanocyte-node-registry" C-m

tmux send-keys -t $SESSION:8.0 "cd ~/Projects/Octoblu/credentials-worker" C-m
tmux send-keys -t $SESSION:8.0 "eval \$SERVICES/$RUN_SERVICE credentials-worker" C-m
tmux send-keys -t $SESSION:8.1 "cd ~/Projects/Octoblu/credentials-service" C-m
tmux send-keys -t $SESSION:8.1 "eval \$SERVICES/$RUN_SERVICE credentials-service" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
