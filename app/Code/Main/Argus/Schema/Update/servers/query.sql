CREATE TABLE argus_servers
(
	id INT NOT NULL AUTO_INCREMENT,
	`name` CHAR(32) DEFAULT NULL,
	`server` CHAR(128) DEFAULT NULL,
	description CHAR(255) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id)
);


CREATE TABLE `humble_service_directory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT NULL,
  `controller` char(64) DEFAULT NULL,
  `action` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namespace` (`namespace`,`controller`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
