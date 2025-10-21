## Развертывание Graylog

### Цель:
Научиться принимать логи в graylog и создавать на их основы стримы.

### Описание/Пошаговая инструкция выполнения домашнего задания:

**Для успешного выполнения ДЗ вам нужно сконфигурировать Graylog и отправку логов в него**
1. На виртуальной машине установите любую open source CMS, которая включает в себя следующие компоненты: nginx, php-fpm, database (MySQL or Postgresql). Можно взять из предыдущих заданий;
2. На этой же VM установите graylog sidecar.
3. Установите на второй VM Graylog (server, opensearch, mongodb) и datapreper
4. Подключите установленный sidecar в graylog и настройте сбор и отправку логов nginx, php-fpm и базы данных, используя sidecar.
5. Разделите логи в разные стримы.


В качестве результата создайте репозиторий приложите конфиги datapreper, sidecar.

Приложите скриншот полученных данных отображенных в Graylog.

### Критерии оценки:
0 баллов - задание не выполнено согласно инструкции
1 балл - задание выполнено успешно согласно инструкции


### Компетенции:
1. Системы логирования
   - Настройка отправки и анализа логов с помощью Graylog


## Решение
1. Как и в предыдущих заданиях на виртуальной машине установил Wordpress, который включает в себя следующие компоненты: nginx, php-fpm, database (MariaDB). 
2. На этой же VM установил graylog sidecar и fluenbit. 
 ```
   rpm -Uvh https://packages.graylog2.org/repo/packages/graylog-sidecar-repository-1-5.noarch.rpm
   dnf -y install graylog-sidecar
   cat <<EOF >> /etc/yum.repos.d/fluent-bit.repo
   [fluent-bit]
   name = Fluent Bit
   baseurl = https://packages.fluentbit.io/almalinux/$releasever/
   gpgcheck=1
   gpgkey=https://packages.fluentbit.io/fluentbit.key
   repo_gpgcheck=1
   enabled=1
   EOF
   dnf -y install fluent-bit
 ```
3. На второй VM устанввливаю Graylog (server, opensearch, mongodb) и datapreper  в docker compose.
  - Файл [docker-compose.yml](/GRAYLOG/docker-compose.yml).
  - Файл настроек pipeline для data-preper'а [log_pipeline.yaml.yml](/GRAYLOG/log_pipeline.yaml).

  После установки Graylog'е создаю input - GELF UDP

  ![gelf-udp](/GRAYLOG/gelf-udp.PNG "gelf-udp.")

4. В Graylog для подключения sidecar делаю следующее:
  - генерирую токен
  - создаю collector для fluent-bit
  - создаю конфигурацию коллектора fluent-bit с тегом **wp** :
```
[SERVICE]
    log_level    info
    flush           1
    parsers_file parsers.conf

[INPUT]
    Name tail
    Tag nginx.access
    Path /var/log/nginx/*access.log
    Parser nginx

[INPUT]
    Name tail
    Tag   nginx.error
    Path  /var/log/nginx/*error.log
    
[INPUT]
    Name tail
    Tag   myslq
    Path  /var/log/mariadb/*.log

[INPUT]
    Name tail
    Tag   php-fpm
    Path  /var/log/php-fpm/*.log

[FILTER]
    Name record_modifier
    Match nginx*
    Record type nginx

[FILTER]
    Name record_modifier
    Match myslq
    Record type mysql

[FILTER]
    Name record_modifier
    Match php-fpm
    Record type php-fpm

[OUTPUT]
    Name http
    Match *
    Host graylog.local
    Port 2021
    URI /log/ingest
    Format json
```
  
  На ВМ c sidecar редактирую конфигурациию [sidecar.yml](/GRAYLOG/sidecar copy.yml) и запускаю sidecar.

```
graylog-sidecar -service install
systemctl enable --now graylog-sidecar
```

5. Для разделения логов по стримам создаю 3 стрима с правилами:
  - nginx stream с правилом *message **must** contain "type":"nginx"*
  - php-fpm stream с правилом *message **must** contain "type":"php-fpm"*
  - mysql stream с правилом *message **must** contain "type":"mysql"*

  Скрины стримов:
  - nginx stream
  
    ![nginx-stream](/GRAYLOG/nginx-stream.PNG "nginx-stream.")

  - php-fpm stream
  
    ![php-fpm-stream](/GRAYLOG/php-fpm-stream.PNG "php-fpm-stream.")

  - mysql stream
  
    ![mysql-stream](/GRAYLOG/mysql-stream.PNG "mysql-stream.")  