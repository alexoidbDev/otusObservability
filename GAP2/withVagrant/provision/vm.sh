#!/bin/bash
sudo -i

apt update -y
apt install wget -y
wget --no-check-certificate https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.122.0/victoria-metrics-linux-amd64-v1.122.0.tar.gz
tar zxf victoria-metrics-linux-amd64-v1.122.0.tar.gz
mv victoria-metrics-prod /usr/local/bin/victoria-metrics
mkdir -p /var/lib/victoriametrics
useradd -r -c 'VictoriaMetrics TSDB Service' -s /usr/sbin/nologin victoriametrics
chown victoriametrics: /var/lib/victoriametrics
cp /opt/files/victoriametrics.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable victoriametrics --now
ufw allow 8428