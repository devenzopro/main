# ⚡️ Scripts PowerShell – par dev-enzo

Ce répertoire contient plusieurs sous-dossiers organisés par thème, regroupant des scripts PowerShell dédiés à l’administration de systèmes Windows.  
Chaque sous-dossier est documenté individuellement et contient des scripts testés, versionnés et prêts à l’emploi.

---

## 📁 Arborescence des sous-dossiers

| Dossier                        | Description                                                                 |
|-------------------------------|-----------------------------------------------------------------------------|
| `windows-installation/`       | Scripts d'installation et de post-installation Windows                     |
| `active-directory/`           | Scripts de gestion AD : utilisateurs, groupes, OU, sécurité                 |
| `secops/`                     | Scripts liés à la sécurité, audit, pare-feu, BitLocker, journaux, etc.     |
| `automation/`                 | Tâches automatisées : nettoyage, optimisation, maintenance                  |
| `inventory-reporting/`        | Génération de rapports matériels, logiciels ou d’état des machines         |

---

## 🧩 Exemples de scripts contenus

### 🖥️ `windows-installation/`
- `postinstall-windows.ps1` : Post-install automatique avec MAJ, apps, BitLocker, etc.
- `install-essential-tools.ps1` : Installe les outils indispensables sur poste client

### 🛡️ `secops/`
- `configure-firewall.ps1` : Active et configure le pare-feu Windows avec des règles personnalisées
- `enable-bitlocker.ps1` : Active BitLocker, exporte la clé de récupération et configure le chiffrement

### 🏢 `active-directory/`
- `bulk-create-users.ps1` : Crée des utilisateurs en masse depuis un fichier CSV
- `audit-user-logons.ps1` : Analyse des connexions et activités utilisateurs

---

## 🔐 Bonnes pratiques

- Les scripts sensibles utilisent un fichier `config.ps1` externe pour les paramètres.
- Les mots de passe et secrets sont chargés depuis des fichiers chiffrés ou le Windows Credential Manager.

---

## 🧪 Tests & Compatibilité

- 🪟 Windows 10 / 11 / Server 2016+ (compatibilité indiquée dans le dossier)
- 📦 Modules nécessaires installés automatiquement si manquants

---

## 🧰 Utilisation

```powershell
cd powershell/windows-installation
.\postinstall-windows.ps1
