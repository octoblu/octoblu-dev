#!/bin/sh
brew install docker-machine
brew link --overwrite docker
brew install docker-compose

#dnsmasq
brew install dnsmasq
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo mkdir -p /etc/resolver
sudo cp dns/resolver-dev /etc/resolver/dev
cp dns/dnsmasq.conf /usr/local/etc/
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl start homebrew.mxcl.dnsmasq

docker-machine create --driver virtualbox --virtualbox-disk-size "100000" --virtualbox-memory "4096" --virtualbox-cpu-count "4" octoblu-dev

echo "ifconfig eth1 192.168.99.50 netmask 255.255.255.0 broadcast 192.168.99.255 up" | \
  docker-machine ssh octoblu-dev sudo tee /var/lib/boot2docker/bootsync.sh >/dev/null

sleep 5
docker-machine stop octoblu-dev
docker-machine start octoblu-dev
sleep 5
docker-machine regenerate-certs -f octoblu-dev
echo --- certs regenerated

(cd commands.d; ./start.sh; ./generate.sh meshblu)
cp generators/output/* services
