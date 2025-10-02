## Установка и настройка отправки данных с помощью Beats

### Цель:
Научиться отправлять логи, метрики с помощью beats в elasticsearch.

### Описание/Пошаговая инструкция выполнения домашнего задания:

**Для успешного выполнения дз вам нужно сконфигурировать hearthbeat, filebeat и metricbeat на отправку данных в elasticsearch:**

1. На виртуальной машине установите любую open source CMS, которая включает в себя следующие компоненты: nginx, php-fpm, database (MySQL or Postgresql). Можно взять из предыдущих заданий;
2. На этой же VM установите filebeat и metricbeat. Filebeat должен собирать логи nginx, php-fpm и базы данных. Metricbeat должен собирать метрики VM, nginx, базы данных;
3. Установите на второй VM Elasticsearch и kibana, а также heartbeat;
Heartbeat должен проверять доступность следующих ресурсов: веб адрес вашей CMS и порта БД

**Задания со звездочкой**
4. Настройте политики ILM так, чтобы логи nginx и базы данных хранились 30 дней, а php-fpm 14 дней;
5. Настройте в filebeat dissect для логов nginx, так чтобы он переводил access логи в json;

В качестве результата создайте репозиторий приложите конфиги hearthbeat, filebeat и metricbeat.

Приложите скриншот полученных данных отображенных в Kibana.

### Критерии оценки:
0 баллов - задание не выполнено согласно инструкции
1 балл - задание выполнено успешно согласно инструкции

### Компетенции:
Системы логирования
- Отправка данных с помощью filebeat, metricbeat и heartbeat

## Решение
1. На виртуальной машине устанавливаю open source CMS - wordpress, которая включает в себя следующие компоненты: nginx, php-fpm, mysql database (mariadb). Также как в предыдущих ДЗ.
2. На эту же виртуальную машину устанавливаю filebeat и metricbeat в качестве docker контейнеров поскольку у yаndex (https://mirror.yandex.ru/mirrors/elastic/) не нашел elastic  репозитария для rpm based систем, а репозитарии самого elastic из России закрыты. 
* Файл [docker-compose.yml](/ELK1/docker-compose.yml)
* Файл [filebeat.yml](/ELK1/filebeat.yml)
* Файл [metricbeat.yml](/ELK1/metricbeat.yml)
3. На второй VM (Ubuntu) установливаю из yаndex репозитория Elasticsearch и kibana, а также heartbeat.
```
echo "deb [trusted=yes] https://mirror.yandex.ru/mirrors/elastic/8/ stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
apt update -y
apt -y install elasticsearch
sed -i 's/xpack.security.enabled: true/xpack.security.enabled: false/g' /etc/elasticsearch/elasticsearch.yml
systemctl enable elasticsearch.service --now
apt -y install kibana
export TOKEN=$(/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana)
echo server.host: \"0.0.0.0\" >> /etc/kibana/kibana.yml
echo elasticsearch.serviceAccountToken: \"$TOKEN\" >> /etc/kibana/kibana.yml
echo elasticsearch.hosts: [\"http://localhost:9200\"] >> /etc/kibana/kibana.yml
systemctl enable kibana --now
apt -y install heartbeat-elastic
### Изменяю /etc/heartbeat/heartbeat.yml
systemctl enable heartbeat-elastic --now
```
Файл [heartbeat.yml](/ELK1/heartbeat.yml)

**Скриншоты полученных данных отображенные в Kibana.**

* filebeat
![Filebeat](/ELK1/ELK1-filebeat.PNG "Filebeat.")

* metricbeat
![Metricbeat](/ELK1/ELK1-heartbeat.PNG "Metricbeat.")

* heartbeat
![Heartbeat](/ELK1/ELK1-metricbeat.PNG "Heartbeat.")