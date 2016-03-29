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
  --xhyve-cpu-count "2" \
  octoblu-dev || \
docker-machine start octoblu-dev

brew install unfs3
curl -s https://raw.githubusercontent.com/erikwilson/docker-machine-unfs/master/docker-machine-unfs \
  >/usr/local/bin/docker-machine-unfs && \
  chmod +x /usr/local/bin/docker-machine-unfs
docker-machine-unfs octoblu-dev
