## Установка и настройка TICK стека

### Цель:
Установить и настроить Telegraf, Influxdb, Chronograf, Kapacitor.

Результатом выполнения данного ДЗ будет являться публичный репозиторий, в системе контроля версий (Github, Gitlab, etc.), в котором будет находиться Readme с описанием выполненных действий. Файлы конфигурации Telegraf, Influxdb, Chronograf, Kapacitor должны находиться в директории TICK-1.

### Описание/Пошаговая инструкция выполнения домашнего задания:
1. На виртуальной машине установите любую open source CMS, которая включает в себя следующие компоненты: nginx, php-fpm, database (MySQL or Postgresql);
2. На этой же виртуальной машине установите Telegraf для сбора метрик со всех компонентов системы (начиная с VM и заканчивая DB);
3. На этой же или дополнительной виртуальной машине установите Influxdb, Chronograf, Kapacitor
4. Настройте отправку метрик в InfluxDB.
5. Создайте сводный дашборд с самыми на ваш взгляд важными графиками, которые позволяют оценить работоспостобность вашей CMS;
6. Настройте правила алертинга для черезмерного потребления ресурсов, падения компонентов CMS и 500х ошибок

### Критерии оценки:
0 баллов - задание не выполнено согласно инструкции
1 балл - задание выполнено успешно согласно инструкции

## Решение 

На виртуальной машине устанавливаю open source CMS - wordpress, которая включает в себя следующие компоненты: nginx, php-fpm, mysql database (mariadb).
На эту же виртуальную машину устанавливаю Telegraf и выдаю права на /var/run/php-fpm/www.sock
```
cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
[influxdata]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF
sudo dnf -y install telegraf
sudo setfacl -m u:telegraf:rw /var/run/php-fpm/www.sock
```
Меняю настройки в [/etc/telegraf/telegraf.conf](/TICK1/telegraf.conf) 
Запускаю службу telegraf:
```
sudo systemctl enable telegraf --now
```
На второй виртуальной машине устанавливаю docker и запускаю в нем Influxdb, Chronograf, Kapacitor
Файл [docker-compose.yml](/TICK1/docker-compose.yml)
Файл [influxdb.conf](/TICK1/influxdb.conf)
Файл [kapacitor.conf](/TICK1/kapacitor.conf)

Настройка [telegraf.conf](/TICK1/telegraf.conf)  отправки метрик в InfluxDB
```
[[outputs.influxdb]]
  urls = ["http://influxdb:8086"]
  database = "wp_data"
  retention_policy = "autogen"
  username = "admin"
  password = "admin"
```
![Cводный дашборд](/TICK1/dashboard.png "Cводный дашборд.")

На ВМ с docker в папке ./volumes/kapacitor/ создаю файл cpu_alert.tick
```
dbrp "wp_data"."autogen"

stream
  |from()
    .measurement('cpu')
  |alert()
    .crit(lambda: int("usage_idle") < 10)
    .log('/tmp/alerts.log')
    .telegram() 
```
Добавляю и включаю task.
```
docker exec kapacitor kapacitor define cpu_alert -type stream -tick /var/lib/kapacitor/cpu_alert.tick
docker exec kapacitor kapacitor enable cpu_alert
```

На ВМ c wordpress устанавливаю stress и симулирую нагрузку на CPU.
```
sudo dnf -y install stress
stress -c 2
```
В папке /tmp контейнера kapacitor появился alerts.log 
```
root@mon:~# docker exec kapacitor head -1 /tmp/alerts.log
{"id":"cpu:nil","message":"cpu:nil is CRITICAL","details":"{\u0026#34;Name\u0026#34;:\u0026#34;cpu\u0026#34;,\u0026#34;TaskName\u0026#34;:\u0026#34;cpu_alert\u0026#34;,\u0026#34;Group\u0026#34;:\u0026#34;nil\u0026#34;,\u0026#34;Tags\u0026#34;:{\u0026#34;cpu\u0026#34;:\u0026#34;cpu0\u0026#34;,\u0026#34;host\u0026#34;:\u0026#34;wp\u0026#34;},\u0026#34;ServerInfo\u0026#34;:{\u0026#34;Hostname\u0026#34;:\u0026#34;kapacitor\u0026#34;,\u0026#34;ClusterID\u0026#34;:\u0026#34;3afa279c-51a6-432b-a75a-ae4094d3a078\u0026#34;,\u0026#34;ServerID\u0026#34;:\u0026#34;319556c3-4b74-4d3e-bde5-121bb26b26fc\u0026#34;},\u0026#34;ID\u0026#34;:\u0026#34;cpu:nil\u0026#34;,\u0026#34;Fields\u0026#34;:{\u0026#34;usage_guest\u0026#34;:0,\u0026#34;usage_guest_nice\u0026#34;:0,\u0026#34;usage_idle\u0026#34;:0,\u0026#34;usage_iowait\u0026#34;:0,\u0026#34;usage_irq\u0026#34;:3.3333333333337674,\u0026#34;usage_nice\u0026#34;:0,\u0026#34;usage_softirq\u0026#34;:0,\u0026#34;usage_steal\u0026#34;:0,\u0026#34;usage_system\u0026#34;:3.3333333333337674,\u0026#34;usage_user\u0026#34;:93.3333333333475},\u0026#34;Level\u0026#34;:\u0026#34;CRITICAL\u0026#34;,\u0026#34;Time\u0026#34;:\u0026#34;2025-09-09T08:21:42Z\u0026#34;,\u0026#34;Duration\u0026#34;:0,\u0026#34;Message\u0026#34;:\u0026#34;cpu:nil is CRITICAL\u0026#34;}\n","time":"2025-09-09T08:21:42Z","duration":0,"level":"CRITICAL","data":{"series":[{"name":"cpu","tags":{"cpu":"cpu0","host":"wp"},"columns":["time","usage_guest","usage_guest_nice","usage_idle","usage_iowait","usage_irq","usage_nice","usage_softirq","usage_steal","usage_system","usage_user"],"values":[["2025-09-09T08:21:42Z",0,0,0,0,3.3333333333337674,0,0,0,3.3333333333337674,93.3333333333475]]}]},"previousLevel":"OK","recoverable":true}
```
