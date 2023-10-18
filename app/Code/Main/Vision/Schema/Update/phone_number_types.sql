                   CREATE TABLE vision_phone_number_types
                   (
			id INT NOT NULL AUTO_INCREMENT,
			`type` CHAR(32) DEFAULT NULL,
			description CHAR(255) DEFAULT NULL,
			modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (id)
                   );
