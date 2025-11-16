#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# https://docs.rocket.chat/docs/minio#setup-rocketchat-to-use-minio

export MINIO_ROOT_USER=minioadmin
export MINIO_ROOT_PASSWORD=minioadmin123
export MINIO_PROMETHEUS_AUTH_TYPE=public

docker compose -f /opt/conf/minio.docker-compose.yml up -d