#!/bin/bash
sudo -i

cp /opt/files/checkcert.cer /usr/local/share/ca-certificates/checkcert.crt
update-ca-certificates

# cp /opt/files/prom-services/* /etc/systemd/system/

echo 192.168.250.21 mysite.local www.mysite.local wordpress >> /etc/hosts

echo "deb [trusted=yes] https://mirror.yandex.ru/mirrors/elastic/8/ stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

apt update -y
apt install wget -y
wget --no-check-certificate "https://storage.yandexcloud.net/cloud-certs/CA.pem" --output-document ./YACA.crt
cp ./YACA.crt /usr/local/share/ca-certificates/
update-ca-certificates

apt update -y
apt -y install elasticsearch
sed -i 's/xpack.security.enabled: true/xpack.security.enabled: false/g' /etc/elasticsearch/elasticsearch.yml
systemctl enable elasticsearch.service --now

apt -y install kibana
export TOKEN=$(/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana)
echo server.host: \"0.0.0.0\" >> /etc/kibana/kibana.yml
echo elasticsearch.serviceAccountToken: \"$TOKEN\" >> /etc/kibana/kibana.yml
echo elasticsearch.hosts: [\"http://localhost:9200\"] >> /etc/kibana/kibana.yml
systemctl enable kibana --now

apt -y install heartbeat-elastic
#  cp /opt/files/monitors/* /etc/heartbeat/monitors.d/
cp /opt/files/heartbeat.yml /etc/heartbeat/
systemctl enable heartbeat-elastic --now
# systemctl daemon-reload
