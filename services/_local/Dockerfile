FROM debian
MAINTAINER Octoblu, Inc. <docker@octoblu.com>

EXPOSE 80

RUN apt-get update
RUN apt-get install -y iptables

WORKDIR /usr/src/app
ADD start-forward.sh /usr/src/app

CMD ./start-forward.sh
