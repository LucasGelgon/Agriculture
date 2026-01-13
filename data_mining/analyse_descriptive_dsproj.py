import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import warnings
warnings.filterwarnings('ignore')

# Configuration
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# Charger les données
df = pd.read_csv("U:/MesDocs/S8/DS project/fusion1.csv", encoding='latin-1')

# Features d'intérêt
features = ['nb_nouveaux_exploitants', 'surface_conversion', 'evolution_surf_bio',
            'nb_alertes_sécheresse', 'nb_alertes_gel', 'nb_alertes_inondation']

df_features = df[features].copy()

# ==================== STATISTIQUES DESCRIPTIVES ====================
print("="*80)
print("ANALYSE DESCRIPTIVE")
print("="*80)

# Statistiques de base
print("\n1. STATISTIQUES DESCRIPTIVES:")
print(df_features.describe())

# Forme des distributions
print("\n2. FORME DES DISTRIBUTIONS:")
for col in features:
    skew = df_features[col].skew()
    kurt = df_features[col].kurtosis()
    print(f"{col}: Skewness={skew:.3f}, Kurtosis={kurt:.3f}")

# Matrice de corrélation
print("\n3. MATRICE DE CORRÉLATION:")
corr_matrix = df_features.corr()
print(corr_matrix.round(3))

# Outliers
print("\n4. OUTLIERS (méthode IQR):")
for col in features:
    Q1 = df_features[col].quantile(0.25)
    Q3 = df_features[col].quantile(0.75)
    IQR = Q3 - Q1
    outliers = ((df_features[col] < Q1 - 1.5*IQR) | 
                (df_features[col] > Q3 + 1.5*IQR)).sum()
    print(f"{col}: {outliers} outliers ({outliers/len(df_features)*100:.2f}%)")

# ==================== HISTOGRAMMES ====================
fig, axes = plt.subplots(3, 2, figsize=(15, 12))
fig.suptitle('Distributions des Variables - Histogrammes', fontsize=16, fontweight='bold')
axes = axes.ravel()
colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8', '#F7DC6F']

for idx, (col, color) in enumerate(zip(features, colors)):
    ax = axes[idx]
    df_features[col].hist(bins=30, ax=ax, color=color, alpha=0.7, 
                          edgecolor='black', density=True)
    df_features[col].plot(kind='kde', ax=ax, color='darkblue', linewidth=2)
    
    mean_val = df_features[col].mean()
    median_val = df_features[col].median()
    ax.axvline(mean_val, color='red', linestyle='--', linewidth=2, 
               label=f'Moyenne: {mean_val:.1f}')
    ax.axvline(median_val, color='green', linestyle='--', linewidth=2, 
               label=f'Médiane: {median_val:.1f}')
    
    ax.set_title(col, fontsize=11, fontweight='bold')
    ax.set_xlabel('Valeur')
    ax.set_ylabel('Densité')
    ax.legend(fontsize=8)
    ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('histogrammes_distributions.png', dpi=300, bbox_inches='tight')

# ==================== BOXPLOTS ====================
fig, axes = plt.subplots(3, 2, figsize=(15, 12))
fig.suptitle('Distributions des Variables - Boxplots', fontsize=16, fontweight='bold')
axes = axes.ravel()

for idx, (col, color) in enumerate(zip(features, colors)):
    ax = axes[idx]
    ax.boxplot([df_features[col].dropna()], vert=True, patch_artist=True,
               widths=0.5, showmeans=True,
               boxprops=dict(facecolor=color, alpha=0.7))
    ax.set_title(col, fontsize=11, fontweight='bold')
    ax.set_ylabel('Valeur')
    ax.grid(True, alpha=0.3, axis='y')

plt.tight_layout()
plt.savefig('boxplots_distributions.png', dpi=300, bbox_inches='tight')

# ==================== HEATMAP CORRÉLATION ====================
fig, ax = plt.subplots(figsize=(10, 8))
sns.heatmap(corr_matrix, annot=True, fmt='.3f', cmap='coolwarm', 
            center=0, square=True, linewidths=1, vmin=-1, vmax=1, ax=ax)
ax.set_title('Matrice de Corrélation', fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig('heatmap_correlation.png', dpi=300, bbox_inches='tight')

# Sauvegarder les statistiques
df_features.describe().to_csv('statistiques_descriptives_completes.csv', 
                              encoding='utf-8-sig')
corr_matrix.to_csv('matrice_correlation.csv', encoding='utf-8-sig')
