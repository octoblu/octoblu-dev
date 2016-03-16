#!/bin/sh
. ./bootstrap-core.sh

brew install docker-machine-driver-xhyve
brew install xhyve

# docker-machine-driver-xhyve need root owner and uid
sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve

docker-machine create \
  --driver xhyve \
  --xhyve-disk-size "100000" \
  --xhyve-memory-size "4096" \
  --xhyve-cpu-count "4" \
  octoblu-dev

docker-machine-unfs octoblu-dev
