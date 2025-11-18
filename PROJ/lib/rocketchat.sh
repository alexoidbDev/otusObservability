#!/bin/bash
# https://docs.rocket.chat/docs/deploy-with-docker-docker-compose
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# docker pull mongo:6.0.18 # for verification

## https://github.com/RocketChat/Docker.Official.Image/blob/master/env.example
source /opt/conf/rocketchat-env.sh

## https://github.com/RocketChat/Docker.Official.Image/blob/master/compose.yml
docker compose -f /opt/conf/rocketchat.docker-compose.yml up -d

# docker logs -f rocketchat