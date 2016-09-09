#!/usr/bin/env bash

SESSION='slurry'

change_directory(){
  cd $(dirname $0)
}

join_existing_session(){
  tmux attach-session -t "$SESSION"
}

start_new(){
  . ./_defaults.sh

  tmux new-window -t $SESSION:1 -n exchange

  tmux split-window -t $SESSION:1 -d -p 50

  tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/slurry-exchange" C-m
  tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE slurry-exchange" C-m

  tmux select-window -t $SESSION:1
  tmux attach-session -t $SESSION
}


main(){
  change_directory
  join_existing_session || start_new
}
main $@
