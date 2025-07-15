# 🔄 Script de synchronisation des administrateurs AD vers un groupe Proxmox

Ce script Bash permet de **synchroniser automatiquement les membres d’un groupe Active Directory** (y compris les membres indirects via les groupes imbriqués) vers un **groupe local dans Proxmox VE**.

Il est particulièrement utile pour automatiser la gestion des droits d’accès dans Proxmox à partir de ton annuaire Active Directory.

---

## ⚙️ Fonctionnement

1. Connexion LDAP sécurisée au contrôleur de domaine AD.
2. Recherche des utilisateurs (membres directs et indirects) du groupe AD cible.
3. Pour chaque utilisateur trouvé, ajout au groupe local Proxmox spécifié.

---

## 🗂️ Paramètres à configurer dans le script

```bash
AD_SERVER=""         # Adresse IP ou nom DNS du serveur AD
BIND_DN=""           # Identifiant LDAP (ex : admin@domaine.local)
BIND_PW=$(cat /root/.ldap_pass)  # Mot de passe du compte LDAP, stocké dans un fichier sécurisé
GROUP_DN=""          # DN complet du groupe AD source (ex : CN=GG_ADMIN-PVE,OU=Groupes,...)
REALM=""             # Nom du realm dans Proxmox (ex : ad-internet)
PROXMOX_GROUP=""     # Nom du groupe local Proxmox (ex : GG_ADMIN-PVE_CRV-AD-INTERNET)
