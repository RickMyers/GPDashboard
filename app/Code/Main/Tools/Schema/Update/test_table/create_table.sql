create table argustools_inventory 
(
	id int not null auto_increment,
	`name` char(32) default null,
	`description` char(128) default null,
	modified timestamp default current_timestamp,
	primary key (id)
);
