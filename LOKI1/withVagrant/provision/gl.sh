#!/bin/bash
sudo -i

# cp /opt/files/checkcert.cer /usr/local/share/ca-certificates/checkcert.crt
# update-ca-certificates

echo 192.168.250.21 mysite.local www.mysite.local wordpress >> /etc/hosts

apt update -y
apt -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt -y update
apt -y  install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker --now
sleep 2

cp /opt/files/docker-compose.yml ./
mkdir -p loki/data
chown 10001:10001 loki/data
mkdir loki/conf
cp /opt/files/loki/local-config.yaml loki/conf/
docker compose up -d

