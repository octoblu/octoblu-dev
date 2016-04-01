#!/usr/bin/env bash
sudo sysctl -w kern.ipc.somaxconn=4096
sudo sysctl -w kern.maxfiles=12288
sudo sysctl -w kern.maxfilesperproc=10240
ulimit -n 10240
