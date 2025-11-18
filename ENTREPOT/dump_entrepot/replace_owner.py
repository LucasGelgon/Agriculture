def remplacer_owner(scrip_sql, fichier_sortie, ancien_owner, new_owner):
    with open(script_sql,'r') as script:
        contenu = script.read()
    
    contenu_modifie = contenu.replace(f"OWNER TO {ancien_owner}", f"OWNER TO {new_owner}"))
    
    with open(fichier_sortie, 'w') as new_script:
        new_script.write(contenu_modifie)
    
    print(f"Fichier {fichier_sortie} créé !")
    
    

ancien_owner = "postgres"  # Nom de l'ancien propriétaire
new_owner = "db_2222"  # Nom du nouveau propriétaire
# (De plus, le schéma par défaut est public)

fichier_entree = "entrepot_groupe_1.sql"  
fichier_sortie = f"entrepot_groupe_1_{new_owner}.sql"

remplacer_owner(fichier_entree, fichier_sortie, ancien_owner, new_owner)