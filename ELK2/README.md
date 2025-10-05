## Преобразование входящих сообщений с помощью Logstash и Vector 
### Цель:
Установить и настроить Logstash и Vector таким образом, чтобы происходил парсинг входящих сообщений.

### Описание/Пошаговая инструкция выполнения домашнего задания:

**Используйте тот же стенд из 2х VM как в предыдущем задании:**

1. Установите Logstash на виртуальную машину с Elasticsearch. Перенастройте отправку логов в него. В Logstash добавьте парсинг логов при помощи grok фильтр (Filebeat пусть при этом шлет сырые данные).
2. Вместо Logstash установите и настройке Vector с аналогичным парсингом логов при помощи VRL.

**Задание со звездочкой**
3. Настройте Dead letter queue (DLQ) в Logstash.
4. Настройте политики ILM в Logstash при отправке Elasticsearch.

В качестве результата создайте Git-репозиторий, приложите конфиги Logstash и Vector.
Приложите скриншот полученных в Kibana данных.


### Критерии оценки:
0 баллов - задание не выполнено согласно инструкции
1 балл - задание выполнено успешно согласно инструкции

### Компетенции:
Системы логирования
- Преобразование данных при помощи vector и logstash

## Решение

1. Установливаю Logstash на виртуальную машину с Elasticsearch
  ```
  apt -y install logstash
  ```
Настраиваю Filebeat на отправку сырых данных в Logstash и тегирую их для последующей обработки в Logstash.
```
...
filebeat.inputs:
- type: filestream
  id: nginx-access-id
  tags:
    - nginx
    - nginx-access
  paths: ["/var/log/hostlog/nginx/access.log*"]
- type: filestream
  id: nginx-error-id
  tags:
    - nginx
    - nginx-error
  paths: ["/var/log/hostlog/nginx/error.log*"]

output.logstash:
  hosts: ${LOGSTASH_HOSTS}

...
```  
Файл [filebeat.yml](/ELK2/filebeat.yml)

Настраиваю Logstash на прием, обработку логов с Filebeat и отправку в elasticsearch. Файл [logstash.conf](/ELK2/logstash.conf)
Cкриншот полученных в Kibana данных:
* Discover nginx-* в Kibana
![Logstash data in Kbana.](/ELK2/ELK2-logstash1.png "Logstash data in Kbana.")
* Elastic Indices
![Indices in Kbana.](/ELK2/ELK2-logstash_indices.png "Indices in Kbana.")

2. Устанавливаю и настраиваю vector для сбора файловых логов и обработки логов nginx
```
curl --proto '=https' --tlsv1.2 -sSfL https://sh.vector.dev | bash -s -- -y
cp /root/.vector/bin/vector /usr/local/bin/
mkdir -p /etc/vector/
mkdir -p /var/lib/vector
cp /opt/files/vector.yml /etc/vector/
cp /opt/files/vector.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable vector --now

```

Файл [vector.yml](/ELK2/vector.yml)
Файл [vector.service](/ELK2/vector.service)

Cкриншот полученных в Kibana данных:
![Vector data in Kbana.](/ELK2/ELK2-vector.png "Vector data in Kbana.")

