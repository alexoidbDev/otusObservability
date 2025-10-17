#!/bin/bash

#sudo dnf -y update
sudo -i 
cp /opt/files/*.cer /etc/pki/ca-trust/source/anchors/
update-ca-trust extract

dnf -y install nginx php php-fpm php-curl php-dom php-mbstring php-zip php-gd php-intl mariadb-server php-mysqli wget
dnf -y install epel-release
dnf -y install -y php-imagick

systemctl enable nginx --now
systemctl enable php-fpm --now
systemctl enable mariadb --now

echo 127.0.0.1  mysite.local www.mysite.local wordpress >> /etc/hosts


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

rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-sidecar-repository-1-5.noarch.rpm
dnf -y install graylog-sidecar

curl --insecure -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-9.1.5-x86_64.rpm
# unalias cp
# cp -f /opt/files/filebeat-9.1.5-x86_64.rpm ./
rpm -vi filebeat-9.1.5-x86_64.rpm

# cp -f /opt/files/filebeat-9.1.5-linux-x86_64.tar.gz ./
# tar zxvf filebeat-9.1.5-linux-x86_64.tar.gz
# mkdir -p /opt/filebeat
# cp filebeat-9.1.5-linux-x86_64/filebeat /opt/filebeat
# ln -s /usr/bin/filebeat /opt/filebeat/filebeat

cp -f /opt/files/sidecar.yml ./
# vi /etc/graylog/sidecar/sidecar.yml
# graylog-sidecar -service install
# systemctl enable --now graylog-sidecar
# 1vp09ctekfdkjqfcsv6r2ot5kjk39t28kcfhmghasuej5i3v9f8o

systemctl daemon-reload



