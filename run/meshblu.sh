#!/bin/sh
#!/bin/bash

source ~/.profile

SESSION='meshblu-development'
nvm use 5

tmux start-server
tmux new-session -d -s $SESSION -n √ø

tmux new-window -t $SESSION:1 -n meshblu-old
tmux new-window -t $SESSION:2 -n meshblu-server-http
tmux new-window -t $SESSION:3 -n meshblu-core-dispatcher
tmux new-window -t $SESSION:4 -n meshblu

tmux split-window -t $SESSION:1 -d -p 20
tmux split-window -t $SESSION:1 -d -p 20

tmux split-window -t $SESSION:2 -d -p 20
tmux split-window -t $SESSION:2 -d -p 20

tmux split-window -t $SESSION:3 -d -p 20
tmux split-window -t $SESSION:3 -d -p 20

tmux split-window -t $SESSION:4 -d -p 20
tmux split-window -t $SESSION:4 -d -p 20

tmux send-keys -t $SESSION:0.0 C-m
tmux send-keys -t $SESSION:0.0 "tmux kill-session -t $SESSION"



tmux send-keys -t $SESSION:1.0 "cd $NANOCYTE_ENGINE_HTTP" C-m
tmux send-keys -t $SESSION:1.1 "cd $NANOCYTE_ENGINE_HTTP; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:1.1 "cd $NANOCYTE_ENGINE_HTTP; PORT=5050 $MESHBLU_LOCAL_ENV $DEBUG_AND_START_ENV" C-m
tmux send-keys -t $SESSION:1.2 "cd $NANOCYTE_ENGINE_WORKER; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:1.2 "cd $NANOCYTE_ENGINE_WORKER; $NANOCYTE_NODE_REGISTRY_URL_ENV $MESHBLU_LOCAL_ENV $DEBUG_AND_START_ENV" C-m

tmux send-keys -t $SESSION:2.0 "cd $NANOCYTE_INTERVAL_SERVICE" C-m
tmux send-keys -t $SESSION:2.1 "cd $NANOCYTE_INTERVAL_SERVICE; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:2.1 "cd $NANOCYTE_INTERVAL_SERVICE; PORT=7071 $DEBUG_AND_START_ENV" C-m
tmux send-keys -t $SESSION:2.2 "cd $NANOCYTE_INTERVAL_REDIS; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:2.2 "cd $NANOCYTE_INTERVAL_REDIS; PORT=5555  $DEBUG_AND_START_ENV" C-m

tmux send-keys -t $SESSION:3.0 "cd $NANOCYTE_FLOW_DEPLOY" C-m
tmux send-keys -t $SESSION:3.1 "cd $NANOCYTE_FLOW_DEPLOY; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:3.1 "cd $NANOCYTE_FLOW_DEPLOY; PORT=5051 $MESHBLU_LOCAL_ENV $NANOCYTE_ENGINE_ENV $NODE_REGISTRY_URL_ENV OCTOBLU_URL=http://localhost:8080 $DEBUG_AND_START_ENV" C-m

tmux send-keys -t $SESSION:4.0 "cd $NANOCYTE_NODE_REGISTRY" C-m
tmux send-keys -t $SESSION:4.1 "cd $NANOCYTE_NODE_REGISTRY; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:4.1 "cd $NANOCYTE_NODE_REGISTRY; NODE_DEBUG=request PORT=9999 $CREDENTIALS_UUID_ENV $NANOCYTE_INTERVAL_UUID_ENV $DEBUG_AND_START_ENV" C-m

tmux send-keys -t $SESSION:5.0 "cd $CREDENTIALS" C-m
tmux send-keys -t $SESSION:5.1 "cd $CREDENTIALS; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:5.1 "cd $CREDENTIALS; REDIS_URI='redis://127.0.0.1/6379' PORT=5454 $CREDENTIALS_UUID_ENV node command.js" C-m
tmux send-keys -t $SESSION:5.2 "cd $CREDENTIALS_WORKER; $NVM_USE_AND_INSTALL" C-m
tmux send-keys -t $SESSION:5.2 "cd $CREDENTIALS_WORKER; REDIS_URI='redis://127.0.0.1/6379' NODE_DEBUG=request MONGODB_URI='mongodb://127.0.0.1/meshines' $CREDENTIALS_UUID_ENV node command.js " C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
