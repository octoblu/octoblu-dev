#!/bin/sh
CONTAINER=$(ip addr show eth0 | grep -oE "\b([0-9]+\.){3,3}[0-9]+\b")

echo "+ iptables $CONTAINER:80 -> $HOST:$PORT"

iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $HOST:$PORT
iptables -t nat -A POSTROUTING -p tcp -d $HOST --dport $PORT -j SNAT --to-source $CONTAINER

sleep infinity
