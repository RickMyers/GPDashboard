/*
SQLyog Community v12.4.3 (64 bit)
MySQL - 5.7.16-log : Database - argus_dashboard
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `librio_actions` */

-- IF EXISTS `librio_actions`;

CREATE TABLE `librio_actions` (
  `id` int(11) NOT NULL,
  `action` char(32) DEFAULT NULL,
  `seq` int(11) DEFAULT '1',
  `handler` char(128) DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_permissions` */

-- IF EXISTS `librio_permissions`;

CREATE TABLE `librio_permissions` (
  `id` int(11) NOT NULL,
  `permission` char(32) DEFAULT NULL,
  `seq` int(11) DEFAULT '1',
  `handler` char(128) DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_project_categories` */

-- IF EXISTS `librio_project_categories`;

CREATE TABLE `librio_project_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `category` char(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_project_document_history` */

-- IF EXISTS `librio_project_document_history`;

CREATE TABLE `librio_project_document_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `document_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT '1',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_project_documents` */

-- IF EXISTS `librio_project_documents`;

CREATE TABLE `librio_project_documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `document` char(64) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `last_action` char(32) DEFAULT NULL,
  `last_action_date` datetime DEFAULT NULL,
  `current_owner` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_project_permissions` */

-- IF EXISTS `librio_project_permissions`;

CREATE TABLE `librio_project_permissions` (
  `id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `permission_id` int(11) DEFAULT NULL,
  `granted_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_project_role_permissions` */

-- IF EXISTS `librio_project_role_permissions`;

CREATE TABLE `librio_project_role_permissions` (
  `id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `permission_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `granted_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_projects` */

-- IF EXISTS `librio_projects`;

CREATE TABLE `librio_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project` char(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `librio_user_permissions` */

-- IF EXISTS `librio_user_permissions`;

CREATE TABLE `librio_user_permissions` (
  `id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `permission_id` int(11) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `granted_by` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
