

CREATE TABLE dashboard_modules
(
	id INT NOT NULL AUTO_INCREMENT,
	module CHAR(64) DEFAULT NULL,
	description CHAR(255) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (module)
);
CREATE TABLE dashboard_features
(
	id INT NOT NULL AUTO_INCREMENT,
	feature CHAR(64) DEFAULT NULL,
	description CHAR(255) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (feature)
);
CREATE TABLE dashboard_module_features
(
	id INT NOT NULL AUTO_INCREMENT,
	module_id INT DEFAULT NULL,
	feature_id INT DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (module_id,feature_id)
);
CREATE TABLE dashboard_requests
(
	id INT NOT NULL AUTO_INCREMENT,
	request_type CHAR(16) DEFAULT NULL,
	module_id INT DEFAULT NULL,
	feature_id INT DEFAULT NULL,
	description TEXT,
        priority int default null,
	notes TEXT,
	`status` CHAR(01) DEFAULT NULL,
	submitted DATETIME DEFAULT NULL,
	completed DATETIME DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);
