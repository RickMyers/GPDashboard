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
/*Table structure for table `vision_address_types` */

CREATE TABLE `vision_address_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_addresses` */

CREATE TABLE `vision_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` char(64) DEFAULT NULL,
  `city` char(32) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(12) DEFAULT NULL,
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_address_idx` (`address`,`city`,`state`,`zip_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4726 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_campaign_participants` */

CREATE TABLE `vision_campaign_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `participant` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vision_campaign_participants_uidx` (`campaign_id`,`participant`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_clients` */

CREATE TABLE `vision_clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vision_clients_uidx` (`client`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_consultation_forms` */

CREATE TABLE `vision_consultation_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  `address_id` char(255) DEFAULT NULL,
  `submitted` timestamp NULL DEFAULT NULL,
  `last_activity` timestamp NULL DEFAULT NULL,
  `last_action` char(32) DEFAULT NULL,
  `review_by` timestamp NULL DEFAULT NULL,
  `reviewer` int(11) DEFAULT NULL,
  `technician` int(11) DEFAULT NULL,
  `member_id` char(32) DEFAULT NULL,
  `status` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `member_name` char(64) DEFAULT NULL,
  `pc_s3000` char(1) DEFAULT '' COMMENT 'Diabetic retinal exam; dilated, bilateral',
  `pc_2022f_8p` char(1) DEFAULT '' COMMENT 'DFE  no DFE w review by O.D. and documented',
  `pc_5010f` char(1) DEFAULT '' COMMENT 'PCP report -dilated macular/fundus exam ',
  `pc_3072f` char(1) DEFAULT '' COMMENT 'Low risk for DR (no evidence of retinopathy in prior yr)',
  `pc_92227` char(1) DEFAULT '' COMMENT 'Retinal Telescreening w/interpretation by O.D.',
  `pc_2026f` char(1) DEFAULT '' COMMENT 'Validation of image',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2964 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_event_locations` */

CREATE TABLE `vision_event_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `vision_event_members` */

CREATE TABLE `vision_event_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `form_generated` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_event` (`event_id`,`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_event_members_old` */

CREATE TABLE `vision_event_members_old` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` char(16) DEFAULT NULL,
  `name` char(80) DEFAULT NULL,
  `address` char(128) DEFAULT NULL,
  `primary_care_physician` char(128) DEFAULT NULL,
  `primary_care_physician_address` char(128) DEFAULT NULL,
  `primary_care_physician_fax` char(24) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `phone_number` char(16) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16438 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_event_npi` */

CREATE TABLE `vision_event_npi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `npi_id` char(16) DEFAULT NULL COMMENT 'npi number for doctor (and location?)',
  `location` char(64) DEFAULT NULL COMMENT 'location name (needed?)',
  `created_on` datetime DEFAULT NULL COMMENT 'when field was created',
  `modified` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'last time was modified',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_events` */

CREATE TABLE `vision_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `office` char(64) DEFAULT NULL,
  `address` char(128) DEFAULT NULL,
  `npi_id` char(15) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `date` (`date`,`office`,`address`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_form_feedback` */

CREATE TABLE `vision_form_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `respondent` int(11) DEFAULT NULL,
  `image_quantity` smallint(6) DEFAULT NULL,
  `image_quality` smallint(6) DEFAULT NULL,
  `feedback` text,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vision_form_feedback_uidx` (`form_id`)
) ENGINE=InnoDB AUTO_INCREMENT=615 DEFAULT CHARSET=latin1;

/*Table structure for table `vision_ipa` */

CREATE TABLE `vision_ipa` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Ascending ID of the IPA',
  `order_by_num` int(11) DEFAULT NULL COMMENT 'Used to dictate which order they will appear in dropdown',
  `ipa_id` int(11) DEFAULT NULL COMMENT 'ID used by other tables on the Id of the IPA',
  `ipa_name` char(32) DEFAULT NULL COMMENT 'The actual IPA''s name',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The last time the column was modified',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When the column was created',
  `is_enabled` tinyint(1) DEFAULT '1',
  `is_not_other` tinyint(1) DEFAULT '1' COMMENT 'Allows Other to appear last in selection',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_ipa_sub` */

CREATE TABLE `vision_ipa_sub` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_name` char(50) DEFAULT NULL,
  `ipa_parent_id` int(11) DEFAULT NULL,
  `sub_id` int(11) DEFAULT NULL,
  `sub_order_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_on` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `is_enabled` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_location_types` */

CREATE TABLE `vision_location_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `vision_locations` */

CREATE TABLE `vision_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `health_plan_id` int(11) DEFAULT NULL,
  `name` char(64) NOT NULL DEFAULT '',
  `address1` char(32) DEFAULT NULL,
  `address2` char(32) NOT NULL DEFAULT '',
  `city` char(32) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(10) DEFAULT NULL,
  `npi` char(32) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `addr_uidx` (`address1`,`address2`,`city`,`state`,`zip_code`,`health_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_member_addresses` */

CREATE TABLE `vision_member_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `address_type_id` int(11) DEFAULT '1',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vision_member_uidx` (`member_id`,`address_id`,`address_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4726 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_member_phone_numbers` */

CREATE TABLE `vision_member_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `phone_number_type_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`,`phone_number_id`,`phone_number_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4726 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_members` */

CREATE TABLE `vision_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `health_plan_id` int(11) DEFAULT NULL,
  `member_number` char(16) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `last_name` char(32) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `language` char(5) DEFAULT NULL,
  `gap_closed` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `membernumber` (`member_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4726 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_od_predetermined` */

CREATE TABLE `vision_od_predetermined` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iop_od` decimal(10,0) DEFAULT NULL,
  `iop_os` decimal(10,0) DEFAULT NULL,
  `ta_tp` char(11) DEFAULT NULL,
  `dilation` char(6) DEFAULT NULL,
  `od_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_phone_numbers` */

CREATE TABLE `vision_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` char(16) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4726 DEFAULT CHARSET=utf8;

/*Table structure for table `vision_retina_scans` */

CREATE TABLE `vision_retina_scans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `file_name` char(64) DEFAULT NULL,
  `added_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `form_id` (`form_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11568 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
