#!/usr/bin/env bash

sed -e "s|{{IP}}|${1}|" \
    -e "s|{{HOST}}|${2}|" \
    -e "s|{{USER}}|${USER}|" \
  <./dnsmasq.conf.template >/usr/local/etc/dnsmasq.conf
