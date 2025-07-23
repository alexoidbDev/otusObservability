### Описание/Пошаговая инструкция выполнения домашнего задания:
Дополнительно установите Alertmanager, настройки алертинг в один из каналов оповещений на ваш выбор (Telegram, email, Slack, etc.);
Создайте набор alert`ов с различными Severity. Для начала ограничтесь warning и critical;
Alertmanager должен уметь отправлять алерты с severity critical в один канал оповещений, в то время как алерты с severity warning в другой;
В качестве результата ДЗ принимаются - файл конфигурации Alertmanager

### Решение
Файл *alertmanager.yml*
```
global:
route:
  group_by: ['alertname']
  group_wait: 5s
  group_interval: 30s
  repeat_interval: 1m
  receiver: default-receiver
  routes:
    - matchers:
        - severity = critical
      receiver: 'webhook-critical'
    - matchers:
        - severity = warning
      receiver: 'webhook-warning'
receivers:
- name: default-receiver
  webhook_configs:
  - url: https://webhook.site/755ebca2-6a31-47f1-b285-a261d955ac84
- name: 'webhook-critical'
  webhook_configs:
  - url: https://webhook.site/8a4ed47f-a02a-467a-8a5b-c3833db3fc7e
- name: 'webhook-warning'
  webhook_configs:
  - url: https://webhook.site/341f64ce-384b-4fde-8b4a-34b800cfe5da
```

**Vargant** решение в папке *withVagrant*