#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# https://docs.rocket.chat/docs/minio#setup-rocketchat-to-use-minio

docker compose -f /opt/conf/monitor.docker-compose.yml up -d