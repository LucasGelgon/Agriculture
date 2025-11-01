-- Créer et se connecter au préalable à une base de données nommée Agriculture

-- Création des tables annexes
CREATE TABLE Periode (
	annee INT PRIMARY KEY NOT NULL,
	tranche_annees VARCHAR(9)
);

CREATE TABLE Zone_climatique(
	id_zone_climatique SERIAL PRIMARY KEY,
	nom_zone VARCHAR(10) NOT NULL
);

CREATE TABLE Region (
	code_region VARCHAR(2) PRIMARY KEY NOT NULL,
	nom_region VARCHAR(50) NOT NULL
);

CREATE TABLE Departement (
	code_departement VARCHAR(2) PRIMARY KEY NOT NULL,
	nom_departement VARCHAR(50) NOT NULL,
	code_region VARCHAR(2),
	id_zone_climatique INT,
	FOREIGN KEY (code_region) REFERENCES Region(code_region),
	FOREIGN KEY (id_zone_climatique) REFERENCES Zone_climatique(id_zone_climatique)
);

CREATE TABLE Groupe_culture (
	id_groupe_culture INT PRIMARY KEY NOT NULL,
	nom_groupe_culture VARCHAR(50) NOT NULL	
);

CREATE TABLE Culture (
	id_culture INT PRIMARY KEY NOT NULL,
	nom_culture VARCHAR(50) NOT NULL,
	id_groupe_culture INT,
	FOREIGN KEY (id_groupe_culture) REFERENCES Groupe_culture(id_groupe_culture)
);

-- Création des tables de faits
CREATE TABLE Mesure_performances_agronomiques_culture (
	id_culture INT NOT NULL,
	annee INT NOT NULL,
	code_departement VARCHAR(2) NOT NULL,
	production NUMERIC(15,3),
	surface_bio NUMERIC(15,3),
	surface_conventionnelle NUMERIC(15,3),
	surface_totale NUMERIC(15,3),
	rendement NUMERIC(8,3),
	PRIMARY KEY (id_culture, annee, code_departement),
	FOREIGN KEY (id_culture) REFERENCES Culture(id_culture),
	FOREIGN KEY (annee) REFERENCES Periode(annee),
	FOREIGN KEY (code_departement) REFERENCES Departement(code_departement)
);

CREATE TABLE Mesure_surfaces_agricoles_bio (
	annee INT NOT NULL,
	code_departement VARCHAR(2) NOT NULL,
	nb_nouveaux_exploitants INT,
	surface_conversion NUMERIC(15,3),
	surface_abandonnee NUMERIC(15,3),
	PRIMARY KEY (annee, code_departement),
	FOREIGN KEY (annee) REFERENCES Periode(annee),
	FOREIGN KEY (code_departement) REFERENCES Departement(code_departement)
);

CREATE TABLE Mesure_evenement_climatique (
	annee INT NOT NULL,
	code_departement VARCHAR(2) NOT NULL,
	type_alerte VARCHAR(15) NOT NULL,
	nb_alertes INT NOT NULL,
	PRIMARY KEY (annee, code_departement, type_alerte),
	FOREIGN KEY (annee) REFERENCES Periode(annee),
	FOREIGN KEY (code_departement) REFERENCES Departement(code_departement)
);
