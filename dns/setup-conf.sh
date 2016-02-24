#!/bin/bash

sed -e "s|{{IP}}|${1}|" \
    -e "s|{{USER}}|${USER}|" \
  <./dnsmasq.conf.template >/usr/local/etc/dnsmasq.conf
