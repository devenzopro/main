# 🐍 Scripts Python – par dev-enzo

Ce répertoire contient plusieurs sous-dossiers organisés par thème, regroupant des scripts Python utiles pour l’automatisation, l’analyse, les outils réseau, le traitement de données, et bien plus.

Chaque dossier contient des scripts prêts à l'emploi, bien structurés et documentés.

---

## 📁 Arborescence des sous-dossiers

| Dossier                  | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `automation/`            | Scripts d’automatisation de tâches systèmes ou fichiers                    |
| `data-processing/`       | Scripts de traitement, nettoyage et analyse de données (CSV, JSON, etc.)   |
| `network-tools/`         | Outils réseau : scan, ping, résolution DNS, vérification de ports, etc.     |
| `web-scripts/`           | Scripts de scraping, d'API REST ou de contrôle de services web             |
| `security/`              | Outils d’audit, vérifications de vulnérabilités, génération de hash, etc.   |

---

## 🧩 Exemples de scripts contenus

### ⚙️ `automation/`
- `file-renamer.py` : Renomme automatiquement des fichiers avec règles personnalisées
- `auto-folder-sorter.py` : Trie et organise automatiquement les fichiers dans un dossier

### 📊 `data-processing/`
- `csv-cleaner.py` : Nettoie les fichiers CSV (valeurs manquantes, types, doublons)
- `json-validator.py` : Valide des fichiers JSON et affiche les erreurs

### 🌐 `network-tools/`
- `port-scanner.py` : Scanne les ports ouverts d’un hôte
- `ping-multihost.py` : Envoie des pings sur plusieurs hôtes et affiche les réponses

### 🕸️ `web-scripts/`
- `url-monitor.py` : Vérifie la disponibilité de sites web en boucle
- `api-consumer.py` : Récupère et affiche des données via API REST

---

## 🧪 Dépendances

Certaines dépendances peuvent être requises selon les scripts (exemples : `requests`, `pandas`, `socket`…).  
Un fichier `requirements.txt` est fourni dans chaque sous-dossier s’il y a besoin d’un environnement virtuel.

```bash
pip install -r requirements.txt
