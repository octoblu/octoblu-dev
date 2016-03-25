#!/bin/sh
CONTAINER_IP=$(ip addr show eth0 | grep -oE "\b([0-9]+\.){3,3}[0-9]+\b")

echo "+ iptables $CONTAINER_IP:80 -> $MACHINE_HOST:$SERVICE_PORT"

iptables -t nat -A PREROUTING -p tcp \
  --dport 80 -j DNAT --to-destination $MACHINE_HOST:$SERVICE_PORT

iptables -t nat -A POSTROUTING -p tcp \
  -d $MACHINE_HOST --dport $SERVICE_PORT -j SNAT --to-source $CONTAINER_IP

sleep infinity
