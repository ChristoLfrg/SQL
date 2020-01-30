DROP FUNCTION IF EXISTS MoyFormat();
DROP FUNCTION IF EXISTS MoyNote();
DROP TABLE IF EXISTS StatResultat;
DROP TABLE IF EXISTS TabNote;
DROP TABLE IF EXISTS Matiere;
DROP TABLE IF EXISTS Formation;
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
	(102, 'Descartes',				'Philosophie',	4.6),
	(102, 'Ens de Platon',			'Philosophie',	15.4);
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
SELECT Nom, Prenom, Note FROM Etudiant NATURAL JOIN TabNote	
	WHERE Note > MoyNote();

--4 A FAIRE
CREATE FUNCTION MoyFormat(Formation) 
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























