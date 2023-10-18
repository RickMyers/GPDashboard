ALTER TABLE vision_consultation_forms ADD pc_2023f CHAR(01) DEFAULT NULL AFTER pc_2022f_8p;
ALTER TABLE vision_consultation_forms ADD client_id INT DEFAULT NULL AFTER form_type;
ALTER TABLE vision_consultation_forms ADD ipa_id INT DEFAULT NULL AFTER client_id;
ALTER TABLE vision_consultation_forms ADD location_id INT DEFAULT NULL AFTER ipa_id;
ALTER TABLE vision_consultation_forms ADD address_id INT DEFAULT NULL AFTER location_id;
