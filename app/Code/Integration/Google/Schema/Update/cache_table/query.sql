DROP TABLE IF EXISTS google_cache;
CREATE TABLE google_cache
(
	id INT NOT NULL AUTO_INCREMENT,
	`key` CHAR(36) DEFAULT NULL,
        modified timestamp default current_timestamp,
	PRIMARY KEY (id),
	INDEX google_cache_idx (`key`)
);
