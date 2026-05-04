# 🔄 Script de synchronisation des administrateurs AD vers un groupe Proxmox
Ce script Bash automatise la synchronisation des membres d'un groupe Active Directory (incluant la récursion via les groupes imbriqués) vers un groupe local Proxmox VE.Il permet de centraliser la gestion de vos droits d'accès Proxmox directement depuis votre annuaire LDAP/AD.

---

## ⚙️ FonctionnementLe script suit un flux logique en trois étapes :
1. **Connexion LDAP** : Authentification sécurisée auprès du contrôleur de domaine (DC).
2. **Extraction récursive** : Identification de tous les membres du groupe AD (incluant les sous-groupes).
3. **Provisionnement PVE** : Injection des utilisateurs dans le groupe Proxmox cible via l'outil pveum.

--- 

🗂️ Organisation du projetPlaintextsync-ad-admin/
```
├── sync-ad-admin.sh    # Script logique principal
├── config.sh           # Variables (Serveur, IDs, Groupes)
└── README.md           # Documentation
```

## ✅ Prérequis

Avant de planifier le script, assurez-vous que :
- Le **Realm AD** est déjà configuré dans Proxmox (Datacenter > Permissions > Realms).
- L'utilitaire ldap-utils est présent sur l'hôte.
- Un compte de service AD possède les droits de lecture LDAP.
- 
Installation des dépendances :
```
Bashapt update && apt install ldap-utils -y
```

## 📅 Planification (Crontab)
Pour une automatisation totale,utilisez la ```crontab```. Il est recommandé d'écraser le log à chaque passage pour ne garder que l'état de la dernière synchronisation.Configuration recommandée (Toutes les 5 min) Éditez votre crontab avec crontab -e et ajoutez :

```
*/5 * * * * /root/sync-ad-admin/sync-ad-admin.sh > /var/log/sync-ad.log 2>&1
```

**Détails de la commande :**

- ```>``` Écrase le log précédent (évite la saturation disque).
- ```2>&1``` : Capture les erreurs (stderr) dans le même fichier.

**Aide à la syntaxe Croncrontab.guru :**

Pour vérifier vos expressions. : [crontab.guru](https:\\crontab.guru)

Pour générer vos lignes facilement. : [crontab-generator.org](https:\\crontab-generator.org)

```
*/5 * * * *Toutes les 5 minutes (Recommandé)0 * * * *Toutes les heures0 1 * * *Tous les jours à 01:00 du matin
```

Les 3 lignes pour ta Crontab :
```
# 1ère exécution : à :00, :15, :30, :45
0/15 * * * * /root/sync-ad-admin/sync-ad-admin.sh > /var/log/sync-ad.log 2>&1

# 2ème exécution : à :05, :20, :35, :50
5/15 * * * * /root/sync-ad-admin/sync-ad-admin.sh > /var/log/sync-ad.log 2>&1

# 3ème exécution : à :10, :25, :40, :55
10/15 * * * * /root/sync-ad-admin/sync-ad-admin.sh > /var/log/sync-ad.log 2>&1
```

## 📜 Exemple de sortie (Log)

```
Plaintext[2026-05-04 16:30:01] [INFO] Lancement de la synchronisation...
[+] Ajout de adm_tech@ad-internet dans le groupe GG_ADMIN-PVE_CRV-AD-INTERNET
[INFO] Synchronisation terminée avec succès.
```

## 🔍 Annexes : Filtres LDAP Proxmox
Pour optimiser la visibilité des objets dans l'interface Proxmox, vous pouvez utiliser ces filtres dans la configuration du **Realm AD** :

**Filtre utilisateur (avec récursion LDAP_MATCHING_RULE_IN_CHAIN) :**

Permet de ne lister que les membres d'un groupe spécifique et de ses sous-groupes.

```(memberOf:1.2.840.113556.1.4.1941:=CN=GG_ADMIN-PVE_CBG*,OU=TIER1,OU=GROUPES,OU=Comptes de delegation,DC=domaine,DC=fr)```


**Filtre de groupe :**

Limite l'importation aux groupes dont le nom commence par une nomenclature précise.

```(&(objectClass=group)(cn=GG_ADMIN-PVE*))```

---

**Note** : Veillez à bien tester votre fichier config.sh manuellement avant d'activer la tâche Cron.rd (stdout), donc les erreurs seront aussi écrites dans ton fichier de log unique.

Pour information : 

Proxmox Active Direcory Server : User Filter ```(memberOf:1.2.840.113556.1.4.1941:=CN=GG_ADMIN-PVE_CBG*,OU=TIER1,OU=GROUPES,OU=Comptes de delegation,DC=domaine,DC=fr)``` pausibilé d'en maitre a la suite
Proxmox Active Direcory Server : User Filter ```(&(objectClass=group)(cn=GG_ADMIN-PVE*))```

