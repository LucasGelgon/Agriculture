import os
import requests
from tqdm import tqdm


"""
# Slug du dataset
DATASET_SLUG = "donnees-climatologiques-de-base-quotidiennes"
API_URL = f"https://www.data.gouv.fr/api/1/datasets/{DATASET_SLUG}/"
DEST_FOLDER = "donnees_climatologiques"

def download_file(url, dest_folder):
    os.makedirs(dest_folder, exist_ok=True)
    filename = os.path.basename(url.split("?")[0])
    dest_path = os.path.join(dest_folder, filename)
    
    if os.path.exists(dest_path):
        print(f"✅ {filename} déjà présent, saut du téléchargement.")
        return
    
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        total = int(r.headers.get('content-length', 0))
        with open(dest_path, "wb") as f, tqdm(
            total=total, unit='B', unit_scale=True, desc=filename
        ) as pbar:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
                pbar.update(len(chunk))
    print(f"✅ Téléchargé : {filename}")

def main():
    print("🔍 Récupération de la liste des fichiers depuis data.gouv.fr ...")
    response = requests.get(API_URL)
    response.raise_for_status()
    data = response.json()

    resources = data.get("resources", [])
    gz_files = [r for r in resources if r.get("url", "").endswith(".csv.gz")]
    print(f"📦 {len(gz_files)} fichiers .csv.gz trouvés.")

    for res in gz_files:
        url = res["url"]
        title = res.get("title", "Sans titre")
        print(f"\n⬇️ Téléchargement : {title}")
        try:
            download_file(url, DEST_FOLDER)
        except Exception as e:
            print(f"❌ Erreur sur {title} : {e}")

if __name__ == "__main__":
    main()

"""


import os
import re
import shutil

# Dossier où se trouvent les fichiers téléchargés
SOURCE_FOLDER = "C:\\Users\\simon\\Documents\\test python\\donnees_climatologiques"
DEST_BASE = "C:\\Users\\simon\\Documents\\test python\\donnees_climatologiques_nettoyees"


os.makedirs(os.path.join(DEST_BASE, "autres-parametres"), exist_ok=True)
os.makedirs(os.path.join(DEST_BASE, "RR-T-Vent"), exist_ok=True)

# Regex plus souple :
pattern = re.compile(
    r"^Q_(\d{1,3})_(?:previous-|latest-)?([0-9]{4}-[0-9]{4})_(RR-T-Vent|autres-parametres)\.csv\.gz$",
    re.IGNORECASE
)

# Départements métropolitains (01 à 95 inclus)
departements_metropole = [f"{i:02d}" for i in range(1, 96)]

copied = 0
skipped = 0

for filename in os.listdir(SOURCE_FOLDER):
    if not filename.lower().endswith(".csv.gz"):
        continue

    match = pattern.match(filename)
    if not match:
        print(f"⚠️ Nom non reconnu : {filename}")
        skipped += 1
        continue

    dep_raw, periode, type_fichier = match.groups()

    # Uniformiser le numéro de département sur 2 chiffres
    dep = dep_raw.zfill(2)

    if dep in departements_metropole and periode in ("1950-2023", "2024-2025"):
        src_path = os.path.join(SOURCE_FOLDER, filename)
        dest_folder = os.path.join(DEST_BASE, type_fichier)
        dest_path = os.path.join(dest_folder, filename)

        shutil.copy2(src_path, dest_path)
        copied += 1
        print(f"✅ Copié : {filename}")
    else:
        print(f"🗑️ Ignoré : {filename} (dep={dep}, période={periode})")
        skipped += 1

print(f"\n📦 {copied} fichiers copiés, {skipped} ignorés")
print(f"✅ Dossiers de sortie : {DEST_BASE}/autres-parametres et {DEST_BASE}/RR-T-Vent")
