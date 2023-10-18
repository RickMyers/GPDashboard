DROP TABLE hedis_news;

CREATE TABLE hedis_news
    (
         id INT NOT NULL AUTO_INCREMENT,
         `title` CHAR (128) DEFAULT NULL,
         author INT DEFAULT NULL,
         content TEXT,
         modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         PRIMARY KEY (id)
    );