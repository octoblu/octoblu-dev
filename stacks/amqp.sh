#!/usr/bin/env bash

cd $(dirname $0)
SESSION='amqp'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n rabbitmq
tmux new-window -t $SESSION:2 -n meshblu-amqp

tmux split-window -t $SESSION:2 -d -p 33
tmux split-window -t $SESSION:2 -d -p 50

TOOLS=$SERVICES/../tools/bin
tmux set-environment -t $SESSION TOOLS $TOOLS

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/octoblu-dev/services-aux/rabbitmq" C-m
tmux send-keys -t $SESSION:1.0 "sleep 10" C-m
tmux send-keys -t $SESSION:1.0 "./stop.sh; ./run.sh; docker attach rabbitmq" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/meshblu-amqp-auth-service" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE meshblu-amqp-auth-service" C-m

tmux send-keys -t $SESSION:2.1 "cd ~/Projects/Octoblu/meshblu-core-worker-amqp" C-m
tmux send-keys -t $SESSION:2.1 "sleep 20" C-m
tmux send-keys -t $SESSION:2.1 "eval \$SERVICES/$RUN_SERVICE meshblu-core-worker-amqp" C-m

tmux send-keys -t $SESSION:2.2 "cd ~/Projects/Octoblu/meshblu-core-worker-firehose-amqp" C-m
tmux send-keys -t $SESSION:2.2 "sleep 20" C-m
tmux send-keys -t $SESSION:2.2 "eval \$SERVICES/$RUN_SERVICE meshblu-core-worker-firehose-amqp" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
