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
/*Table structure for table `scheduler_event_dates` */

CREATE TABLE `scheduler_event_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_date` (`event_id`,`date`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_event_location_types` */

CREATE TABLE `scheduler_event_location_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` char(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_event_locations` */

CREATE TABLE `scheduler_event_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location_type_id` int(11) DEFAULT NULL,
  `address` char(64) DEFAULT NULL,
  `city` char(32) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(10) DEFAULT NULL,
  `phone` char(16) DEFAULT NULL,
  `comment` varchar(1024) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_event_participants` */

CREATE TABLE `scheduler_event_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_participants` (`event_id`,`user_id`),
  KEY `event` (`event_id`),
  KEY `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_event_roles` */

CREATE TABLE `scheduler_event_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `event_type_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_id` (`role_id`,`event_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_event_types` */

CREATE TABLE `scheduler_event_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT 'Default',
  `type` char(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `resource` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_events` */

CREATE TABLE `scheduler_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type_id` int(11) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `active` char(1) DEFAULT 'N',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `type_id` (`event_type_id`),
  KEY `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Table structure for table `scheduler_user_events` */

CREATE TABLE `scheduler_user_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `event_type_id` int(11) DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `comment` varchar(1024) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
