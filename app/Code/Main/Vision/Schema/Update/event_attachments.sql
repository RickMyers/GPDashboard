CREATE TABLE vision_event_attachments
(
	id INT NOT NULL AUTO_INCREMENT,
	event_id INT DEFAULT NULL,
	author_id INT DEFAULT NULL,
	filename CHAR(128) DEFAULT NULL,
	description CHAR(255) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);
CREATE UNIQUE INDEX vision_event_attachments_uidx ON vision_event_attachments(event_id,filename);