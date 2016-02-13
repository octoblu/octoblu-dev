#!/bin/sh
brew install docker-machine
brew install docker-compose

docker-machine create --driver virtualbox tech-com
docker-osx-dev install
eval "$(docker-machine env tech-com)"
docker-compose up
docker-osx-dev
