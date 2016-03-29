#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "usage: $0 '<json string>'"
  exit 1
fi

if [[ -z "$MACHINE_HOST" ]]; then
  MACHINE_HOST=localhost
fi

curl -s -H "Content-Type: application/json" -X POST \
  -d "$1" http://$MACHINE_HOST:23054/notify 2>/dev/null
