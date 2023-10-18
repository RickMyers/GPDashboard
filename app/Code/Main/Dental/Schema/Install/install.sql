/*
SQLyog Community v12.4.3 (64 bit)
MySQL - 5.7.18-log : Database - dashboard
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `dental_address_types` */

CREATE TABLE `dental_address_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_addresses` */

CREATE TABLE `dental_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` char(64) DEFAULT NULL,
  `city` char(32) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(12) DEFAULT NULL,
  `type_id` int(11) DEFAULT '1',
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_hedis_addresses_uidx` (`address`,`city`,`state`,`zip_code`,`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23525 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_call_log` */

CREATE TABLE `dental_call_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33449 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_campaign_categories` */

CREATE TABLE `dental_campaign_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_campaign_results` */

CREATE TABLE `dental_campaign_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `member_id` char(16) DEFAULT NULL,
  `requested_appointment` char(1) DEFAULT NULL,
  `yearly_dental_visit` char(1) DEFAULT NULL,
  `counseling_completed` char(1) DEFAULT NULL,
  `requested_appointment_date` datetime DEFAULT NULL,
  `yearly_dental_visit_date` datetime DEFAULT NULL,
  `counseling_completed_date` datetime DEFAULT NULL,
  `claim_status` char(1) DEFAULT 'N',
  `claimed_date` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_id` (`campaign_id`,`member_id`),
  KEY `argus_hedis_campaign_results_cidx` (`contact_id`),
  KEY `argus_hedis_campaign_results_midx` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35716 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_campaigns` */

CREATE TABLE `dental_campaigns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `campaign` char(64) DEFAULT NULL,
  `active` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_claim_batches` */

CREATE TABLE `dental_claim_batches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dental_claims` */

CREATE TABLE `dental_claims` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dental_consultation_forms` */

CREATE TABLE `dental_consultation_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hygienist` int(11) DEFAULT NULL,
  `dentist` int(11) DEFAULT NULL,
  `visit_date` date DEFAULT NULL,
  `submit_date` date DEFAULT NULL,
  `last_activity_date` datetime DEFAULT NULL,
  `review_by_date` date DEFAULT NULL,
  `member_id` char(32) DEFAULT NULL,
  `member_name` char(64) DEFAULT NULL,
  `status` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_consultation_snapshots` */

CREATE TABLE `dental_consultation_snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `taken_by` int(11) DEFAULT NULL,
  `snapshot` mediumtext,
  `thumbnail` mediumtext,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=626 DEFAULT CHARSET=latin1;

/*Table structure for table `dental_consultation_xrays` */

CREATE TABLE `dental_consultation_xrays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `member_id` char(24) DEFAULT NULL,
  `xray` mediumtext,
  `filename` char(64) DEFAULT NULL,
  `thumbnail` mediumtext,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `dental_consultation_xrays_formid` (`form_id`),
  KEY `dental_consultation_xrays_memberid` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Table structure for table `dental_contact_call_log` */

CREATE TABLE `dental_contact_call_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comments` text,
  `attempt` int(11) DEFAULT '0',
  `time_of_call` char(12) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `argus_hedis_contact_call_log_cidx` (`contact_id`),
  KEY `argus_hedis_contact_call_log_useridx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36003 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_contact_call_schedule` */

CREATE TABLE `dental_contact_call_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `members` int(11) DEFAULT '1',
  `assignee` int(11) DEFAULT NULL,
  `status` char(1) DEFAULT 'A',
  `number_of_attempts` int(11) DEFAULT '0',
  `in_progress` char(1) DEFAULT 'N',
  `working_number` char(1) DEFAULT NULL,
  `wrong_number` char(1) DEFAULT NULL,
  `left_message` char(1) DEFAULT NULL,
  `do_not_call` char(1) DEFAULT 'N',
  `claim_status` char(1) DEFAULT 'N',
  `last_activity_date` datetime DEFAULT NULL,
  `status_change_date` datetime DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `argus_hedis_contact_call_schedule_assignee_idx` (`assignee`),
  KEY `argus_hedis_contact_call_schedule_address_idx` (`address_id`),
  KEY `argus_hedis_contact_call_schedule_campaign_idx` (`campaign_id`),
  KEY `argus_hedis_contact_call_schedule_campass_idx` (`campaign_id`,`assignee`)
) ENGINE=InnoDB AUTO_INCREMENT=18606 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_contact_members` */

CREATE TABLE `dental_contact_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address_id` (`address_id`,`member_id`),
  KEY `argus_hedis_contact_members_aidx` (`address_id`),
  KEY `argus_hedis_contact_members_midx` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22365 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_member_addresses` */

CREATE TABLE `dental_member_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `address_type` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_hedis_participant_addresses_uidx` (`member_id`,`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23525 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_member_phone_numbers` */

CREATE TABLE `dental_member_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_hedis_participant_phone_numbers_uidx` (`member_id`,`phone_number_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26548 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_members` */

CREATE TABLE `dental_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `member_id` char(24) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `last_name` char(32) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `language` char(12) DEFAULT NULL,
  `eligibility_start_date` date DEFAULT NULL,
  `eligibility_end_date` date DEFAULT NULL,
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `first_name` (`first_name`,`last_name`,`date_of_birth`),
  UNIQUE KEY `member_id` (`member_id`,`campaign_id`),
  KEY `argus_hedis_members_idx` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23525 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_mouthwatch_scans` */

CREATE TABLE `dental_mouthwatch_scans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `file_name` char(64) DEFAULT NULL,
  `added_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `form_id` (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dental_phone_number_types` */

CREATE TABLE `dental_phone_number_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_phone_numbers` */

CREATE TABLE `dental_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` char(24) DEFAULT NULL,
  `type_id` int(11) DEFAULT '1',
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26548 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_portal` */

CREATE TABLE `dental_portal` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` char(128) DEFAULT NULL,
  `pin` char(6) DEFAULT NULL,
  `page` char(38) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `dental_waiting_room` */

CREATE TABLE `dental_waiting_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participant` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dental_waiting_rooms` */

CREATE TABLE `dental_waiting_rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hygienist` int(11) DEFAULT NULL,
  `session_start` datetime DEFAULT NULL,
  `form_id` int(11) DEFAULT NULL,
  `status` char(1) DEFAULT 'I',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hygienist` (`hygienist`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
