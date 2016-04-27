#!/usr/bin/env bash

cd $(dirname $0)
SESSION="$1"

getProject() {
  jq -s add ../generator/projects/*.json | \
  jq ".[] | select(.container==\"$1\") | .project" | \
  sed -e 's|"||g'
}

PROJECT=$(getProject $1)
if [[ -z "$PROJECT" ]]; then
  PROJECT=$(getProject meshblu-$1)
fi
if [[ -z "$PROJECT" ]]; then
  PROJECT=$1
fi

. ./_defaults.sh

tmux new-window -t $SESSION:1 -n $1

tmux send-keys -t $SESSION:1.0 "cd ~/Projects/Octoblu/$PROJECT" C-m
tmux send-keys -t $SESSION:1.0 "eval \$SERVICES/$RUN_SERVICE $PROJECT" C-m

tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
