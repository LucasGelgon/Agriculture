import pandas as pd
import os
from pathlib import Path

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

# Chemins des dossiers
dossier_entree = Path("Jeux_de_donnees")
dossier_sortie = Path("Insertions_sql")

# Créer le dossier de sortie s'il n'existe pas
dossier_sortie.mkdir(exist_ok=True)

# On parcourt tous les fichiers CSV du dossier Jeux_de_donnees
for fichier_csv in dossier_entree.glob("*.csv"):
    try:
        df = pd.read_csv(fichier_csv, encoding='utf-8', sep=None, engine='python')
        table_name = fichier_csv.stem
        fichier_sortie = dossier_sortie / f"{table_name}_inserts.sql"
        generate_insert_sql(df, table_name, fichier_sortie)
        print(f"Le fichier {fichier_sortie} a été généré avec succès !")
        
    except Exception as e:
        print(f"Une erreur est survenue lors de la création du fichier {fichier_csv}: {e}")
