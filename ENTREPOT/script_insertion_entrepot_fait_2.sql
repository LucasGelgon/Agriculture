-- INSERTION DES DONNÉES DEPUIS LA TABLE TEMPORAIRE dataset_fait_2

INSERT INTO region (code_region, nom_region)
SELECT code_region, region
FROM dataset_fait_2
GROUP BY code_region, region
;

INSERT INTO Departement (code_departement, nom_departement, code_region, id_zone_climatique)
SELECT f2.code_departement, f2.departement, f2.code_region, z.id_zone_climatique
FROM dataset_fait_2 f2, zone_climatique z
WHERE z.nom_zone = f2.zone_climatique
GROUP BY f2.code_departement, f2.departement, f2.code_region, z.id_zone_climatique
;

INSERT INTO mesure_surfaces_agricoles_bio (annee, code_departement, nb_nouveaux_exploitants, surface_conversion, surface_abandonnee)
SELECT annee, code_departement, nb_nouveaux_exploitants, surface_conversion, surface_abandonnee
FROM dataset_fait_2
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
