#!/bin/sh
brew install docker-machine
brew link --overwrite docker
brew install docker-compose

docker-machine create --driver virtualbox --virtualbox-disk-size "100000" --virtualbox-memory "4096" --virtualbox-cpu-count "4" octoblu-dev

#dnsmasq
brew install dnsmasq
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo mkdir -p /etc/resolver
sudo cp dns/resolver-dev /etc/resolver/dev
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

(cd commands.d; ./start.sh; ./generate.sh meshblu)
cp generators/output/* services
