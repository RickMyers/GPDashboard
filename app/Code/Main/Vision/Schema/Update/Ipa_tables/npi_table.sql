 CREATE TABLE vision_address_npis
 (
	id INT NOT NULL AUTO_INCREMENT,
	address_id INT DEFAULT NULL,
	npi CHAR(16) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (address_id, npi)
 );

