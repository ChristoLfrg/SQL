DROP FUNCTION IF EXISTS fct();
DROP TABLE IF EXISTS PRODUIT2;
DROP TABLE IF EXISTS PRODUIT;

CREATE TABLE PRODUIT (
	NumProd int,
	Designation varchar(30),
	Prix float
);

CREATE TABLE PRODUIT2 (
	NumProd int,
	Designation varchar(30),
	Prix float
);

INSERT INTO PRODUIT (NumProd, Designation, Prix) VALUES
	(01, 'Console', 54),
	(02, 'DVD', 19),
	(03, 'Télévision', 1009),
	(04, 'Mario', 78),
	(05, 'Manette', 64),
	(06, 'Câble', null);

SELECT * FROM PRODUIT;

SELECT NumProd, UPPER(Designation) AS DesignationUP, Prix FROM PRODUIT;

CREATE FUNCTION fct() RETURNS void AS $$
DECLARE
	c CURSOR FOR SELECT NumProd, Designation, Prix FROM PRODUIT;
BEGIN
	IF (NOT EXISTS (SELECT * FROM PRODUIT)) THEN
		INSERT INTO PRODUIT2 (NumProd, Designation, Prix) VALUES
		(0, 'Pas de produit', NULL);
	ELSE FOR ligne IN c 
		LOOP
			IF (ligne.Prix IS null) THEN
				INSERT INTO PRODUIT2 (NumProd, Designation, Prix) VALUES
			     (ligne.NumProd, UPPER(ligne.Designation), 0);
			ELSE INSERT INTO PRODUIT2 (NumProd, Designation, Prix) VALUES
			     (ligne.NumProd, UPPER(ligne.Designation), ligne.Prix/6.55957);
			END IF;
		END LOOP;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

SELECT fct();

SELECT * FROM PRODUIT2;
