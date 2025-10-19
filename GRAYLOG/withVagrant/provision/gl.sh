#!/bin/bash
sudo -i

# cp /opt/files/checkcert.cer /usr/local/share/ca-certificates/checkcert.crt
# update-ca-certificates

# cp /opt/files/prom-services/* /etc/systemd/system/

echo 192.168.250.21 mysite.local www.mysite.local wordpress >> /etc/hosts

apt-get -y update
apt-get -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin pwgen
systemctl enable --now docker

unalias cp
cp -f /opt/files/docker-compose.yml ./docker-compose.yml
cp -f /opt/files/log_pipeline.yaml ./

echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sysctl -p

# echo GRAYLOG_PASSWORD_SECRET=$(pwgen -N 1 -s 96) > ./.env
echo GRAYLOG_PASSWORD_SECRET=PaSSw0rdPaSSw0rd > ./.env
echo GRAYLOG_ROOT_PASSWORD_SHA2=$(echo -n PaSSw0rd | shasum -a 256 | awk '{print $1}') >> ./.env
#ojWKoeDJAY

docker compose up -d
