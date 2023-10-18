CREATE TABLE dashboard_request_attachments
(
	id INT NOT NULL auto_increment,
	request_id INT DEFAULT NULL,
	attachment CHAR(128) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);
