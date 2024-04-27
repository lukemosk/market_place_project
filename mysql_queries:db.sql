CREATE DATABASE  IF NOT EXISTS cs336project;
USE cs336project;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id int NOT NULL AUTO_INCREMENT,
  username varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  type ENUM('admin', 'cs', 'default'),
  PRIMARY KEY (id)
);

LOCK TABLES users WRITE;
INSERT INTO users (username, password, type) VALUES ('admin', '1234', 'admin');
UNLOCK TABLES;

SELECT * FROM users;