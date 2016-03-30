#!/usr/bin/env bash

echo "growl notify $1"$'\n' >&2

if [[ -z "$1" ]]; then
  echo "usage: $0 '<json string>'"
  exit 1
fi

if [[ -z "$MACHINE_HOST" ]]; then
  MACHINE_HOST=localhost
fi

curl --connect-timeout 3 --silent \
  --header "Content-Type: application/json" --request POST \
  --data "$1" http://$MACHINE_HOST:23054/notify 2>/dev/null
