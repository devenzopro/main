# 🔄 Script de synchronisation des administrateurs AD vers un groupe Proxmox

Ce script Bash permet de **synchroniser automatiquement les membres d’un groupe Active Directory** (y compris les membres indirects via les groupes imbriqués) vers un **groupe local dans Proxmox VE**.

Il est conçu pour automatiser la gestion des droits d’accès utilisateurs dans Proxmox à partir d’un annuaire LDAP (comme Active Directory).

---

## ⚙️ Fonctionnement

1. Connexion LDAP sécurisée au contrôleur de domaine AD.
2. Recherche des membres du groupe AD, y compris les groupes imbriqués.
3. Ajout automatique des comptes utilisateurs dans un groupe local Proxmox via `pveum`.

---

## 🗂️ Organisation du projet

```bash
sync-ad-admin/
├── sync-ad-admin.sh    # Script principal
├── config.sh    # Fichier de configuration
└── README.md           # Documentation
```
---
## 📜 Exemple d’exécution
```
[INFO] Lancement de la synchronisation...
[+] Ajout de adm_tech@ad-internet dans le groupe GG_ADMIN-PVE_CRV-AD-INTERNET
[INFO] Synchronisation terminée.
```
---
## ✅ Prérequis

Proxmox avec l’outil pveum accessible
Le realm AD doit déjà être configuré dans Proxmox
Paquet ldap-utils installé (apt install ldap-utils)
Un compte AD ayant les droits de lecture LDAP

```
apt update
apt install ldap-utils -y
```

---
## 🧠 Astuce

crontab-generator.org : vous n'avez qu'à sélectionner vos besoins pour la fréquence d'exécution et l'outil va générer la bonne ligne de crontab.

crontab.guru : vous pouvez indiquer votre ligne de crontab (sans la commande) et l'outil va la traduire sous forme de texte. C'est très pratique pour vérifier la syntaxe de la tâche cron.

Ce script peut être planifié avec cron pour une mise à jour régulière :

```0 * * * * /root/sync-ad-admin/sync-ad-admin.sh >> /var/log/sync-ad.log 2>&1```

✅ Signification détaillée (cron)

```
*    *    *    *    * /root/sync-ad-admin/sync-ad-admin.sh >> /var/log/sync-ad.log 2>&1
│    │    │    │    │
│    │    │    │    └──── Jour de la semaine (0-6 → dimanche à samedi)
│    │    │    └──────── Mois (1-12)
│    │    └──────────── Jour du mois (1-31)
│    └───────────────── Heure (0-23)
└────────────────────── Minute (0-59)
```
🕑 Cette ligne :

```0 * * * * /root/sync-ad-admin/sync-ad-admin.sh >> /var/log/sync-ad.log 2>&1```

Signifie : à la minute 0 de chaque heure
Donc : toutes les heures, à xx:00 (00:00, 01:00, 02:00… 23:00)

🔁 Résumé des cas fréquents
```
Expression                cron	Signification

0 * * * *	                Toutes les heures à xx:00
*/5 * * * *             	Toutes les 5 minutes
0 1 * * *	                Tous les jours à 01:00
0 1 * * 1	                Tous les lundis à 01:00
0 1 */2 * *             	Tous les 2 jours à 01:00
```
Pour information : 

Proxmox Active Direcory Server : User Filter ```(memberOf:1.2.840.113556.1.4.1941:=CN=GG_ADMIN-PVE_CBG*,OU=TIER1,OU=GROUPES,OU=Comptes de delegation,DC=domaine,DC=fr)``` pausibilé d'en maitre a la suite
Proxmox Active Direcory Server : User Filter ```(&(objectClass=group)(cn=GG_ADMIN-PVE*))```

