ALTER TABLE vision_consultation_forms ADD location_id_combo CHAR(128) DEFAULT NULL AFTER location_id;
ALTER TABLE vision_consultation_forms ADD ipa_id_combo CHAR(128) DEFAULT NULL AFTER ipa_id;
ALTER TABLE vision_consultation_forms ADD address_id_combo CHAR(128) DEFAULT NULL AFTER address_id;
ALTER TABLE vision_consultation_forms ADD npi_id CHAR(24) DEFAULT NULL AFTER address_id_combo;
ALTER TABLE vision_consultation_forms ADD npi_id_combo CHAR(24) DEFAULT NULL AFTER npi_id;

