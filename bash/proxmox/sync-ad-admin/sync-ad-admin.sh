#!/bin/bash
# =============================================================================
# Auteur   : Dev-Enzo
# Date     : 15-07-2025
# Contact  : support@dev-enzo.ovh
# Projet   : Synchronisation AD -> Proxmox
# Description :
#   Script Bash pour synchroniser les utilisateurs d'un groupe Active Directory
#   vers un groupe local Proxmox.
# =============================================================================

# === CONFIGURATION ===
# Charger la config
source ./config_sync-ad-admin.sh

# === SYNCHRONISATION ===

echo "[INFO] Lancement de la synchronisation des admins AD..."

# Recherche des utilisateurs membres directs ou indirects du groupe AD
members=$(ldapsearch -LLL -H ldap://$AD_SERVER -D "$BIND_DN" -w "$BIND_PW" \
  -b "DC=internet,DC=ch" \
  "(&(objectClass=user)(memberOf:1.2.840.113556.1.4.1941:=$GROUP_DN))" \
  sAMAccountName | grep '^sAMAccountName:' | awk '{print $2}' | sort -u)

# Ajout de chaque utilisateur dans le groupe local Proxmox
for user in $members; do
  echo "[+] Ajout de $user@$REALM dans le groupe $PROXMOX_GROUP"
  pveum user modify "$user@$REALM" -group $PROXMOX_GROUP
done

echo "[INFO] Synchronisation terminée."
