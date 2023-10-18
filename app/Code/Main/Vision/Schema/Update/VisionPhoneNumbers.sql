CREATE TABLE vision_phone_numbers
(
	id INT NOT NULL AUTO_INCREMENT,
	phone_number CHAR(16) DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (phone_number)
);


CREATE TABLE vision_member_phone_numbers
(
	id INT NOT NULL AUTO_INCREMENT,
	member_id  INT DEFAULT NULL,
	phone_number_id INT DEFAULT NULL,
	phone_number_type_id INT DEFAULT NULL,
	modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (member_id, phone_number_id,phone_number_type_id)
);

update vision_members add health_plan_id int default null;

update vision_members add gap_closed date default null;