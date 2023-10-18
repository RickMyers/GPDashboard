
CREATE TABLE scheduler_availability 
(
       id INT NOT NULL AUTO_INCREMENT,
       user_id INT DEFAULT NULL,
       `date` DATE DEFAULT NULL,
       available CHAR(01) DEFAULT NULL,
       modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       PRIMARY KEY (id),
       UNIQUE KEY (user_id,`date`)
);
