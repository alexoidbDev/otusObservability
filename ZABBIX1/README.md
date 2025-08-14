## Настройка zabbix, создание LLD, оповещение на основе триггеров

### Цель:
Установить и настроить zabbix, настроить автоматическую отправку аллертов в телеграмм канал.


### Описание/Пошаговая инструкция выполнения домашнего задания:
Необходимо сформировать скрипт генерирующий метрики формата:

```
otus_important_metrics[metric1]
otus_important_metrics[metric2]
otus_important_metrics[metric3]
```

С рандомным значение от 0 до 100

Создать правила LLD для обнаружения этих метрик и автоматического добавления триггеров. Триггер должен срабатывать тогда, когда значение больше или равно 95.

Реализовать автоматическую отправку уведомлений в телеграмм канал.

В качестве результаты выполнения ДЗ необходимо предоставить скрипт генерации метрик, скриншоты графиков полученных метрик, ссылку на телеграмм канал с уже отпраленными уведомлениями.

## Решение 
 
 * t.me/zbxotsch - [ссылкa на телеграмм канал](https://t.me/zbxotsch) с уже отпраленными уведомлениями. [Скрин телеграм канала](/ZABBIX1/ScreenTelegram.png)
 * metrics.sh - скрипт генерации метрик
 ```
    #!/bin/bash

    cat << EOF
    { "data":  [
        { "{#METRICNAME}" : "metric1" },
        { "{#METRICNAME}" : "metric2" },
        { "{#METRICNAME}" : "metric3" }
    ]}
    EOF

    agenthost=`hostname -f`
    zserver="192.168.250.21"
    zport="10051"
    mfile=/usr/local/zabbix/metrics.txt
    : > $mfile
    for metric_name in "metric1" "metric2" "metric3"; do
        metric_value="$(( (SRANDOM % 100)+1 ))"
        echo $agenthost otus_important_metrics[$metric_name] $metric_value >> $mfile
    done

    zabbix_sender -vv -z $zserver -p $zport -i $mfile >> /usr/local/zabbix/zsender.log 2>&1
 ```
 * скриншоты графиков полученных метрик - ScreenMetric1.png, ScreenMetric2.png, ScreenMetric3.png
    * Metric1 
      ![Metric1](/ZABBIX1/ScreenMetric1.png "Metric1.")
    * Metric2
      ![Metric3](/ZABBIX1/ScreenMetric2.png "Metric2.")
    * Metric3 (во время 1-го срабатывания триггера отправка в телеграм была не донастроена)
      ![Metric3](/ZABBIX1/ScreenMetric3.png "Metric3.")            