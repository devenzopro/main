# 🖥️ Scripts Bash – par dev-enzo

Bienvenue dans le répertoire principal `bash/`, qui regroupe mes scripts Bash organisés par environnement ou cas d’usage.  
Chaque sous-dossier correspond à un domaine spécifique : installation système, gestion de serveur, automatisation, etc.

Tous les scripts sont testés manuellement et documentés.

---

## 📁 Sous-dossiers

| Dossier                  | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `proxmox-scripts/`       | Scripts pour la gestion, l’audit et l'automatisation de Proxmox VE         |
| `debian-installations/`  | Scripts d’installation, de configuration et de sécurisation pour Debian     |
| `ubuntu-installations/`  | Scripts similaires adaptés aux environnements Ubuntu (Server et Desktop)    |

---

## 🧩 Exemples de scripts inclus

### 🔧 Proxmox
- `sync-ad-admin.sh` : Synchronise les groupes AD vers Proxmox
- `backup-vm-daily.sh` : Sauvegarde automatique des VMs
- `report-vm-status.sh` : Rapport quotidien de l’état des VMs

### 🐧 Debian
- `debian-postinstall.sh` : Configuration de base après installation
- `configure-ssh-secure.sh` : Sécurisation automatique du service SSH

### 🪟 Ubuntu
- `ubuntu-postinstall.sh` : Setup initial complet pour Ubuntu
- `install-flatpak-software.sh` : Installation automatisée de logiciels via Flatpak

---

## 🔐 Bonnes pratiques

- Les scripts sensibles utilisent un fichier `config.sh` pour les paramètres.
- Les mots de passe sont **externalisés** dans des fichiers protégés (`/root/.ldap_pass`, etc.).
- Chaque script est versionné et daté.

---

## ✅ Utilisation

```bash
cd bash/debian-installations/
chmod +x debian-postinstall.sh
./debian-postinstall.sh
