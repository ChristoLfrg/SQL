DROP TRIGGER IF EXISTS angevinsVolaille ON eleveur CASCADE;
DROP FUNCTION fVolaille();

DROP TRIGGER IF EXISTS climatParis ON eleveur CASCADE;
DROP FUNCTION fClimat();

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
	(12,	'Miche',	'Paris',	75000),
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
	(3,		(SELECT e FROM elevage e WHERE animal = 'porcin'),	(SELECT e FROM adresse e WHERE nrue = 3));
	
UPDATE eleveur VALUES
	SET elevage=(SELECT e FROM elevage e WHERE animal = 'porcin') WHERE Licence=2;

												SELECT * FROM eleveur ORDER BY Licence;

UPDATE eleveur e
	SET adresse=(SELECT ad FROM adresse ad WHERE ville='Bordeaux') WHERE (e.elevage).animal='ovin';
		
												SELECT * FROM eleveur ORDER BY Licence;

UPDATE eleveur e
	SET elevage=NULL WHERE (e.adresse).CP = 75000;
												SELECT * FROM eleveur ORDER BY Licence;

CREATE FUNCTION fClimat() RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.adresse).CP = 75000 
		THEN NEW.elevage = NULL;
	END IF;
	RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER climatParis BEFORE INSERT ON eleveur 
FOR EACH ROW EXECUTE PROCEDURE fClimat();

INSERT INTO eleveur VALUES
(4, (SELECT e FROM elevage e WHERE animal = 'bovins'), (SELECT e FROM adresse e WHERE nrue = 12));

												SELECT * FROM eleveur ORDER BY Licence;

UPDATE eleveur e
	SET elevage=(SELECT el FROM elevage el WHERE animal = 'volaille') WHERE (e.adresse).ville = 'Angers';
												SELECT * FROM eleveur ORDER BY Licence;
												
CREATE FUNCTION fVolaille() RETURNS TRIGGER AS $$
BEGIN
	IF (NEW.adresse).ville = 'Angers'
		THEN NEW.elevage =(SELECT e FROM elevage e WHERE animal = 'volaille');
	END IF;
	RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER angevinsVolaille BEFORE INSERT ON eleveur 
FOR EACH ROW EXECUTE PROCEDURE fvolaille();

INSERT INTO eleveur VALUES
(5, (SELECT e FROM elevage e WHERE animal = 'bovins'), (SELECT e FROM adresse e WHERE nrue = 3));













