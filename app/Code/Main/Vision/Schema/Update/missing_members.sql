CREATE TABLE vision_missing_members
(
	id INT NOT NULL AUTO_INCREMENT,
	event_id INT DEFAULT NULL,
	health_plan_id INT DEFAULT NULL,
	member_number CHAR(32) DEFAULT NULL,
	first_name	CHAR(32) DEFAULT NULL,
	last_name	CHAR(32) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (event_id, health_plan_id, member_number)
);
