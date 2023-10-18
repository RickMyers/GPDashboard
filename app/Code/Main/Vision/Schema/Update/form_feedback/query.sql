 CREATE TABLE vision_consultation_feedback
 (
	id INT NOT NULL AUTO_INCREMENT,
	form_id INT DEFAULT NULL,
	image_quality CHAR(01) DEFAULT NULL,
	missing_a1c   CHAR(01) DEFAULT NULL,
	missing_diabetes_type CHAR(01) DEFAULT NULL,
	missing_pcp_npi CHAR(01) DEFAULT NULL,
	missing_event_location CHAR(01) DEFAULT NULL,
	no_readable_images CHAR(01) DEFAULT NULL,
	additional_comments TEXT,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (form_id)
 );
