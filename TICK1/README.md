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

1. На виртуальной машине устанавливаю open source CMS - wordpress, которая включает в себя следующие компоненты: nginx, php-fpm, mysql database (mariadb). Также как в предыдущих ДЗ.
2. На эту же виртуальную машину устанавливаю Telegraf и выдаю права на /var/run/php-fpm/www.sock
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
Добавляю пользователя в mariadb:
```
CREATE USER 'telegraf'@'localhost' IDENTIFIED BY 'TelegrafPaSSw0rd' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'telegraf'@'localhost';
```

Меняю настройки в [/etc/telegraf/telegraf.conf](/TICK1/telegraf.conf)  
  
Запускаю службу telegraf:
```
sudo systemctl enable telegraf --now
```
3. На второй виртуальной машине устанавливаю docker и запускаю в нем Influxdb, Chronograf, Kapacitor
* Файл [docker-compose.yml](/TICK1/docker-compose.yml)
* Файл [influxdb.conf](/TICK1/influxdb.conf)
* Файл [kapacitor.conf](/TICK1/kapacitor.conf)

4. Настройка [telegraf.conf](/TICK1/telegraf.conf)  отправки метрик в InfluxDB
```
[[outputs.influxdb]]
  urls = ["http://influxdb:8086"]
  database = "wp_data"
  retention_policy = "autogen"
  username = "admin"
  password = "admin"
```

5. **Cводный дашборд:**

![Cводный дашборд](/TICK1/dashboard.png "Cводный дашборд.")

6. Настройка и проверка алертинга
На ВМ с docker в папке ./volumes/kapacitor/ создаю файлы tick скриптов
* cpu_alert.tick
```
stream
  |from()
    .measurement('cpu')
  |alert()
    .crit(lambda: int("usage_idle") < 10)
    .log('/tmp/alerts.log')
```
* check_nginx.tick
```
stream
  |from()
    .measurement('net_response')
    .where(lambda: "server" == 'localhost' AND "port" == '80')
  |alert()
    .id('Nginx Port Unreachable')
    .crit(lambda: "result_code" != 0)
    .message('Nginx port is not responding')
    .log('/tmp/alerts_nginx.log')
```
* check_mariadb.tick
```
stream
  |from()
    .measurement('net_response')
    .where(lambda: "server" == 'localhost' AND "port" == '3306')
  |alert()
    .id('MariaDB Port Unreachable')
    .crit(lambda: "result_code" != 0)
    .message('MariaDB port is not responding')
    .log('/tmp/alerts_mariadb.log')
```
* check_500.tick
```
stream
  |from()
    .measurement('http_response')
    .where(lambda: "service" == 'mysite')
  |alert()
    .id('HTTP_500_Errors')
    .message('HTTP 500 error detected: Status code {{ index .Fields "status_code" }} on {{ index .Tags "url" }}')
    .warn(lambda: "http_response_code" >= 500 AND "http_response_code" < 600)
    .crit(lambda: "http_response_code" >= 500 AND "http_response_code" < 600)
    .log('/tmp/alerts_500.log')
```
Добавляю и включаю task.
```
docker exec kapacitor kapacitor define cpu_alert -type stream -tick /var/lib/kapacitor/cpu_alert.tick -dbrp wp_data.autogen
docker exec kapacitor kapacitor define check_nginx -type stream -tick /var/lib/kapacitor/check_nginx.tick -dbrp wp_data.autogen
docker exec kapacitor kapacitor define check_mariadb -type stream -tick /var/lib/kapacitor/check_mariadb.tick -dbrp wp_data.autogen
docker exec kapacitor kapacitor define check_500 -type stream -tick /var/lib/kapacitor/check_500.tick -dbrp wp_data.autogen
docker exec kapacitor kapacitor enable cpu_alert
docker exec kapacitor kapacitor enable check_nginx
docker exec kapacitor kapacitor enable check_mariadb
docker exec kapacitor kapacitor enable check_500
```

**Проверка алертинга**

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

На ВМ c wordpress остановливаю nginx - *sudo systemctl stop nginx.service*
В папке /tmp контейнера kapacitor появился alerts_nginx.log
```
root@mon:~# docker exec kapacitor head -1 /tmp/alerts_nginx.log
{"id":"Nginx Port Unreachable","message":"Nginx port is not responding","details":"{\u0026#34;Name\u0026#34;:\u0026#34;net_response\u0026#34;,\u0026#34;TaskName\u0026#34;:\u0026#34;check_nginx\u0026#34;,\u0026#34;Group\u0026#34;:\u0026#34;nil\u0026#34;,\u0026#34;Tags\u0026#34;:{\u0026#34;host\u0026#34;:\u0026#34;wp\u0026#34;,\u0026#34;port\u0026#34;:\u0026#34;80\u0026#34;,\u0026#34;protocol\u0026#34;:\u0026#34;tcp\u0026#34;,\u0026#34;result\u0026#34;:\u0026#34;connection_failed\u0026#34;,\u0026#34;server\u0026#34;:\u0026#34;localhost\u0026#34;},\u0026#34;ServerInfo\u0026#34;:{\u0026#34;Hostname\u0026#34;:\u0026#34;kapacitor\u0026#34;,\u0026#34;ClusterID\u0026#34;:\u0026#34;3afa279c-51a6-432b-a75a-ae4094d3a078\u0026#34;,\u0026#34;ServerID\u0026#34;:\u0026#34;319556c3-4b74-4d3e-bde5-121bb26b26fc\u0026#34;},\u0026#34;ID\u0026#34;:\u0026#34;Nginx Port Unreachable\u0026#34;,\u0026#34;Fields\u0026#34;:{\u0026#34;result_code\u0026#34;:2,\u0026#34;result_type\u0026#34;:\u0026#34;connection_failed\u0026#34;},\u0026#34;Level\u0026#34;:\u0026#34;CRITICAL\u0026#34;,\u0026#34;Time\u0026#34;:\u0026#34;2025-09-09T12:38:50Z\u0026#34;,\u0026#34;Duration\u0026#34;:0,\u0026#34;Message\u0026#34;:\u0026#34;Nginx port is not responding\u0026#34;}\n","time":"2025-09-09T12:38:50Z","duration":0,"level":"CRITICAL","data":{"series":[{"name":"net_response","tags":{"host":"wp","port":"80","protocol":"tcp","result":"connection_failed","server":"localhost"},"columns":["time","result_code","result_type"],"values":[["2025-09-09T12:38:50Z",2,"connection_failed"]]}]},"previousLevel":"OK","recoverable":true}
```

Аналогично при остановке mariadb в папке /tmp контейнера kapacitor появился  /tmp/alerts_mariadb.log

Для симуляции 500-х ошибок в настройках nginx в файле [mysite.local.conf](/TICK1//withVagrant/files/mysite.local.conf) добавляю:
```
    location = / {
        return 500;
    }
```
После перезапуска nginx в папке /tmp контейнера kapacitor появился  /tmp/alerts_500.log
```
root@mon:~# docker exec kapacitor head -1 /tmp/alerts_500.log
{"id":"HTTP_500_Errors","message":"HTTP 500 error detected: Status code \u003cno value\u003e on ","details":"{\u0026#34;Name\u0026#34;:\u0026#34;http_response\u0026#34;,\u0026#34;TaskName\u0026#34;:\u0026#34;check_500\u0026#34;,\u0026#34;Group\u0026#34;:\u0026#34;nil\u0026#34;,\u0026#34;Tags\u0026#34;:{\u0026#34;host\u0026#34;:\u0026#34;wp\u0026#34;,\u0026#34;method\u0026#34;:\u0026#34;GET\u0026#34;,\u0026#34;result\u0026#34;:\u0026#34;success\u0026#34;,\u0026#34;server\u0026#34;:\u0026#34;http://mysite.local:80\u0026#34;,\u0026#34;service\u0026#34;:\u0026#34;mysite\u0026#34;,\u0026#34;status_code\u0026#34;:\u0026#34;500\u0026#34;},\u0026#34;ServerInfo\u0026#34;:{\u0026#34;Hostname\u0026#34;:\u0026#34;kapacitor\u0026#34;,\u0026#34;ClusterID\u0026#34;:\u0026#34;3afa279c-51a6-432b-a75a-ae4094d3a078\u0026#34;,\u0026#34;ServerID\u0026#34;:\u0026#34;319556c3-4b74-4d3e-bde5-121bb26b26fc\u0026#34;},\u0026#34;ID\u0026#34;:\u0026#34;HTTP_500_Errors\u0026#34;,\u0026#34;Fields\u0026#34;:{\u0026#34;content_length\u0026#34;:177,\u0026#34;http_response_code\u0026#34;:500,\u0026#34;response_string_match\u0026#34;:1,\u0026#34;response_time\u0026#34;:0.00418358,\u0026#34;result_code\u0026#34;:0,\u0026#34;result_type\u0026#34;:\u0026#34;success\u0026#34;},\u0026#34;Level\u0026#34;:\u0026#34;CRITICAL\u0026#34;,\u0026#34;Time\u0026#34;:\u0026#34;2025-09-09T13:20:40Z\u0026#34;,\u0026#34;Duration\u0026#34;:0,\u0026#34;Message\u0026#34;:\u0026#34;HTTP 500 error detected: Status code \\u003cno value\\u003e on \u0026#34;}\n","time":"2025-09-09T13:20:40Z","duration":0,"level":"CRITICAL","data":{"series":[{"name":"http_response","tags":{"host":"wp","method":"GET","result":"success","server":"http://mysite.local:80","service":"mysite","status_code":"500"},"columns":["time","content_length","http_response_code","response_string_match","response_time","result_code","result_type"],"values":[["2025-09-09T13:20:40Z",177,500,1,0.00418358,0,"success"]]}]},"previousLevel":"OK","recoverable":true}
```