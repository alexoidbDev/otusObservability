

Презентация проекта https://docs.google.com/presentation/d/1XrHWb9mHIsXJqg6mv-iMDefNq1sdWR5bnPHvCA9wLQE/


Примерный порядок действий по первоначальной настройке и проверке стенда.

1. поднимаем стенд
  ```
  bash build.sh 
  ```

2. логинимся в rocket chat
  - http://192.168.250.10:8080/
  - креды chatmaster@localhost.com/chatmasterassword
  - проходим регистрацию (после версии 6.5 регистрация обязательна, в более  старых версиях можно пропусть в офлайн варианте)

3. настраиваем хранение в s3 (https://docs.rocket.chat/docs/minio#setup-rocketchat-to-use-minio)
  - администирование - рабочее пространство
  - настройки - загрузка файлов -  тип хранения = amazon s3
  - Название Bucket - rocket-chat-files
  - регион us-east-1
  - Bucket URL http://192.168.250.22:9000/rocket-chat-files
  - подпись v2
  - Форсировать Path Style - да
  - URLs expiration timespan = 0

  - применяем
  - загружаем в чат файл
  - проверяем что он появился в бакете

4. Необезательный шаг. Можно проверить базу и S3.

    База
    ```
    vagrant ssh database
    docker ps
    docker exec -ti mongo1 /bin/bash
    mongosh
    rs.status()
    ```
    - переходим по ссылке http://192.168.250.21:8081/
    - креды admin/password
    - смотрим что база заровиженилась

    S3
    - переходим по ссылке http://192.168.250.22:9001
    - креды minioadmin/minioadmin123

5. создаем 2го пользователя и канал
6. пересылка сообщения между двумя пользователям

7. Проверка мониторинга и логирования.

   
  Grafana:   http://192.168.250.30:3000

  admin:admin

  Сменить пароль. Проверить добавленные провижинингом дашборды для мониторинга узлов (node_exporter), монго, minio, nginx и приложений rocket chat. Прверить централизованный сбор логов в Loki.
 
  Для алертинга добавить файл conf/telegram.token c токеном телеграм бота. В conf/alertmanager.yml настроить chat_id. Для проверки уронить один из узлов или загрузить на 100% процессор.