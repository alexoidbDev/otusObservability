#!/bin/bash
sudo -i

#cp /opt/files/*.cer /usr/local/share/ca-certificates/
#update-ca-certificates

cp /opt/files/prom-services/* /etc/systemd/system/

echo 192.168.250.21 mysite.local www.mysite.local wordpress >> /etc/hosts
echo 192.168.250.23 victoriametrics >> /etc/hosts

apt update -y
apt install wget -y
wget --no-check-certificate https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz
useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus
mkdir -p /var/lib/prometheus

tar -xvzf prometheus-2.44.0.linux-amd64.tar.gz
mv prometheus-2.44.0.linux-amd64 prometheuspackage
cp prometheuspackage/{prometheus,promtool} /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
cp -r prometheuspackage/{consoles,console_libraries} /etc/prometheus
cp /opt/files/{rules,prometheus,alertmanager}.yml /etc/prometheus/


ALERT_MANAGER=alertmanager-0.28.1.linux-amd64
ALERT_MANAGER_ARCH=$ALERT_MANAGER.tar.gz
wget --no-check-certificate https://github.com/prometheus/alertmanager/releases/download/v0.28.1/$ALERT_MANAGER_ARCH
tar -zxf $ALERT_MANAGER_ARCH
cp $ALERT_MANAGER/{alertmanager,amtool} /usr/local/bin/
# cp $ALERT_MANAGER/alertmanager.yml /etc/prometheus
mkdir -p /var/lib/alertmanager
echo "ALERTMANAGER_OPTS=\"\"" > /etc/default/alertmanager
chown -R prometheus:prometheus /etc/prometheus /var/lib/alertmanager /usr/local/bin/{alertmanager,amtool} /var/lib/prometheus /etc/default/alertmanager


systemctl daemon-reload
systemctl enable prometheus --now
systemctl enable prometheus-alertmanager --now