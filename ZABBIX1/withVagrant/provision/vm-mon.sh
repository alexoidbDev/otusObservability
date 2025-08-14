sudo -i

apt update -y
apt install wget -y
wget --no-check-certificate https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
apt update -y

apt install -y zabbix-agent zabbix-sender
cp /opt/files/lld.conf /etc/zabbix/zabbix_agentd.d/
mkdir -p /usr/local/zabbix/
chmod 775 /usr/local/zabbix/
chown zabbix /usr/local/zabbix/
cp /opt/files/metrics.sh /usr/local/
chmod +x /usr/local/metrics.sh
cp -y /opt/files/zabbix_agentd.conf /etc/zabbix/
systemctl restart zabbix-agent
systemctl enable zabbix-agent