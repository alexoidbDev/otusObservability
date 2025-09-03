CREATE DATABASE `wordpress` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress123';
GRANT ALL PRIVILEGES ON `wordpress`.* TO 'wordpress'@'localhost';

CREATE USER 'user_exporter'@'localhost' IDENTIFIED BY 'ExporterPaSSw0rd' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'user_exporter'@'localhost';