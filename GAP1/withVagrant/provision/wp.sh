#!/bin/bash

#sudo dnf -y update
sudo -i 
#cp /opt/files/*.cer /etc/pki/ca-trust/source/anchors/
#update-ca-trust extract

dnf -y install nginx php php-fpm php-curl php-dom php-mbstring php-zip php-gd php-intl mariadb-server php-mysqli wget
dnf -y install epel-release
dnf -y install -y php-imagick

systemctl enable nginx --now
systemctl enable php-fpm --now
systemctl enable mariadb --now

echo 127.0.0.1  mysite.local www.mysite.local >> /etc/hosts
cp /opt/files/mysite.local.conf /etc/nginx/conf.d/
cp /opt/files/.htpasswd /etc/nginx/
mkdir -p /var/www/mysite.local
echo "<?php phpinfo(); ?>" > /var/www/mysite.local/index.php
mysql < /opt/files/createdb.sql
curl -sLO https://ru.wordpress.org/latest-ru_RU.tar.gz
tar -zxf latest-ru_RU.tar.gz -C /var/www/mysite.local/ --strip-components 1
chown -R apache:apache /var/www/mysite.local/
cp /opt/files/wp-config.php  /var/www/mysite.local/
#nginx -t && nginx -s reload
systemctl restart php-fpm
systemctl reload nginx

# exporters
setenforce 0
cp /opt/files/wp-services/* /etc/systemd/system/
# Node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xzfv node_exporter-1.5.0.linux-amd64.tar.gz
useradd -rs /bin/false nodeusr
mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
chown nodeusr:nodeusr /usr/local/bin/node_exporter
# Mysqld exporter
mkdir -p /etc/prometheus/exporters/
cp /opt/files/mysqld.conf /etc/prometheus/exporters/
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.17.2/mysqld_exporter-0.17.2.linux-amd64.tar.gz
tar xzvf mysqld_exporter-0.17.2.linux-amd64.tar.gz
mv mysqld_exporter-0.17.2.linux-amd64/mysqld_exporter /usr/local/bin/
# blackbox exporter
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.27.0/blackbox_exporter-0.27.0.linux-amd64.tar.gz
tar zxvf blackbox_exporter-0.27.0.linux-amd64.tar.gz
mv blackbox_exporter-0.27.0.linux-amd64/blackbox_exporter /usr/local/bin/
mv blackbox_exporter-0.27.0.linux-amd64/blackbox.yml /etc/prometheus/exporters/
#nginx exporter
wget https://github.com/nginx/nginx-prometheus-exporter/releases/download/v1.4.2/nginx-prometheus-exporter_1.4.2_linux_amd64.tar.gz
tar zxvf nginx-prometheus-exporter_1.4.2_linux_amd64.tar.gz
mv nginx-prometheus-exporter /usr/local/bin/
#php-fpm exporter
wget https://github.com/bakins/php-fpm-exporter/releases/download/v0.6.1/php-fpm-exporter.linux.amd64
mv php-fpm-exporter.linux.amd64 /usr/local/bin/php-fpm-exporter
chmod +x /usr/local/bin/php-fpm-exporter

systemctl daemon-reload
systemctl enable node_exporter --now
systemctl enable mysqld_exporter --now
systemctl enable blackbox_exporter --now
systemctl enable nginx-prometheus-exporter --now
systemctl enable php-fpm-exporter --now
