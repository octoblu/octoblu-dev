#!/bin/bash

(
  cd $HOME/Projects/Octoblu/octoblu-dev/generators
  npm i
  coffee generate.coffee -c 'dockerfile: Dockerfile-dev' -p meshblu-haproxy -d meshblu
  coffee generate.coffee -l redis-tmp -p meshblu -d meshblu-old
  coffee generate.coffee -l redis-tmp -p meshblu-server-http
  coffee generate.coffee -l redis-tmp -c 'command: node command-dispatch.js' -p meshblu-core-dispatcher
  cp output/*.env ../services
)
