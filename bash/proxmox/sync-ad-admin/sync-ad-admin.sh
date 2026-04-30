#!/bin/bash
# =============================================================================
# Auteur    : Dev-Enzo
# Description : Synchronisation Multi-Groupes AD -> Proxmox
# =============================================================================

echo "*******************************"
echo "*          DEV-ENZO           *"
echo "*******************************"

CONFIG_FILE="/root/sync-ad-admin/config.sh"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "[ERROR] Fichier de configuration manquant : $CONFIG_FILE"
  exit 1
fi

source "$CONFIG_FILE"

if [[ ! -r "$BIND_PW_FILE" ]]; then
  echo "[ERROR] Fichier de mot de passe non accessible : $BIND_PW_FILE"
  exit 1
fi

BIND_PW=$(<"$BIND_PW_FILE")

echo "[INFO] Lancement de la synchronisation multi-groupes..."

# On boucle sur chaque DN de groupe (la clé du tableau)
for GROUP_DN in "${!GROUP_MAPPING[@]}"; do
  PROXMOX_GROUP=${GROUP_MAPPING[$GROUP_DN]}
  
  echo "--- Groupe AD : $GROUP_DN ---> Proxmox : $PROXMOX_GROUP ---"

  # Recherche des utilisateurs (récursif avec l'OID 1.2.840.113556.1.4.1941)
  members=$(ldapsearch -LLL -H ldap://$AD_SERVER -D "$BIND_DN" -w "$BIND_PW" \
    -b "DC=internet,DC=ch" \
    "(&(objectClass=user)(memberOf:1.2.840.113556.1.4.1941:=$GROUP_DN))" \
    sAMAccountName | grep '^sAMAccountName:' | awk '{print $2}' | sort -u)

  if [[ -z "$members" ]]; then
    echo "[WARN] Aucun membre trouvé pour le groupe $PROXMOX_GROUP"
    continue
  fi

  for user in $members; do
    echo "[+] Ajout de $user@$REALM dans $PROXMOX_GROUP"
    /usr/sbin/pveum user modify "$user@$REALM" -group "$PROXMOX_GROUP"
  done
done

echo "[INFO] Synchronisation terminée."
