#!/bin/sh
trap "exit" INT

cd $(dirname $0)

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

COMPOSE_VER=$(docker-compose --version | grep -oE '\b([0-9]+\.[0-9]+)\b')
MIN_COMPOSE_VER=1.6
echo "docker-compose --version $COMPOSE_VER >= $MIN_COMPOSE_VER ?"
if ! echo $COMPOSE_VER $MIN_COMPOSE_VER | awk '{exit $1>=$2?0:1}'; then
  echo "minimum docker-compose version should be $MIN_COMPOSE_VER" \
        $'\n'$'   ¯\_(ツ)_/¯'
  exit 1
fi

#node
npm install --global growl-express
