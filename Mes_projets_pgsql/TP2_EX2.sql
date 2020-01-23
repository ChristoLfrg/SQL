DROP FUNCTION IF EXISTS fct();
DROP TABLE IF EXISTS VOL;
DROP TABLE IF EXISTS PILOTE;
DROP TABLE IF EXISTS AVION;

CREATE TABLE AVION (
	AvNum int,
	AvNom varchar(30),
	Capacite int,
	Localisation varchar(30)
);

CREATE TABLE PILOTE (
	PilNum int,
	PilNom varchar(30),
	PilPrenom varchar(30),
	Ville varchar(30),
	Salaire int
);

CREATE TABLE VOL (
	VolNum int,
	PilNum int,
	AvNum int,
	VilleDep varchar(30),
	VilleArr varchar(30),
	HeureDep time,
	HeureArr time
);

INSERT INTO AVION (AvNum, AvNom, Capacite, Localisation) VALUES
	(1,'Chêne',500,'Troyes'),
	(2,'Hêtre', 1200,'Lyon'),
	(3,'Bouleau',750,'Angers'),
	(4,'Chataîgnier',150,'Poitiers');

INSERT INTO PILOTE (PilNum, PilNom, PilPrenom, Ville, Salaire) VALUES
	(101, 'SEGUIN', 'Antoine', 'Angers', 2200),
	(102, 'FRESCH', 'Ma-Ch', 'Angers', 3000),
	(103, 'GUS', 'Jean', 'Poitiers', 1200),
	(104, 'YALAHI', 'Mowgli', 'Seeonee', 1500);
	
INSERT INTO VOL (VolNum, PilNum, AvNum, VilleDep, VilleArr, HeureDep, HeureArr) VALUES
	(201, 101, 3, 'Dubai', 'Détroit', 15:35, 18:50),
	(202, 104, 2, 'Shanghai', 'Hong-Kong', 07:33, 18:30),
	(203, 102, 4, 'Beijing', 'Sydney', 10:45, 16:15),
	(204, 103, 1, 'New-York', 'Londres', 11:35, 22:28);

SELECT * FROM PILOTE;
SELECT * FROM VOL;

