#!/bin/bash
sudo -i

cp /opt/files/*.crt /usr/local/share/ca-certificates/
update-ca-certificates

echo 192.168.250.21 mysite.local www.mysite.local wordpress >> /etc/hosts
mkdir -p /root/volumes/influxdb
mkdir -p /root/volumes/chronograf
mkdir -p /root/volumes/kapacitor
mkdir -p /root/volumes/config
chmod 777 -R /root/volumes/
cp /opt/files/config/* /root/volumes/config/
cp /opt/files/docker-compose.yml /root/

apt update -y
apt install wget ca-certificates curl -y
# # docker install
install -m 0755 -d /etc/apt/keyrings
curl -fsSL --insecure  https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update 
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# apt-get -y -o Acquire::https::Verify-Peer=false update 
# apt-get -y -o Acquire::https::Verify-Peer=false install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# cat > /etc/docker/daemon.json << EOL
# {
#           "insecure-registries": ["registry-1.docker.io"]
# } 
# EOL
# systemctl restart docker
# ##openssl s_client -showcerts -connect registry-1.docker.io:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/docker/certs.d/registry-1.docker.io/ca.crt
docker compose up -d

# wget --no-check-certificate -q https://repos.influxdata.com/influxdata-archive_compat.key
# echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c &&
#  cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
# echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list 
# apt-get -y -o Acquire::https::Verify-Peer=false update 
# apt-get -y -o Acquire::https::Verify-Peer=false install influxdb2

