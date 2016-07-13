#!/usr/bin/env bash
cd $(dirname $0)
set -eE
trap "exit" INT

#brew install
brew update
brew install --force dnsmasq
MIN_DOCKER_MACHINE_VER=0.7
DOCKER_MACHINE_VER=$(docker-machine --version | grep -oE '([0-9]+\.[0-9]+)')
if ! echo $DOCKER_MACHINE_VER $MIN_DOCKER_MACHINE_VER | awk '{exit $1>=$2?0:1}'; then
  for package in docker docker-machine docker-compose; do
    brew unlink $package || true
    brew install $package
    brew link --overwrite $package
  done
fi

MIN_COMPOSE_VER=1.6
COMPOSE_VER=$(docker-compose --version | grep -oE '([0-9]+\.[0-9]+)')
if ! echo $COMPOSE_VER $MIN_COMPOSE_VER | awk '{exit $1>=$2?0:1}'; then
  echo  $'\n'$'`docker-compose --version`'$" of $COMPOSE_VER should be >= $MIN_COMPOSE_VER"$'\n' \
        $'... good luck!'$'\n' \
        $'   ¯\_(ツ)_/¯'
  exit 1
fi

MIN_NODE_VER=5
NODE_VER=$(node --version | grep -oE '([0-9]+\.[0-9]+)')
if ! echo $NODE_VER $MIN_NODE_VER | awk '{exit $1>=$2?0:1}'; then
  echo  $'\n'$'`node --version`'$" of $NODE_VER should be >= $MIN_NODE_VER"$'\n' \
        $'... try `nvm use '$"$MIN_NODE_VER"$'`?'$'\n' \
        $'   ¯\_(ツ)_/¯'
  exit 1
fi

../tools/bin/unlimit.sh

# https certs
sudo security add-trusted-cert -d -k /Library/Keychains/System.keychain ../tools/certs/octoblu-dev.crt

# dnsmasq
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir -p /etc/resolver
sudo cp ../services-core/dnsmasq/resolver-dev /etc/resolver/dev
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
sudo chown root /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
(cd ../services-core/dnsmasq; ./setup.sh 127.0.0.1 127.0.0.1)
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

# node
npm install --global growl-express
(cd ../generator/bin && npm install)

# setup machine defaults, create bootstrap-local.env if doesn't exist
./bootstrap-setup-env.sh
