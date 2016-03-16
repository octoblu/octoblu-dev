#!/bin/sh
trap "exit" INT

#dnsmasq
sudo sysctl -w kern.ipc.somaxconn=4096
brew install dnsmasq
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -p /etc/resolver
sudo cp ../services-core/dnsmasq/resolver-dev /etc/resolver/dev
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
(cd ../services-core/dnsmasq; ./setup.sh 127.0.0.1 127.0.0.1)
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

#docker
brew update
brew install docker-machine
brew link --overwrite docker
brew install docker-compose
brew link --overwrite docker-compose
