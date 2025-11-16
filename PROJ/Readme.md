



https://docs.rocket.chat/docs/running-multiple-instances

Примерный порядок действий

1. поднимаем стенд
```
bash build.sh 
```
или рукам ипо очереди
```
vagrant up database storage
vagrant up --parallel app-node-1 app-node-2 app-node-3
vagrant up balancer
```

2. проверяем базу
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

3. проверяем S3
```
```
 - переходим по ссылке http://192.168.250.22:9001
 - креды minioadmin/minioadmin123

4. создаем бакет и ключи
 - http://192.168.250.22:9001/browser
 - create bucket
 - name rocket-chat-files
 - http://192.168.250.22:9001/access-keys
 - create access key
   - xrfSwqhzgx4xwGmcDpqD
   - Zya66zajXNigeAjX0ist2I0CpJnCU5RV3frgy8Ih

5. проверяем рокетчат
```
vagrant ssh app-node-1
docker ps
docker logs -f rocketchat
```
видим
```
+----------------------------------------------+
|                SERVER RUNNING                |
+----------------------------------------------+
|                                              |
|  Rocket.Chat Version: 6.9.5                  |
|       NodeJS Version: 14.21.3 - x64          |
|      MongoDB Version: 6.0.18                 |
|       MongoDB Engine: wiredTiger             |
|             Platform: linux                  |
|         Process Port: 3000                   |
|             Site URL: http://192.168.250.10  |
|     ReplicaSet OpLog: Enabled                |
|          Commit Hash: ed11247fa3             |
|        Commit Branch: HEAD                   |
|                                              |
+----------------------------------------------+
```
5. логинимся в rocket chat
- http://192.168.250.10:8080/
- креды chatmaster@localhost.com/chatmasterassword
- проходим регистрацию
- получаем письмо, подтверждаем, ждем

6. настраиваем хранение в s3 (https://docs.rocket.chat/docs/minio#setup-rocketchat-to-use-minio)
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

7. создаем 2го пользователя и канал
8. пересылка сообщения между двумя пользователям
9. по очереди "роняем бекенды" и убежадемся что все работает
