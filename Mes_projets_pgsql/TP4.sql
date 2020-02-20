DROP TABLE IF EXISTS eleveur;

DROP TABLE IF EXISTS adresse;
DROP TYPE IF EXISTS t_adresse;

DROP TABLE IF EXISTS elevage;
DROP TYPE IF EXISTS t_elevage;

CREATE TYPE t_elevage AS (
	animal	varchar(30),
	ageMin	int,
	nbMax	int
	);
CREATE TABLE elevage OF t_elevage;

INSERT INTO elevage VALUES
	('bovin',		3,	50),
	('ovin',		5,	70),
	('volaille',	1,	1000),
	('porcin',		2,	400);					SELECT * FROM elevage;

CREATE TYPE t_adresse AS (
	nrue	int,
	rue	varchar(30),
	ville	varchar(30),
	CP	int
	);
CREATE TABLE adresse OF t_adresse;

INSERT iNtO adresse VALUES
	(3,		'August',	'Angers',	49000),
	(12,	'Miche',	'Pont-Cé',	49200),
	(20,	'Trouve',	'Bordeaux',	33000),
	(54,	'August',	'Beaucouz',	48000);		SELECT * FROM adresse;

CREATE TABLE eleveur (
	Licence	int,
	elevage	t_elevage,
	adresse	t_adresse
	);
	
INSERT INTO eleveur VALUES
	(1,		(SELECT e FROM elevage e WHERE animal = 'ovin'),		(SELECT e FROM adresse e WHERE nrue = 3)),
	(2,		(SELECT e FROM elevage e WHERE animal = 'bovins'),		(SELECT e FROM adresse e WHERE nrue = 12)),
	(3,		(SELECT e FROM elevage e WHERE animal = 'volaille'),	(SELECT e FROM adresse e WHERE nrue = 54));
	
UPDATE eleveur VALUES
	SET elevage.animal='porcin' WHERE Licence=2;

												SELECT * FROM eleveur ORDER BY Licence;

UPDATE eleveur e
	SET adresse=(SELECT ad FROM adresse ad WHERE ville='Bordeaux') WHERE (e.elevage).animal='ovin';
		
												SELECT * FROM eleveur ORDER BY Licence;

CREATE TRIGGER climatParis 
