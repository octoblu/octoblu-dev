#!/usr/bin/env bash

(kill $(cat /tmp/growl-express.pid)) 2>/dev/null
echo - growl-express
