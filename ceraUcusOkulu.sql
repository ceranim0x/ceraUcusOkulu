INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_flightschool', 'LSFS', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('flightschool', 'LSFS')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('flightschool',0,'recruit','Stajyer',1000, '{}', '{}'),
	('flightschool',1,'experienced','Eğitici',2000, '{}', '{}'),
	('flightschool',2,'manager','Uzman Epitici',3000, '{}', '{}'),
	('flightschool',3,'boss','Patron',4000, '{}', '{}')
;

INSERT INTO `licenses` (`type`, `label`) VALUES
	('flylic', 'Uçuş Lisansı')
;
