#!/usr/bin/env bash

if [[ -z "$@" ]]; then
  echo "usage: $0 [cmd...]"
  exit 1
fi

if [[ -z "$MACHINE_HOST" ]]; then
  MACHINE_HOST=localhost
fi

notify() {
  cmd='curl -vvv -s -H "Content-Type: application/json" -X POST \
            -d '$"'$@'"$' http://'$"$MACHINE_HOST"$':23054/notify'
  eval "$cmd" >/dev/null 2>&1 &
}

notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"success\",\"title\":\"+ started\"}}"
$@
STATUS_CODE=$?
notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"error\",\"title\":\"- exit ($STATUS_CODE)\",\"sticky\":true}}"

sleep 1
exit $STATUS_CODE
