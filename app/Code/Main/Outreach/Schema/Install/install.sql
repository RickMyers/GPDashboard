/*
SQLyog Community
MySQL - 8.0.23 : Database - dashboard
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `outreach_campaign_member_logs` */

CREATE TABLE `outreach_campaign_member_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contact_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `log` char(255) DEFAULT NULL,
  `log_date` datetime DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `outreach_campaign_members` */

CREATE TABLE `outreach_campaign_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `campaign_id` int DEFAULT NULL,
  `member_number` char(32) DEFAULT NULL,
  `date_added` date DEFAULT NULL,
  `status` char(1) DEFAULT 'N',
  `assignee` int DEFAULT NULL,
  `attempts` int DEFAULT '0',
  `completed_date` datetime DEFAULT NULL,
  `gap_closed_date` date DEFAULT NULL,
  `follow_up` char(1) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `outreach_campaign_members_idx` (`campaign_id`,`member_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `outreach_campaigns` */

CREATE TABLE `outreach_campaigns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `campaign` char(64) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `active` char(1) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `outreach_participant_roles` */

CREATE TABLE `outreach_participant_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `campaign_id` int DEFAULT NULL,
  `participant_id` int DEFAULT NULL,
  `manager` char(1) DEFAULT NULL,
  `coordinator` char(1) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `outreach_participant_roles_uidx` (`campaign_id`,`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `outreach_participants` */

CREATE TABLE `outreach_participants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `campaign_id` int DEFAULT NULL,
  `participant_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `outreach_roles` */

CREATE TABLE `outreach_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` char(32) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

