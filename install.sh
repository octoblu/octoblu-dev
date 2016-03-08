#!/bin/sh
trap "exit" INT

brew install docker-machine
brew link --overwrite docker
brew install docker-compose

#dnsmasq
sudo sysctl -w kern.ipc.somaxconn=4096
brew install dnsmasq
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -p /etc/resolver
sudo cp services-core/dnsmasq/resolver-dev /etc/resolver/dev
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
(cd services-core/dnsmasq; ./setup.sh 127.0.0.1 127.0.0.1)
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

docker-machine create \
  --driver xhyve \
  --xhyve-disk-size "250000" \
  --xhyve-memory-size "4096" \
  --xhyve-cpu-count "4" \
  octoblu-dev

docker-machine-nfs octoblu-dev \
  --shared-folder=/Users \
  --mount-opts="vers=3,udp"

(cd generator/bin; npm install)
./start.sh
(cd db-setup; ./setup-mongo.sh mongo-persist)
