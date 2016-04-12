#!/usr/bin/env bash

lockfile=$1
echo "Lock wait for $2..."
while ! shlock -f $lockfile -p $PPID; do
  sleep 1
  echo -n '.'
done
