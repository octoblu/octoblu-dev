#!/bin/bash

echo - Træfɪk
docker kill traefik >/dev/null 2>&1
docker rm traefik >/dev/null 2>&1
