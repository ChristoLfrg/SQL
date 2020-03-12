DROP FUNCTION IF EXISTS MoyNote();

DROP TABLE IF EXISTS StatResultat;
DROP TABLE IF EXISTS TabNote;

DROP TABLE IF EXISTS Matiere CASCADE;
DROP TABLE IF EXISTS Formation CASCADE;
DROP TABLE IF EXISTS Enseignant CASCADE;
DROP TABLE IF EXISTS Etudiant CASCADE;


DROP TYPE IF EXISTS t_Matiere CASCADE;
DROP TYPE IF EXISTS t_Formation CASCADE;
DROP TYPE IF EXISTS t_Enseignant CASCADE;
DROP TYPE IF EXISTS t_Etudiant CASCADE;

CREATE TYPE t_Etudiant AS (
	NumEt int,
	Nom varchar(30),
	Prenom varchar(30)
); 

CREATE TABLE Etudiant of t_Etudiant; \d Etudiant;

CREATE TYPE t_Enseignant AS (
	NumEns int,
	NomEns varchar(30),
	PrenomEns varchar(30)
);

CREATE TABLE Enseignant of t_Enseignant; \d Enseignant;

CREATE TYPE t_Formation AS (
	NomForm varchar(30),
	NbEtud int,
	Enseignant t_Enseignant
);

CREATE TABLE Formation OF t_Formation; \d Formation;

CREATE TYPE t_Matiere AS (
	NomMat varchar(30),
	Formation t_Formation,
	NumEns int,
	Coef int
);

CREATE TABLE Matiere OF t_Matiere; \d Matiere;

CREATE TABLE TabNote (
	Etudiant t_Etudiant,
	Matiere t_Matiere,
	Note float
); \d TabNote;

CREATE TABLE StatResultat (
	Formation t_Formation,
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
	('Informatique', 150, (SELECT e FROM Enseignant e WHERE e.NumEns=203)),
	('Histoire',	 300, (SELECT e FROM Enseignant e WHERE e.NumEns=202)),
	('SVG', 		 245, (SELECT e FROM Enseignant e WHERE e.NumEns=200)),
	('Philosophie',  600, (SELECT e FROM Enseignant e WHERE e.NumEns=201));
SELECT * FROM Formation;

INSERT INTO Matiere VALUES
	('DevWeb',					(SELECT f FROM Formation f WHERE f.NomForm='Informatique'), 203, 2),
	('C++',						(SELECT f FROM Formation f WHERE f.NomForm='Informatique'), 204, 5),
	('Renaissance',				(SELECT f FROM Formation f WHERE f.NomForm='Histoire'),		202, 8),
	('L empire carolingien',	(SELECT f FROM Formation f WHERE f.NomForm='Histoire'),		205, 6),
	('Les plaques tecto', 		(SELECT f FROM Formation f WHERE f.NomForm='SVG'),			200, 4),
	('Le biome', 				(SELECT f FROM Formation f WHERE f.NomForm='SVG'), 			206, 7),
	('Descartes', 				(SELECT f FROM Formation f WHERE f.NomForm='Philosophie'),	201, 4),
	('Ens de Platon', 			(SELECT f FROM Formation f WHERE f.NomForm='Philosophie'),	207, 3);
SELECT * FROM Matiere;

INSERT INTO TabNote VALUES
	((SELECT e FROM Etudiant e WHERE e.NumEt=100), (SELECT ma FROM Matiere ma WHERE ma.NomMat='Renaissance'),			18.5),
	((SELECT e FROM Etudiant e WHERE e.NumEt=100), (SELECT ma FROM Matiere ma WHERE ma.NomMat='L empire carolingien'),	12),
	((SELECT e FROM Etudiant e WHERE e.NumEt=101), (SELECT ma FROM Matiere ma WHERE ma.NomMat='Les plaques tecto'),		15),
	((SELECT e FROM Etudiant e WHERE e.NumEt=101), (SELECT ma FROM Matiere ma WHERE ma.NomMat='Le biome'),				16.3),
	((SELECT e FROM Etudiant e WHERE e.NumEt=102), (SELECT ma FROM Matiere ma WHERE ma.NomMat='C++'),					11.4),
	((SELECT e FROM Etudiant e WHERE e.NumEt=102), (SELECT ma FROM Matiere ma WHERE ma.NomMat='DevWeb'),				9.9),
	((SELECT e FROM Etudiant e WHERE e.NumEt=103), (SELECT ma FROM Matiere ma WHERE ma.NomMat='Descartes'),				4.6),
	((SELECT e FROM Etudiant e WHERE e.NumEt=103), (SELECT ma FROM Matiere ma WHERE ma.NomMat='Ens de Platon'),			15.4);
SELECT * FROM TabNote;

--2
CREATE FUNCTION MoyNote() 
	RETURNS FLOAT AS $$
DECLARE
	curs CURSOR 
		FOR SELECT t.Note
		FROM TabNote t;
	total float;
	card int;
BEGIN
	total := 0;
	card := 0;
	FOR i IN curs
	LOOP
		total = total + (i.Matiere).Coef*i.Note;
		card = card + (i.Matiere).Coef;
	END LOOP;
	
		RETURN total/card;
END;
$$ LANGUAGE 'plpgsql';

SELECT MoyNote();








































