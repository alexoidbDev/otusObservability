## Домашнее задание
Формирование dashboard на основе собранных данных с Grafana

### Цель:
Сформировать dashboard на основе собранных данных с Grafana


### Описание/Пошаговая инструкция выполнения домашнего задания:
Для выполнения данного ДЗ воспользуйтесь наработками из предыдущего домашнего задания.


На VM с установленным Prometheus установите Grafana последней версии доступной на момент выполнения ДЗ:
* Создайте внутри Grafana папки с названиями infra и app;
* Внутри директории infra создайте дашборд, который будет отображать сводную информацию по инфраструктуре (CPU, RAM, Network, etc.);
* Внутри директории app создайте дашборд, который будет отображать сводную информацию о CMS (доступность компонентов, время ответа, etc.);

### Задание со звездочкой

при помощи Grafana создайте alert о недоступности одного из компонентов CMS и инфраструктуры;
создайте DrillDown dashboard который будет отображать сводную информацию по инфраструктуре, но нажав на конкретный инстанс можно получить полную информацию.

### Результат: Переиспользуйте репозиторий созданный для сдачи предыдущего ДЗ.

Дополните Readme описание действий выполненных в результате выполнения данного ДЗ.

В директорию GAP-2 приложите скриншоты дашбордов которые вы создали.


## Решение

Установка grafana
```
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/grafana-enterprise/release/11.6.5/grafana-enterprise_11.6.5_16839285956_linux_amd64.deb
sudo dpkg -i grafana-enterprise_11.6.5_16839285956_linux_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable grafana-server --now
```

Создаю 2 папки и импортирую дашборды 

![Folders](/GAP4/Folders.png "Folders.")

**Дашборд папки infra**

*NodeExporter*
![Infra-NodeExporter](/GAP4/Infra-NodeExporter.png "Infra-NodeExporter.")

**Дашборды папки app**

*Blackbox*
![app-blackbox](/GAP4/app-blackbox.png "app-blackbox.")

*Mysql*
![app-mysql](/GAP4/app-mysql.png "app-mysql.")

*Nginx*
![app-nginx](/GAP4/app-nginx.png "app-nginx.")

