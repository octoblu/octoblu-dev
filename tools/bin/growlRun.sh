#!/usr/bin/env bash

if [[ -z "$@" ]]; then
  echo "usage: $0 [cmd...]"
  exit 1
fi

if [[ -z "$MACHINE_HOST" ]]; then
  MACHINE_HOST=localhost
fi

notify() {
  curl -s -H "Content-Type: application/json" -X POST \
    -d "$1" http://$MACHINE_HOST:23054/notify >/dev/null 2>&1 &
}

notify "{\"text\":\"$@\",\"options\":{\"title\":\"launching\"}}"

$@
STATUS_CODE=$?

if [[ $STATUS_CODE = 0 ]]; then
  notify "{\"text\":\"$@\",\"options\":{\"label\":\"success\",\"title\":\"success\"}}"
else
  notify "{\"text\":\"$@\",\"options\":{\"label\":\"error\",\"title\":\"error ($STATUS_CODE)\",\"sticky\":true}}"
fi
