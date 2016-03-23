FROM debian
MAINTAINER Octoblu, Inc. <docker@octoblu.com>

EXPOSE 80

RUN apt-get update
RUN apt-get install -y iptables

WORKDIR /
ADD start-forward.sh /

CMD ./start-forward.sh
