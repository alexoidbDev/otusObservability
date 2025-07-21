
## Описание/Пошаговая инструкция выполнения домашнего задания:
Для Prometheus необходимо установить отдельно хранилище метрик (Victoria Metrics, Grafana Mimir, Thanos, etc.).
Во время записи метрики в хранилище Prometheus должен дополнительно добавлять лейбл site: prod.

**Дополнительные параметры хранилища:**
* Metrics retention - 2 weeks
* В качестве результата ДЗ принимаются - файл конфигурации системы хранения, файл конфигурации Prometheus.

## Решение
*  *prometheus.yml*
```
  global:
    external_labels:
      site: prod
  remote_write:
    - url: http://victoriametrics:8428/api/v1/write
```    
* *victoriametrics.service* - запуск сервиса *victoriametrics* с параметром *-retentionPeriod=2w*

**в папке *withVagrant* - vagrant решение**