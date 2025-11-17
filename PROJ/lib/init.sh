#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

entries=(
    "192.168.250.10 balancer"
    "192.168.250.11 app-node-1"
    "192.168.250.12 app-node-2"
    "192.168.250.13 app-node-3"
    "192.168.250.21 database"
    "192.168.250.22 storage"
    "192.168.250.30 monitor"
)

for entry in "${entries[@]}"; do
    if ! grep -qF "$entry" /etc/hosts; then
        echo "Adding $entry в /etc/hosts"
        echo "$entry" | sudo tee -a /etc/hosts > /dev/null
    else
        echo "$entry already exists in /etc/hosts"
    fi
done

if [ -f /opt/conf/checkcert.cer ]; then
  sudo cp /opt/conf/checkcert.cer /usr/local/share/ca-certificates/checkcert.crt
  sudo update-ca-certificates
fi  

sudo apt update && sudo apt install -y net-tools vim htop tree ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install docker
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# post install actions
sudo usermod -aG docker vagrant

# configure alternative Dockerhub mirrors
sudo mkdir -p /etc/docker
echo '{"registry-mirrors": ["https://cr.yandex/mirror", "https://mirror.gcr.io"]}' | sudo tee /etc/docker/daemon.json > /dev/null
sudo systemctl restart docker

docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

echo "VM IS READY!"
exit 0