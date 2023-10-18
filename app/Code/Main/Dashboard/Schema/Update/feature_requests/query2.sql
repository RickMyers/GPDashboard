CREATE TABLE dashboard_request_screenshots
(
	id INT NOT NULL AUTO_INCREMENT,
	request_id INT DEFAULT NULL,
	screenshot MEDIUMTEXT,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);

ALTER TABLE dashboard_requests ADD submitter INT DEFAULT NULL AFTER id;
