# Créé le 01/11/2025 par Léa Fargeot
import pandas as pd
import os
from pathlib import Path

#-----------------------------------------------------------------#
#    FONCTIONS
#-----------------------------------------------------------------#
def generate_insert_sql(df, table_name, filename):
    columns = ', '.join(df.columns)
    with open(filename, 'w', encoding='utf-8') as f:
        for _, row in df.iterrows():
            values = []
            for val in row:
                if pd.isna(val):
                    values.append('NULL')
                elif isinstance(val, str):
                    val_escaped = val.replace("'", "''")
                    values.append(f"'{val_escaped}'")
                else:
                    values.append(str(val))
            values_str = ', '.join(values)
            sql = f"INSERT INTO {table_name} ({columns}) VALUES ({values_str});\n"
            f.write(sql)

#-----------------------------------------------------------------#
#    PROGRAMME PRINCIPAL
#-----------------------------------------------------------------#
"""
Placer le scrip creation_insert.py dans le même répertoire que les dossiers
- Jeux_de_donnees
- Insertions_sql
Le premier contient les jeux de données à transformer pour l'insertion SQL
Le second accueillera les fichiers .sql créés à l'issue de l'exécution du script

/!\ Le script considère que le nom du fichier est le nom de la table dans laquelle se fait l'insertion
Cela permet l'exécution du script sur plusieurs fichiers, sans autre action de la part de l'utilisateur
"""

# Récupération des dossiers
dossier_entree = Path("Jeux_de_donnees")
dossier_sortie = Path("Insertions_sql")

# Création du dossier de sortie s'il n'existe pas déjà
dossier_sortie.mkdir(exist_ok=True)

# Parcourt de tous les fichiers CSV du dossier d'entrée
for fichier_csv in dossier_entree.glob("*.csv"):
    try:
        df = pd.read_csv(fichier_csv, encoding='utf-8', sep=None, engine='python')
        nom_table = fichier_csv.stem # Récupère le nom du fichier sans son extension
        fichier_sortie = dossier_sortie / f"{nom_table}_inserts.sql"
        generate_insert_sql(df, nom_table, fichier_sortie)
        print(f"Le fichier {fichier_sortie} a été généré avec succès !")
        
    except Exception as e:
        print(f"Une erreur est survenue lors de la création du fichier {fichier_csv}: {e}")
