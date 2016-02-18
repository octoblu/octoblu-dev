#!/bin/sh
brew install docker-machine
brew install docker-compose

#dnsmasq
brew install dnsmasq
cp dnsmasq.conf /usr/local/etc/
sudo pkill dnsmasq
sudo mkdir -p /etc/resolver
sudo cp resolver/dev /etc/resolver/
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq

sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

docker-machine create --driver virtualbox octoblu-dev
eval $(docker-machine env --shell bash octoblu-dev)
docker run -d -p 50801:50801 -p 80:80 -v $PWD/traefik.toml:/traefik.toml emilevauge/traefik
