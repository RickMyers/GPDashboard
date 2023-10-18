
ALTER TABLE vision_consultation_forms ADD phonetic_token1 CHAR(32) DEFAULT NULL AFTER member_name;
ALTER TABLE vision_consultation_forms ADD phonetic_token2 CHAR(32) DEFAULT NULL AFTER phonetic_token1;
