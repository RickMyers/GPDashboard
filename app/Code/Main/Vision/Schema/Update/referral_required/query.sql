ALTER TABLE vision_consultation_forms ADD referral CHAR(01) DEFAULT 'N' after pc_2026f;
ALTER TABLE vision_consultation_forms ADD referred CHAR(01) DEFAULT 'N' after referral;
