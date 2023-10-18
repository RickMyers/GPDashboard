                 CREATE TABLE dashboard_desktop_available_apps
                 (
			id INT NOT NULL AUTO_INCREMENT,
			app		CHAR(64) DEFAULT NULL,
			description 	CHAR(255) DEFAULT NULL,
			icon    	CHAR(128) DEFAULT NULL,
			minimized_icon  CHAR(128) DEFAULT NULL,
			url       	CHAR(128) DEFAULT NULL,
			component 	CHAR(128) DEFAULT NULL,
			author  	INT DEFAULT NULL,
			modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (id)                 
                 );
                 
                 CREATE TABLE dashboard_desktop_installed_apps
                 (
			id 		INT NOT NULL AUTO_INCREMENT,
			app_id 		INT DEFAULT NULL,
			user_id 	INT DEFAULT NULL,
			added 		DATETIME DEFAULT NULL,
			modified 	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (id),
			UNIQUE KEY (app_id,user_id)
                 );
                 
                 CREATE TABLE dashboard_desktop_app_roles
                 (
			id INT NOT NULL AUTO_INCREMENT,
			app_id INT DEFAULT NULL,
			role_id INT DEFAULT NULL,
			modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (id),
			UNIQUE KEY (app_id,role_id)                 
                 );