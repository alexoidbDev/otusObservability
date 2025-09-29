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
# setenforce 0
# cp /opt/files/wp-services/* /etc/systemd/system/

# echo "deb [trusted=yes] https://mirror.yandex.ru/mirrors/elastic/7/ stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
echo "deb [trusted=yes] https://mirror.yandex.ru/mirrors/elastic/8/ stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list