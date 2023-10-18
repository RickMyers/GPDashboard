CREATE TABLE vision_invoices 
(
   id INT NOT NULL AUTO_INCREMENT,
   `to` 	CHAR(64) DEFAULT NULL,
   `name` 	CHAR(64) DEFAULT NULL,
   company      CHAR(96) DEFAULT NULL,
   address      CHAR(128) DEFAULT NULL,
   city 	CHAR(48) DEFAULT NULL,
   state 	CHAR(02) DEFAULT NULL,
   zip_code     CHAR(11) DEFAULT NULL,
   phone 	CHAR(16) DEFAULT NULL,
   email 	CHAR(128) DEFAULT NULL,
   paid 	CHAR(01) DEFAULT 'N',
   modified     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id)
);
CREATE TABLE vision_invoice_forms
(
   id           INT NOT NULL AUTO_INCREMENT,
   invoice_id   INT DEFAULT NULL,
   form_id      INT DEFAULT NULL,
   modified     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (id)             
);