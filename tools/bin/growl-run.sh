#!/usr/bin/env bash

if [[ -z "$@" ]]; then
  echo "usage: $0 [cmd...]"
  exit 1
fi

notify="$HOME/Projects/Octoblu/octoblu-dev/tools/bin/growl-notify.sh"

$notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"success\",\"title\":\"+ started\"}}"
$@
STATUS_CODE=$?
$notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"error\",\"title\":\"- exit ($STATUS_CODE)\",\"sticky\":true}}"

sleep 1
exit $STATUS_CODE
