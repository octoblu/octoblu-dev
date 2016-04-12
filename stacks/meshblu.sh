#!/usr/bin/env bash

cd $(dirname $0)
SESSION='meshblu'
. ./_defaults.sh

tmux new-window -t $SESSION:1 -n proxy
tmux new-window -t $SESSION:2 -n frontends
tmux new-window -t $SESSION:3 -n core
tmux new-window -t $SESSION:4 -n firehose
tmux new-window -t $SESSION:5 -n obscure-frontends

tmux split-window -t $SESSION:2 -d -p 33
tmux split-window -t $SESSION:2 -d -p 50

tmux split-window -t $SESSION:3 -d -p 33
tmux split-window -t $SESSION:3 -d -p 50

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/meshblu-haproxy" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/run-service-docker.sh meshblu-haproxy" C-m

tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/meshblu-server-http" C-m
tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE meshblu-server-http" C-m
tmux send-keys -t $SESSION:2.1 "cd ~/Projects/Octoblu/meshblu-server-socket.io-v1" C-m
tmux send-keys -t $SESSION:2.1 "eval \$SERVICES/$RUN_SERVICE meshblu-server-socket.io-v1" C-m
tmux send-keys -t $SESSION:2.2 "cd ~/Projects/Octoblu/meshblu-server-websocket" C-m
tmux send-keys -t $SESSION:2.2 "eval \$SERVICES/$RUN_SERVICE meshblu-server-websocket" C-m

tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/meshblu-core-dispatcher" C-m
tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE meshblu-core-dispatcher whiskey" C-m
tmux send-keys -t $SESSION:3.1 "cd ~/Projects/Octoblu/meshblu-core-dispatcher" C-m
tmux send-keys -t $SESSION:3.1 "eval \$SERVICES/$RUN_SERVICE meshblu-core-dispatcher tango" C-m
tmux send-keys -t $SESSION:3.2 "cd ~/Projects/Octoblu/meshblu-core-dispatcher" C-m
tmux send-keys -t $SESSION:3.2 "eval \$SERVICES/$RUN_SERVICE meshblu-core-dispatcher foxtrot" C-m

tmux send-keys -t $SESSION:4.0 "cd ~/Projects/Octoblu/meshblu-core-firehose-socket.io" C-m
tmux send-keys -t $SESSION:4.0 "eval \$SERVICES/$RUN_SERVICE meshblu-core-firehose-socket.io" C-m

tmux send-keys -t $SESSION:5.0 "cd ~/Projects/Octoblu/meshblu-core-protocol-adapter-xmpp" C-m
tmux send-keys -t $SESSION:5.0 "eval \$SERVICES/run-service-docker meshblu-core-protocol-adapter-xmpp" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
