#!/usr/bin/env bash

if [[ -z "$@" ]]; then
  echo "usage: $0 [cmd...]"
  exit 1
fi

GROWL_NOTIFY="$(dirname $0)/growl-notify.sh"

notify () {
  $GROWL_NOTIFY "$@" >/dev/null &
}

notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"success\",\"title\":\"+ service started\"}}"
echo "$@"
$@
STATUS_CODE=$?
notify "{\"text\":\"$PROJECT_NAME\",\"options\":{\"label\":\"error\",\"title\":\"- service exit ($STATUS_CODE)\"}}"

sleep 1
exit $STATUS_CODE
