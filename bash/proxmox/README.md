# ⚙️ Scripts pour Proxmox VE – par dev-enzo

Ce dépôt contient divers scripts Bash utilisés pour automatiser ou simplifier la gestion de Proxmox VE dans des environnements intégrés à Active Directory ou dans des contextes d’administration système avancée.

Chaque script est documenté et versionné.

---

## 📁 Liste des scripts disponibles

| Nom du script                       | Version  | Création        | Dernière modif.  | Description                                                                  |
|-------------------------------------|----------|-----------------|------------------|------------------------------------------------------------------------------|
| `sync-ad-admin.sh`                  | 1.0      | 15-07-2025      | 15-07-2025       | Synchronise les membres d’un groupe AD vers un groupe Proxmox local          |
| `-`                | 1.0      | 2024-06-02      | 2024-06-02       | Effectue un snapshot ou un backup quotidien des VMs définies                 |
| `-`               | 1.0      | 2024-05-15      | 2025-03-21       | Génère un rapport des VMs (état, ressources) envoyé par mail                 |

## 📦 Organisation du dépôt
> 🔒 Certains scripts utilisent des fichiers de configuration séparés pour isoler les paramètres sensibles comme les identifiants LDAP ou les chemins critiques.
