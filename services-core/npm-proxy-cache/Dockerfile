FROM node:5-onbuild
MAINTAINER Octoblu <docker@octoblu.com>
EXPOSE 80

CMD \
  while true; do \
    node_modules/npm-proxy-cache/bin/npm-proxy-cache  -e -t 86400 -h 0.0.0.0 -p 80; \
  done
