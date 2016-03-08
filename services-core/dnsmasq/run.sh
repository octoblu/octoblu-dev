#!/bin/bash
eval $(docker-machine env --shell bash octoblu-dev)
IP=$(docker-machine ip octoblu-dev)
HOST=127.0.0.1,$(docker-machine ip octoblu-dev | sed -e 's|\.[0-9]*$|.1|')
./setup.sh $IP $HOST
pkill dnsmasq
echo + dnsmasq
