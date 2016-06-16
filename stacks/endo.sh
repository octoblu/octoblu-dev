#!/usr/bin/env bash

SESSION='endo'

change_directory(){
  cd $(dirname $0)
}

join_existing_session(){
  tmux attach-session -t "$SESSION"
}

start_new(){
  . ./_defaults.sh

  tmux new-window -t $SESSION:1 -n UI
  tmux new-window -t $SESSION:2 -n github
  tmux new-window -t $SESSION:3 -n sendgrid

  tmux split-window -t $SESSION:1 -d -p 50

  tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/endo-manager" C-m
  tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE endo-manager" C-m

  tmux send-keys -t $SESSION:1.1 "cd ~/Projects/Octoblu/form-service" C-m
  tmux send-keys -t $SESSION:1.1 "eval \$SERVICES/$RUN_SERVICE form-service" C-m

  tmux send-keys -t $SESSION:2.0 "cd ~/Projects/Octoblu/endo-github" C-m
  tmux send-keys -t $SESSION:2.0 "eval \$SERVICES/$RUN_SERVICE endo-github" C-m

  tmux send-keys -t $SESSION:3.0 "cd ~/Projects/Octoblu/endo-sendgrid" C-m
  tmux send-keys -t $SESSION:3.0 "eval \$SERVICES/$RUN_SERVICE endo-sendgrid" C-m

  tmux select-window -t $SESSION:1
  tmux attach-session -t $SESSION
}


main(){ 
  change_directory 
  join_existing_session || start_new
}
main $@
