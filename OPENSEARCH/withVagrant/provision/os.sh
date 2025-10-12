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
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
unalias cp
cp -f /opt/files/docker-compose.yml ./docker-compose.yml
cp -f /opt/files/log_pipeline.yaml ./
echo vm.max_map_count = 262144 > /etc/sysctl.d/99-max_map.conf
sysctl -p /etc/sysctl.d/99-max_map.conf

docker compose up -d

#sysctl vm.max_map_count=262144
# apt -y install curl lsb-release gnupg2 ca-certificates
# curl -fsSL https://artifacts.opensearch.org/publickeys/opensearch.pgp| gpg --dearmor -o /etc/apt/trusted.gpg.d/opensearch.gpg
# echo "deb https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt stable main" | tee /etc/apt/sources.list.d/opensearch-2.x.list
# echo "deb https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/2.x/apt stable main" | tee -a /etc/apt/sources.list.d/opensearch-2.x.list



# apt update -y
# apt -y install opensearch opensearch-dashboards
# unalias cp
# cp -f /opt/files/opensearch.yml /etc/opensearch/opensearch.yml
# chown -R opensearch:opensearch /var/log/opensearch/
# chown -R opensearch:opensearch /var/lib/opensearch/
# chown -R opensearch:opensearch /etc/opensearch/
# cp -f /opt/files/opensearch_dashboards.yml /etc/opensearch-dashboards/opensearch_dashboards.yml

# # sed -i 's/xpack.security.enabled: true/xpack.security.enabled: false/g' /etc/elasticsearch/elasticsearch.yml

# systemctl enable --now opensearch
# systemctl enable --now opensearch-dashboards