DROP FUNCTION IF EXISTS stat_Form();
DROP FUNCTION IF EXISTS MoyFormat(f varchar(30));
DROP FUNCTION IF EXISTS MoyNote();
DROP TABLE IF EXISTS StatResultat;
DROP TABLE IF EXISTS TabNote;
DROP TABLE IF EXISTS Matiere;
DROP TABLE IF EXISTS Formation CASCADE;
DROP TABLE IF EXISTS Enseignant;
DROP TABLE IF EXISTS Etudiant;

CREATE TABLE Etudiant (
	NumEt int PRIMARY KEY NOT NULL,
	Nom varchar(30),
	Prenom varchar(30)
); \d Etudiant;

CREATE TABLE Enseignant (
	NumEns int PRIMARY KEY NOT NULL,
	NomEns varchar(30),
	PrenomEns varchar(30)
); \d Enseignant;

CREATE TABLE Formation (
	NomForm varchar(30) PRIMARY KEY NOT NULL,
	NbEtud int,
	EnsResp int REFERENCES Enseignant (NumEns)
); \d Formation;

CREATE TABLE Matiere (
	NomMat varchar(30) UNIQUE,
	NomForm varchar(30) REFERENCES Formation (NomForm),
	NumEns int,
	Coef int,
	PRIMARY KEY (NomMat, Nomform)
); \d Matiere;

CREATE TABLE TabNote (
	NumEt int REFERENCES Etudiant (NumEt),
	NomMat varchar(30) REFERENCES Matiere (NomMat),
	NomForm varchar(30) REFERENCES Formation (NomForm),
	Note float
); \d TabNote;

CREATE TABLE StatResultat (
	NomForm varchar(30) REFERENCES Formation (NomForm),
	MoyG float,
	NbRecu int,
	NbEtPres int,
	NoteMax float,
	NoteMin float
); \d StatResultat;

INSERT INTO Etudiant VALUES 
	(100, 'JEAN', 'Jean'),
	(101, 'NEAJ', 'Jacques'),
	(102, 'NAJE', 'Luc'),
	(103, 'JENA', 'Philippe');
SELECT * FROM Etudiant;

INSERT INTO Enseignant VALUES 
	(200, 'ESCEVT',		'Pierre'),
	(201, 'KANT',		'Paul'),
	(202, 'DREYFUS',	'Marc'),
	(203, 'NASM',		'Matthieu'),
	(204, 'CEPEPE',		'David'),
	(205, 'KING',		'Martin'),
	(206, 'ZERATOR',	'Adrien'),
	(207, 'AQUIN',		'Thomas');
SELECT * FROM Enseignant;

INSERT INTO Formation VALUES 
	('Informatique', 150, 203),
	('Histoire',	 300, 202),
	('SVG', 		 245, 200),
	('Philosophie',  600, 201);
SELECT * FROM Formation;

INSERT INTO Matiere VALUES
	('DevWeb',					'Informatique', 203, 2),
	('C++',						'Informatique', 204, 5),
	('Renaissance',				'Histoire',		202, 8),
	('L empire carolingien',	'Histoire',		205, 6),
	('Les plaques tecto', 		'SVG',			200, 4),
	('Le biome', 				'SVG', 			206, 7),
	('Descartes', 				'Philosophie',	201, 4),
	('Ens de Platon', 			'Philosophie',	207, 3);
SELECT * FROM Matiere;

INSERT INTO TabNote VALUES
	(100, 'Renaissance',			'Histoire',		18.5),
	(100, 'L empire carolingien',	'Histoire',		12),
	(101, 'Les plaques tecto',		'SVG',			15),
	(101, 'Le biome',				'SVG',			16.3),
	(102, 'C++',					'Informatique', 11.4),
	(102, 'DevWeb',					'Informatique',	9.9),
	(103, 'Descartes',				'Philosophie',	4.6),
	(103, 'Ens de Platon',			'Philosophie',	15.4);
SELECT * FROM TabNote;

--2
CREATE FUNCTION MoyNote() 
	RETURNS FLOAT AS $$
DECLARE
	curs CURSOR 
		FOR SELECT t.Note, mat.Coef 
		FROM TabNote t NATURAL JOIN Matiere mat;
	total float;
	card int;
BEGIN
	total := 0;
	card := 0;
	FOR i IN curs
	LOOP
		total = total + i.Coef*i.Note;
		card = card + i.Coef;
	END LOOP;
	
		RETURN total/card;
END;
$$ LANGUAGE 'plpgsql';

SELECT MoyNote();

--3
SELECT e1.Nom, e1.Prenom, t1.Note FROM Etudiant e1 NATURAL JOIN TabNote t1	
	WHERE t1.Note =
	(SELECT max(t2.Note) FROM Etudiant e2 NATURAL JOIN TabNote t2 WHERE e1.Nom = e2.Nom AND t2.Note > MoyNote());

--4
CREATE FUNCTION MoyFormat(f varchar(30))
	RETURNS FLOAT AS $$
DECLARE
	curs CURSOR 
		FOR SELECT t.Note, mat.Coef 
		FROM TabNote t NATURAL JOIN Matiere mat WHERE mat.NomForm = f;
	total float;
	card int;
BEGIN
	total := 0;
	card := 0;
	FOR i IN curs
	LOOP
		total = total + i.Coef*i.Note;
		card = card + i.Coef;
	END LOOP;
	
		RETURN total/card;
END;
$$ LANGUAGE 'plpgsql';

SELECT MoyFormat('Philosophie');

--5
CREATE FUNCTION stat_Form() RETURNS FLOAT AS $$
DECLARE
	curs CURSOR 
		FOR SELECT f.NomForm, t.Note
		FROM Formation f, TabNote t;
BEGIN
	FOR i IN curs
	LOOP
		INSERT INTO StatResultat VALUES (f.NomForm, MoyFormat(f.NomForm), null, null, null, null);
		
	END LOOP;
END;
$$ LANGUAGE 'plpgsql';


SELECT stat_Form();

SELECT * FROM StatResultat;

--6
/*
CREATE FUNCTION InfoEt (et int)
	RETURNS FLOAT AS $$
DECLARE
	SELECT e.NumEt, mat.NomForm, mat.NomMat
		FROM Etudiant e NATURAL JOIN Matiere mat WHERE e.NumEt = et;
	*/	


































