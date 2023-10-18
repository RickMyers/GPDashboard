
                      CREATE TABLE argus_utility_run_log
                      (
			id INT NOT NULL AUTO_INCREMENT,
			utility CHAR(64) DEFAULT NULL,
			command CHAR(255) DEFAULT NULL,
			run_date DATETIME DEFAULT NULL,
			rc  INT DEFAULT NULL,
			modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (id)
                      );