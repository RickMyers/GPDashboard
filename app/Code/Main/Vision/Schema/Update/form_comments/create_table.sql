                CREATE TABLE vision_consultation_form_comments
                (
			id INT NOT NULL AUTO_INCREMENT,
			form_id INT DEFAULT NULL,
			user_id INT DEFAULT NULL,
                        `comment` text,
			posted DATETIME DEFAULT NULL,
			modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			INDEX (form_id),
			PRIMARY KEY (id)
                );
                
