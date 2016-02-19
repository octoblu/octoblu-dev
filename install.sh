#!/bin/sh
brew install docker-machine
brew link --overwrite docker
brew install docker-compose

#dnsmasq
brew install dnsmasq
cp dnsmasq.conf /usr/local/etc/
sudo mkdir -p /etc/resolver
sudo cp resolver/dev /etc/resolver/
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq

sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

docker-machine create --driver virtualbox octoblu-dev
(cd redis; ./run.sh)
(cd traefik; ./run.sh)

(cd commands.d; ./generate.sh meshblu)
cp generators/output/*.env services
