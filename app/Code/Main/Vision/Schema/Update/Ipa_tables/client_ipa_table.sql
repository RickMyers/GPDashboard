 CREATE TABLE vision_client_ipas
 (
	id INT NOT NULL AUTO_INCREMENT,
	client_id INT DEFAULT NULL,
	ipa_id INT DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (client_id, ipa_id)
 );
