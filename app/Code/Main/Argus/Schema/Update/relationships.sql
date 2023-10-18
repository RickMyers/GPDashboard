CREATE TABLE argus_relationship_dates
(
	id INT NOT NULL AUTO_INCREMENT,
	member_id INT DEFAULT NULL,
	relation_id INT DEFAULT NULL,
	relationship_type INT DEFAULT NULL,
	effective_start_date DATE DEFAULT NULL,
	effective_end_date DATE DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);
CREATE TABLE argus_relationship_types
(
	id INT NOT NULL AUTO_INCREMENT,
	relationship CHAR(32) DEFAULT NULL,
	description CHAR(255) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(id)
);
