#!/bin/sh
brew install docker-machine
brew install docker-compose

#dnsmasq
brew install dnsmasq
cp dnsmasq.conf /usr/local/etc/
sudo mkdir -p /etc/resolver
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq

sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

docker-machine create --driver virtualbox tech-com
docker-osx-dev install


docker run -d -p 50801:50801 -p 80:80 -v $PWD/traefik.toml:/traefik.toml emilevauge/traefik
