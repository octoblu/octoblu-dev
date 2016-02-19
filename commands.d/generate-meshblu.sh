#!/bin/bash

(
  cd $HOME/Projects/Octoblu/octoblu-dev/generators
  npm i
  coffee generate.coffee -p meshblu-haproxy -d meshblu
  coffee generate.coffee -p meshblu -d meshblu-old
  coffee generate.coffee -p meshblu-server-http
  coffee generate.coffee -p meshblu-core-dispatcher
  cp output/*.env ../services
)
