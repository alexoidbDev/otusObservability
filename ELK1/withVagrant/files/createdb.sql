CREATE DATABASE `wordpress` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress123';
GRANT ALL PRIVILEGES ON `wordpress`.* TO 'wordpress'@'localhost';
 
CREATE USER 'monitor'@'%' IDENTIFIED BY 'monitorPaSS' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'monitor'@'%';