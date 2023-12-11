/*
SQLyog Community v12.3.2 (64 bit)
MySQL - 5.7.16-log : Database - argus_dashboard
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `argus_activity_templates` */

-- IF EXISTS `argus_activity_templates`;

CREATE TABLE `argus_activity_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT 'argus',
  `name` char(32) DEFAULT NULL,
  `template` mediumtext,
  `created_by` int(11) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_address_types` */

-- IF EXISTS `argus_address_types`;

CREATE TABLE `argus_address_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_addresses` */

-- IF EXISTS `argus_addresses`;

CREATE TABLE `argus_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` char(64) DEFAULT NULL,
  `city` char(32) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(12) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_hedis_addresses_uidx` (`address`,`city`,`state`,`zip_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_apps_role_required` */

-- IF EXISTS `argus_apps_role_required`;

CREATE TABLE `argus_apps_role_required` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_id` (`app_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_chart_locations` */

-- IF EXISTS `argus_chart_locations`;

CREATE TABLE `argus_chart_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT NULL,
  `controller` char(48) DEFAULT NULL,
  `action` char(64) DEFAULT NULL,
  `layer` char(128) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_chart_locations_uidx` (`namespace`,`controller`,`action`,`layer`),
  KEY `argus_chart_locations_idx` (`namespace`,`controller`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_edi_providers` */

-- IF EXISTS `argus_edi_providers`;

CREATE TABLE `argus_edi_providers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_code` char(32) DEFAULT NULL,
  `employer_id` char(32) DEFAULT NULL,
  `entity_code` char(1) DEFAULT NULL,
  `last_name` char(32) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `middle_name` char(32) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `license_number` char(32) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_edi_receivers` */

-- IF EXISTS `argus_edi_receivers`;

CREATE TABLE `argus_edi_receivers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` char(32) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `middle_name` char(32) DEFAULT NULL,
  `entity_type` char(32) DEFAULT NULL,
  `organization` char(32) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_edi_submitters` */

-- IF EXISTS `argus_edi_submitters`;

CREATE TABLE `argus_edi_submitters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_code` char(32) DEFAULT NULL,
  `last_name` char(32) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `middle_name` char(32) DEFAULT NULL,
  `entity_type` char(2) DEFAULT NULL,
  `organization` char(32) DEFAULT NULL,
  `phone_number` char(10) DEFAULT NULL,
  `phone_ext` char(5) DEFAULT NULL,
  `email` char(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_email_categories` */

-- IF EXISTS `argus_email_categories`;

CREATE TABLE `argus_email_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` char(32) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_email_templates` */

-- IF EXISTS `argus_email_templates`;

CREATE TABLE `argus_email_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` char(32) DEFAULT NULL,
  `filename` char(128) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_email_types` */

-- IF EXISTS `argus_email_types`;

CREATE TABLE `argus_email_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_emails` */

-- IF EXISTS `argus_emails`;

CREATE TABLE `argus_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entities` */

-- IF EXISTS `argus_entities`;

CREATE TABLE `argus_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity` char(64) DEFAULT NULL,
  `entity_type_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_addresses` */

-- IF EXISTS `argus_entity_addresses`;

CREATE TABLE `argus_entity_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `address_type_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_administrators` */

-- IF EXISTS `argus_entity_administrators`;

CREATE TABLE `argus_entity_administrators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_entity_administrators_uidx` (`entity_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_contact_types` */

-- IF EXISTS `argus_entity_contact_types`;

CREATE TABLE `argus_entity_contact_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(64) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_contacts` */

-- IF EXISTS `argus_entity_contacts`;

CREATE TABLE `argus_entity_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `contact` char(255) DEFAULT NULL,
  `contact_type_id` int(11) DEFAULT NULL,
  `email` char(255) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `other` char(255) DEFAULT NULL,
  `other_type` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_phone_numbers` */

-- IF EXISTS `argus_entity_phone_numbers`;

CREATE TABLE `argus_entity_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `phone_number_type_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_relationships` */

-- IF EXISTS `argus_entity_relationships`;

CREATE TABLE `argus_entity_relationships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `effective_start_date` date DEFAULT NULL,
  `effective_end_date` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_types` */

-- IF EXISTS `argus_entity_types`;

CREATE TABLE `argus_entity_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(64) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_entity_users` */

-- IF EXISTS `argus_entity_users`;

CREATE TABLE `argus_entity_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `effective_start_date` date DEFAULT NULL,
  `effective_end_date` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_address_types` */

-- IF EXISTS `argus_hedis_address_types`;

CREATE TABLE `argus_hedis_address_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_addresses` */

-- IF EXISTS `argus_hedis_addresses`;

CREATE TABLE `argus_hedis_addresses` (
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
) ENGINE=InnoDB AUTO_INCREMENT=38907 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_call_log` */

-- IF EXISTS `argus_hedis_call_log`;

CREATE TABLE `argus_hedis_call_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48077 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_campaign_categories` */

-- IF EXISTS `argus_hedis_campaign_categories`;

CREATE TABLE `argus_hedis_campaign_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_campaign_results` */

-- IF EXISTS `argus_hedis_campaign_results`;

CREATE TABLE `argus_hedis_campaign_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `member_id` char(16) DEFAULT NULL,
  `requested_appointment` char(1) DEFAULT NULL,
  `yearly_dental_visit` char(1) DEFAULT NULL,
  `counseling_completed` char(1) DEFAULT NULL,
  `claim_status` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_id` (`campaign_id`,`member_id`),
  KEY `argus_hedis_campaign_results_cidx` (`contact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38723 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_campaigns` */

-- IF EXISTS `argus_hedis_campaigns`;

CREATE TABLE `argus_hedis_campaigns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `campaign` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_claim_batches` */

-- IF EXISTS `argus_hedis_claim_batches`;

CREATE TABLE `argus_hedis_claim_batches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_claims` */

-- IF EXISTS `argus_hedis_claims`;

CREATE TABLE `argus_hedis_claims` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `batch_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_contact_call_log` */

-- IF EXISTS `argus_hedis_contact_call_log`;

CREATE TABLE `argus_hedis_contact_call_log` (
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
) ENGINE=InnoDB AUTO_INCREMENT=29153 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_contact_call_schedule` */

-- IF EXISTS `argus_hedis_contact_call_schedule`;

CREATE TABLE `argus_hedis_contact_call_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
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
  KEY `argus_hedis_contact_call_schedule_address_idx` (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16474 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_contact_members` */

-- IF EXISTS `argus_hedis_contact_members`;

CREATE TABLE `argus_hedis_contact_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address_id` (`address_id`,`member_id`),
  KEY `argus_hedis_contact_members_aidx` (`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24432 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_member_addresses` */

-- IF EXISTS `argus_hedis_member_addresses`;

CREATE TABLE `argus_hedis_member_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `address_type` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_hedis_participant_addresses_uidx` (`member_id`,`address_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38907 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_member_phone_numbers` */

-- IF EXISTS `argus_hedis_member_phone_numbers`;

CREATE TABLE `argus_hedis_member_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `phone_number_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_hedis_participant_phone_numbers_uidx` (`member_id`,`phone_number_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38907 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_members` */

-- IF EXISTS `argus_hedis_members`;

CREATE TABLE `argus_hedis_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `member_id` char(24) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `last_name` char(32) DEFAULT NULL,
  `date_of_birth` date DEFAULT '0000-00-00',
  `gender` char(1) DEFAULT NULL,
  `language` char(12) DEFAULT NULL,
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`),
  UNIQUE KEY `first_name` (`first_name`,`last_name`,`date_of_birth`),
  KEY `argus_hedis_members_idx` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38906 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_members_bak` */

-- IF EXISTS `argus_hedis_members_bak`;

CREATE TABLE `argus_hedis_members_bak` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) DEFAULT NULL,
  `member_id` char(24) DEFAULT NULL,
  `first_name` char(32) DEFAULT NULL,
  `last_name` char(32) DEFAULT NULL,
  `date_of_birth` date DEFAULT '0000-00-00',
  `gender` char(1) DEFAULT NULL,
  `language` char(12) DEFAULT NULL,
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`),
  UNIQUE KEY `first_name` (`first_name`,`last_name`,`date_of_birth`)
) ENGINE=InnoDB AUTO_INCREMENT=38906 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_phone_number_types` */

-- IF EXISTS `argus_hedis_phone_number_types`;

CREATE TABLE `argus_hedis_phone_number_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_phone_numbers` */

-- IF EXISTS `argus_hedis_phone_numbers`;

CREATE TABLE `argus_hedis_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` char(24) DEFAULT NULL,
  `type_id` int(11) DEFAULT '1',
  `phi_scrambled` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43191 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_hedis_reassignment_reasons` */

-- IF EXISTS `argus_hedis_reassignment_reasons`;

CREATE TABLE `argus_hedis_reassignment_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_organization_entities` */

-- IF EXISTS `argus_organization_entities`;

CREATE TABLE `argus_organization_entities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` char(64) DEFAULT NULL,
  `entity` char(128) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `entity_type_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_organization_entity_types` */

-- IF EXISTS `argus_organization_entity_types`;

CREATE TABLE `argus_organization_entity_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(244) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_organization_types` */

-- IF EXISTS `argus_organization_types`;

CREATE TABLE `argus_organization_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(244) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_organizations` */

-- IF EXISTS `argus_organizations`;

CREATE TABLE `argus_organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization` char(64) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `org_type_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_phone_number_types` */

-- IF EXISTS `argus_phone_number_types`;

CREATE TABLE `argus_phone_number_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_phone_numbers` */

-- IF EXISTS `argus_phone_numbers`;

CREATE TABLE `argus_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` char(24) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_pin_repository` */

-- IF EXISTS `argus_pin_repository`;

CREATE TABLE `argus_pin_repository` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `pin` char(32) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_pin_repository_uidx` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_programs` */

-- IF EXISTS `argus_programs`;

CREATE TABLE `argus_programs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `program` char(32) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_provider_registration_form_attachments` */

-- IF EXISTS `argus_provider_registration_form_attachments`;

CREATE TABLE `argus_provider_registration_form_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) DEFAULT NULL,
  `field` char(64) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_provider_registration_form_attachments_uidx` (`form_id`,`field`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_provider_registration_forms` */

-- IF EXISTS `argus_provider_registration_forms`;

CREATE TABLE `argus_provider_registration_forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` char(44) DEFAULT NULL,
  `email` char(128) DEFAULT NULL,
  `pin` char(6) DEFAULT NULL,
  `name` char(128) DEFAULT NULL,
  `status` char(1) DEFAULT 'N',
  `date_submitted` datetime DEFAULT NULL,
  `date_reviewed` datetime DEFAULT NULL,
  `date_approved` datetime DEFAULT NULL,
  `date_returned` datetime DEFAULT NULL,
  `reviewer` int(11) DEFAULT NULL COMMENT 'The UID of the person reviewing the form',
  `approver` int(11) DEFAULT NULL COMMENT 'The UID of the person who approved',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_provider_registration_forms_uidx` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_categories` */

-- IF EXISTS `argus_report_categories`;

CREATE TABLE `argus_report_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` char(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_parameter_types` */

-- IF EXISTS `argus_report_parameter_types`;

CREATE TABLE `argus_report_parameter_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_parameters` */

-- IF EXISTS `argus_report_parameters`;

CREATE TABLE `argus_report_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `parameter_id` int(11) DEFAULT NULL,
  `default` char(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_projects` */

-- IF EXISTS `argus_report_projects`;

CREATE TABLE `argus_report_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project` char(64) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_projects_access` */

-- IF EXISTS `argus_report_projects_access`;

CREATE TABLE `argus_report_projects_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `argus_report_projects_access_uidx` (`project_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_projects_access_denied` */

-- IF EXISTS `argus_report_projects_access_denied`;

CREATE TABLE `argus_report_projects_access_denied` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `denied_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`role_id`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_report_widgets` */

-- IF EXISTS `argus_report_widgets`;

CREATE TABLE `argus_report_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `widget` char(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_reports` */

-- IF EXISTS `argus_reports`;

CREATE TABLE `argus_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report` char(128) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_reports_access` */

-- IF EXISTS `argus_reports_access`;

CREATE TABLE `argus_reports_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_roles` */

-- IF EXISTS `argus_roles`;

CREATE TABLE `argus_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) DEFAULT NULL,
  `default` char(1) DEFAULT 'N',
  `immutable` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_secure_data` */

-- IF EXISTS `argus_secure_data`;

CREATE TABLE `argus_secure_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` char(64) DEFAULT NULL,
  `secure_data_1` blob,
  `secure_data_2` blob,
  `secure_data_3` blob,
  `secure_data_4` blob,
  `secure_data_5` blob,
  `secure_data_6` blob,
  `secure_data_7` blob,
  `secure_data_8` blob,
  `secure_data_9` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `source` (`source`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_user_roles` */

-- IF EXISTS `argus_user_roles`;

CREATE TABLE `argus_user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;

/*Table structure for table `argus_user_settings` */

-- IF EXISTS `argus_user_settings`;

CREATE TABLE `argus_user_settings` (
  `id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `argus_workflow_email_templates` */

-- IF EXISTS `argus_workflow_email_templates`;

CREATE TABLE `argus_workflow_email_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(128) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `template` text,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
