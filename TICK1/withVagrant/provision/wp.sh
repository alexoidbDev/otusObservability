#!/bin/bash

sudo -i 
cp /opt/files/*.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust extract

# dnf -y update
dnf -y install nginx php php-fpm php-curl php-dom php-mbstring php-zip php-gd php-intl mariadb-server php-mysqli wget
dnf -y install epel-release
dnf -y install -y php-imagick

systemctl enable nginx --now
systemctl enable php-fpm --now
systemctl enable mariadb --now

echo 127.0.0.1  mysite.local www.mysite.local >> /etc/hosts
echo 192.168.250.22 influxdb mon >> /etc/hosts
cp /opt/files/mysite.local.conf /etc/nginx/conf.d/
# cp /opt/files/.htpasswd /etc/nginx/
mkdir -p /var/www/mysite.local
echo "<?php phpinfo(); ?>" > /var/www/mysite.local/index.php
mysql < /opt/files/createdb.sql
curl -sLO https://ru.wordpress.org/latest-ru_RU.tar.gz
tar -zxf latest-ru_RU.tar.gz -C /var/www/mysite.local/ --strip-components 1
chown -R apache:apache /var/www/mysite.local/
cp /opt/files/wp-config.php  /var/www/mysite.local/
sed -i '/pm\.status_path/s/^;*//' /etc/php-fpm.d/www.conf
#nginx -t && nginx -s reload
systemctl restart php-fpm
systemctl reload nginx

#### telegraf 

cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
[influxdata]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF
dnf -y install telegraf
cp /opt/files/telegraf.conf /etc/telegraf/telegraf.conf
setfacl -m u:telegraf:rw /var/run/php-fpm/www.sock
systemctl enable telegraf --now

# systemctl daemon-reload
