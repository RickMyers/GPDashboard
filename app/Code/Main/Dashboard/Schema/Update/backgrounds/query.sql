CREATE TABLE dashboard_backgrounds
(
	id INT NOT NULL AUTO_INCREMENT,
	background CHAR(32) DEFAULT NULL,
	`default` CHAR(01) DEFAULT 'N',
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);
