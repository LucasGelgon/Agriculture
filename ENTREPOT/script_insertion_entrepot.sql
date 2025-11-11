-- Les tables des dimensions periode, zone_climatique et dataset_fait_2 (qui est temporaire) sont remplies grâce à des INSERT
-- générés à l'aide du programme python "script_creation_entrepot.sql"

-- INSERTION DES DONNÉES DEPUIS LA TABLE TEMPORAIRE dataset_fait_1

-- Table de la dimension : groupe_culture
INSERT INTO Groupe_culture (nom_groupe_culture)
SELECT DISTINCT groupe_culture
FROM dataset_fait_1
ORDER BY groupe_culture
;

-- Table de la dimension : culture
INSERT INTO Culture (id_culture, nom_culture, id_groupe_culture)
SELECT ID_culture, culture, id_groupe_culture
FROM dataset_fait_1 df, Groupe_culture g
WHERE df.groupe_culture = g.nom_groupe_culture
GROUP BY ID_culture, culture, id_groupe_culture
;

-- Table du Fait n°1 : mesure_surfaces_agricoles_bio
INSERT INTO mesure_performances_agronomiques_culture (	id_culture,
														annee,
														code_departement,
														production,
														surface_bio,
														surface_conventionnelle,
														surface_totale,
														rendement)
SELECT ID_culture, annee, code_departement, production, surfbio, surface_conventionelle, surface_totale, rendement
FROM dataset_fait_1


-- INSERTION DES DONNÉES DEPUIS LA TABLE TEMPORAIRE dataset_fait_2

-- Table de la dimension : region
INSERT INTO region (code_region, nom_region)
SELECT code_region, region
FROM dataset_fait_2
GROUP BY code_region, region
;

-- Table de la dimension : departement
INSERT INTO Departement (code_departement, nom_departement, code_region, id_zone_climatique)
SELECT f2.code_departement, f2.departement, f2.code_region, z.id_zone_climatique
FROM dataset_fait_2 f2, zone_climatique z
WHERE z.nom_zone = f2.zone_climatique
GROUP BY f2.code_departement, f2.departement, f2.code_region, z.id_zone_climatique
;

-- Table du Fait n°2 : mesure_surfaces_agricoles_bio
INSERT INTO mesure_surfaces_agricoles_bio (annee, code_departement, nb_nouveaux_exploitants, surface_conversion, surface_abandonnee)
SELECT annee, code_departement, nb_nouveaux_exploitants, surface_conversion, surface_abandonnee
FROM dataset_fait_2
;

-- INSERTION DES DONNÉES DEPUIS LA TABLE TEMPORAIRE dataset_fait_3
-- Table du Fait n°3 : mesure_surfaces_agricoles_bio
INSERT INTO mesure_evenement_climatique (annee, code_departement, type_alerte, nb_alertes)
SELECT annee, code_departement, type_alerte, nb_alertes
FROM dataset_fait_3
;

-- TESTS AVEC LES REQUÊTES RÉPONDANT AUX BESOIN DU FAIT N°2

SELECT annee, SUM(nb_nouveaux_exploitants) AS Nombre_nouvelles_exploitations
FROM mesure_surfaces_agricoles_bio
GROUP BY annee
ORDER BY annee;

SELECT m.annee, d.nom_departement, SUM(m.surface_conversion) AS surface_conversion
FROM mesure_surfaces_agricoles_bio m, departement d
WHERE m.code_departement = d.code_departement
AND m.annee = 2024
GROUP BY m.annee, d.code_departement
ORDER BY surface_conversion DESC
LIMIT 5;

SELECT m.annee, r.nom_region, SUM(m.surface_conversion) AS surface_conversion
FROM mesure_surfaces_agricoles_bio m, departement d, region r
WHERE m.code_departement = d.code_departement
AND d.code_region = r.code_region
AND m.annee = 2024
GROUP BY m.annee, r.code_region
ORDER BY surface_conversion DESC
LIMIT 5;

SELECT m.annee, d.nom_departement, SUM(m.surface_abandonnee) AS surface_abandonnee
FROM mesure_surfaces_agricoles_bio m, departement d
WHERE m.code_departement = d.code_departement
GROUP BY m.annee, d.code_departement
ORDER BY m.annee, d.code_departement;

SELECT d.nom_departement, SUM(m.surface_abandonnee) AS surface_abandonnee
FROM mesure_surfaces_agricoles_bio m, departement d
WHERE m.code_departement = d.code_departement
GROUP BY d.code_departement
ORDER BY surface_abandonnee ASC -- On utilise l'ordre croissant car les surfaces sont négatives : les plus grandes surfaces, sont donc les plus petites valeurs
LIMIT 5;

-- TESTS AVEC LES REQUÊTES RÉPONDANT AUX BESOIN DU FAIT N°3
