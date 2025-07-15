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
echo "*******************************"
echo "*          DEV-ENZO           *"
echo "*******************************"

# === CONFIGURATION ===

echo "==== SYNC-AD-ADMIN PROXMOX : $(date) ===="

CONFIG_FILE="./config.sh"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "[ERROR] Fichier de configuration manquant : $CONFIG_FILE"
  exit 1
fi
source "$CONFIG_FILE"

# Vérifier que le fichier de mot de passe existe et est lisible
if [[ ! -r "$BIND_PW_FILE" ]]; then
  echo "[ERROR] Fichier de mot de passe non accessible : $BIND_PW_FILE"
  exit 1
fi

BIND_PW=$(<"$BIND_PW_FILE")  # Lecture sécurisée, sans fork cat

# === SYNCHRONISATION ===

echo "[INFO] Lancement de la synchronisation..."

# Recherche des utilisateurs membres directs ou indirects du groupe AD
members=$(ldapsearch -LLL -H ldap://$AD_SERVER -D "$BIND_DN" -w "$BIND_PW" \
  -b "DC=internet,DC=ch" \
  "(&(objectClass=user)(memberOf:1.2.840.113556.1.4.1941:=$GROUP_DN))" \
  sAMAccountName | grep '^sAMAccountName:' | awk '{print $2}' | sort -u)
  
# Ajout de chaque utilisateur dans le groupe local Proxmox
for user in $members; do
  echo "[+] Ajout de $user@$REALM dans le groupe $PROXMOX_GROUP"
  /usr/sbin/pveum user modify "$user@$REALM" -group $PROXMOX_GROUP
done

echo "[INFO] Synchronisation terminée."
