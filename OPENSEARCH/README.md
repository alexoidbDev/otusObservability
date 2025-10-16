## Построение системы централизованного логирования на основе Opensearch

### Цель:
Cообщения сохраняются в базу Opensearch и могут быть визуализированы через Opensearch Dashboard.

В ДЗ тренируются навыки:

 - навыки работы с fluentbeat;
 - навыки работы с datapreper;
 - навыки работы с opensearch.

### Описание/Пошаговая инструкция выполнения домашнего задания:

**Возьмите за основу стенд из занятий по Elasticstack:**
1. Замените filebeat на fluentbeat с аналогичной конфигурацией;
2. Замените logstash на datapreper он должен принимать данные от fluentbeat;
3. Замените Elasticsearch и Kibana на Opensearch и Opensearch Dashboard.

### Задание со звездочкой

4. Настройте политики жизненного цикла как в занятии по elasticstack только через ISM.


В качестве результата предоставте примеры конфигурации fluentbit, datapreper и скриншоты с Opensearch Dashboard с выводом данных.


### Критерии оценки:
0 баллов - задание не выполнено согласно инструкции
1 балл - задание выполнено успешно согласно инструкции


### Компетенции:
Системы логирования
- Работа с opensearch
- Работа с fluentbeat
- Работа с datapreper

## Решение

На стенде из занятий по Elasticstack:

1. Заменил filebeat на fluentbeat. Файл конфигурации [fluent-beat.conf](/OPENSEARCH/fluent-bit.conf).
2. Заменил logstash на datapreper. Настроил отправку в fluentbeat на datapreper. С datapreper логи отправляются на opensearch. Файл конфигурации пайплайна [log_pipeline.yaml](/OPENSEARCH/log_pipeline.yaml). 
3. Заменил Elasticsearch и Kibana на Opensearch и Opensearch Dashboard.

**Скриншоты из Opensearch Dashbord:**

 * Логи nginx

   ![Nginx](/OPENSEARCH/nginx.png "Nginx.")

 * Логи php-fpm

   ![php-fpm](/OPENSEARCH/php-fpm.png "Php-fpm.")

 * Логи mariadb

    ![Mariadb](/OPENSEARCH/php-fpm.png "Mariadb.")