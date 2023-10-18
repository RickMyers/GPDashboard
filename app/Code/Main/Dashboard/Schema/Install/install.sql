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
/*Table structure for table `dashboard_alert_roles` */

-- IF EXISTS `dashboard_alert_roles`;

CREATE TABLE `dashboard_alert_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alert_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_alerts` */

-- IF EXISTS `dashboard_alerts`;

CREATE TABLE `dashboard_alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) DEFAULT NULL,
  `action` char(32) DEFAULT NULL,
  `callback` char(128) DEFAULT NULL,
  `arguments` char(128) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_available_apps` */

-- IF EXISTS `dashboard_available_apps`;

CREATE TABLE `dashboard_available_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) DEFAULT NULL,
  `setup_uri` char(64) DEFAULT NULL,
  `action` char(64) DEFAULT NULL,
  `icon` char(128) DEFAULT NULL,
  `callback` char(128) DEFAULT NULL,
  `arguments` char(128) DEFAULT NULL,
  `default` char(1) DEFAULT 'N',
  `period` int(11) DEFAULT '4',
  `zones` char(10) DEFAULT '1x1',
  `description` varchar(255) DEFAULT NULL,
  `widget` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_chart_locations` */

-- IF EXISTS `dashboard_chart_locations`;

CREATE TABLE `dashboard_chart_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT NULL,
  `controller` char(48) DEFAULT NULL,
  `action` char(64) DEFAULT NULL,
  `layer` char(128) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `focos_chart_locations_uidx` (`namespace`,`controller`,`action`,`layer`),
  KEY `focos_chart_locations_idx` (`namespace`,`controller`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_chart_packages` */

-- IF EXISTS `dashboard_chart_packages`;

CREATE TABLE `dashboard_chart_packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package` char(64) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_chart_roles` */

-- IF EXISTS `dashboard_chart_roles`;

CREATE TABLE `dashboard_chart_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chart_package_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dashboard_chart_roles_uidx` (`chart_package_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_charts` */

-- IF EXISTS `dashboard_charts`;

CREATE TABLE `dashboard_charts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) DEFAULT '0',
  `name` char(64) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `namespace` char(32) DEFAULT 'dashboard',
  `resource` char(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_control_roles` */

-- IF EXISTS `dashboard_control_roles`;

CREATE TABLE `dashboard_control_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `control_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `control_id` (`control_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_controls` */

-- IF EXISTS `dashboard_controls`;

CREATE TABLE `dashboard_controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` char(32) DEFAULT NULL,
  `icon_class` char(128) DEFAULT NULL,
  `method` char(128) DEFAULT NULL,
  `style` varchar(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_installed_apps` */

-- IF EXISTS `dashboard_installed_apps`;

CREATE TABLE `dashboard_installed_apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dashboard_installed_apps_uidx` (`user_id`,`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_navigation` */

-- IF EXISTS `dashboard_navigation`;

CREATE TABLE `dashboard_navigation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT NULL,
  `controller` char(32) DEFAULT NULL,
  `action` char(32) DEFAULT NULL,
  `option_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `namespace` (`namespace`,`controller`,`action`,`option_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_navigation_options` */

-- IF EXISTS `dashboard_navigation_options`;

CREATE TABLE `dashboard_navigation_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` char(32) DEFAULT NULL,
  `class` char(32) DEFAULT 'dashboard-icon',
  `method` char(128) DEFAULT NULL,
  `style` char(128) DEFAULT NULL,
  `image` char(128) DEFAULT NULL,
  `image_style` char(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_navigation_roles` */

-- IF EXISTS `dashboard_navigation_roles`;

CREATE TABLE `dashboard_navigation_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `option_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `option_id` (`option_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_user_charts` */

-- IF EXISTS `dashboard_user_charts`;

CREATE TABLE `dashboard_user_charts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` char(32) DEFAULT NULL,
  `controller` char(64) DEFAULT NULL,
  `action` char(64) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `chart_id` int(11) DEFAULT NULL,
  `layer` char(64) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dashboard_user_charts_uidx` (`namespace`,`controller`,`action`,`user_id`,`layer`)
) ENGINE=InnoDB AUTO_INCREMENT=535 DEFAULT CHARSET=utf8;

/*Table structure for table `dashboard_white_labels` */

-- IF EXISTS `dashboard_white_labels`;

CREATE TABLE `dashboard_white_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` char(128) DEFAULT NULL,
  `short_name` char(24) DEFAULT NULL,
  `banner_dark` char(128) DEFAULT NULL,
  `banner_light` char(128) DEFAULT NULL,
  `banner_height` int(11) DEFAULT '30',
  `window_icon` char(128) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
