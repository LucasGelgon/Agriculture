-- TESTS AVEC LES REQUÊTES RÉPONDANT AUX BESOINS DU FAIT N°1

SELECT
	m.annee,
	g.nom_groupe_culture,
	SUM(m.surface_totale) AS Surface_totale
FROM
	Mesure_performances_agronomiques_culture m,
	Culture c,
	Groupe_culture g
WHERE
	m.id_culture = c.id_culture
	AND c.id_groupe_culture = g.id_groupe_culture
GROUP BY
	m.annee,
	g.nom_groupe_culture
ORDER BY
	g.nom_groupe_culture,
	m.annee
;

SELECT
	m.annee,
	g.nom_groupe_culture,
	AVG(production) AS production_moyenne
FROM
	mesure_performances_agronomiques_culture m,
	groupe_culture g,
	culture c 
WHERE
	m.id_culture = c.id_culture
	AND c.id_groupe_culture = g.id_groupe_culture
GROUP BY
	m.annee,
	g.nom_groupe_culture
ORDER BY
	g.nom_groupe_culture,
	m.annee
;

SELECT
	g.nom_groupe_culture,
	p.tranche_annees,
	SUM(m.production) AS production_totale,
	SUM(m.surface_totale) AS surface_totale,
	ROUND((SUM(m.production) / NULLIF(SUM(m.surface_totale), 0)), 3) AS rendement
FROM
	mesure_performances_agronomiques_culture m,
	culture c,
	groupe_culture g,
	periode p
WHERE
	m.id_culture = c.id_culture
	AND c.id_groupe_culture = g.id_groupe_culture
	AND m.annee = p.annee
	AND p.tranche_annees = '2020-2024'
GROUP BY
	g.nom_groupe_culture,
	p.tranche_annees
ORDER BY
	g.nom_groupe_culture
;

SELECT
	annee,
	SUM(surface_bio) AS surface_bio
FROM
	mesure_performances_agronomiques_culture
GROUP BY
	annee
ORDER BY
	annee
;


-- TESTS AVEC LES REQUÊTES RÉPONDANT AUX BESOINS DU FAIT N°2

SELECT
	annee,
	SUM(nb_nouveaux_exploitants) AS Nombre_nouvelles_exploitations
FROM
	mesure_surfaces_agricoles_bio
GROUP BY
	annee
ORDER BY
	annee
;

SELECT
	m.annee,
	d.nom_departement,
	SUM(m.surface_conversion) AS surface_conversion
FROM
	mesure_surfaces_agricoles_bio m,
	departement d
WHERE
	m.code_departement = d.code_departement
	AND m.annee = 2024
GROUP BY
	m.annee,
	d.code_departement
ORDER BY
	surface_conversion DESC
LIMIT 5
;

SELECT
	m.annee,
	r.nom_region,
	SUM(m.surface_conversion) AS surface_conversion
FROM
	mesure_surfaces_agricoles_bio m,
	departement d,
	region r
WHERE
	m.code_departement = d.code_departement
	AND d.code_region = r.code_region
	AND m.annee = 2024
GROUP BY
	m.annee,
	r.code_region
ORDER BY
	surface_conversion DESC
LIMIT 5
;

SELECT
	m.annee,
	d.nom_departement,
	SUM(m.surface_abandonnee) AS surface_abandonnee
FROM
	mesure_surfaces_agricoles_bio m,
	departement d
WHERE
	m.code_departement = d.code_departement
GROUP BY
	m.annee,
	d.code_departement
ORDER BY
	m.annee,
	d.code_departement
;

SELECT
	d.nom_departement,
	SUM(m.surface_abandonnee) AS surface_abandonnee
FROM
	mesure_surfaces_agricoles_bio m,
	departement d
WHERE
	m.code_departement = d.code_departement
GROUP BY
	d.code_departement
ORDER BY
	surface_abandonnee ASC
	-- On utilise l'ordre croissant car les surfaces sont négatives : les plus grandes surfaces, sont donc les plus petites valeurs
LIMIT 5
;


-- TESTS AVEC LES REQUÊTES RÉPONDANT AUX BESOINS DU FAIT N°3

SELECT
	annee,
	type_alerte,
	SUM(nb_alertes) AS nb_alertes_total
FROM
	mesure_evenement_climatique
WHERE
	type_alerte = 'Sécheresse'
GROUP BY
	annee,
	type_alerte
ORDER BY
	annee
;

SELECT
	annee,
	type_alerte,
	SUM(nb_alertes) AS nb_alertes_total
FROM
	mesure_evenement_climatique
WHERE
	type_alerte = 'Gel'
GROUP BY
	annee,
	type_alerte
ORDER BY
	annee
;

SELECT
	d.nom_departement,
	m.type_alerte,
	SUM(m.nb_alertes) AS nb_alertes_total
FROM
	mesure_evenement_climatique m,
	departement d
WHERE
	m.code_departement = d.code_departement
	AND m.type_alerte = 'Gel'
GROUP BY
	d.code_departement,
	m.type_alerte
ORDER BY
	d.code_departement
;

SELECT
	d.nom_departement,
	m.type_alerte,
	SUM(m.nb_alertes) AS nb_alertes_total
FROM
	mesure_evenement_climatique m,
	departement d
WHERE
	m.code_departement = d.code_departement
	AND m.type_alerte = 'Inondation'
GROUP BY
	d.code_departement,
	m.type_alerte
ORDER BY
	d.code_departement
;