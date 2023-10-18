
create table vision_ipa_physicians
(
	id int not null auto_increment,
	ipa_id int default null,
	pcp_id int default null,
	modified timestamp default current_timestamp,
	primary key (id),
	unique key (ipa_id, pcp_id)
);