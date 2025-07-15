#!/bin/bash

# === CONFIGURATION ===
AD_SERVER=""                    # Nom ou IP de ton contrôleur AD
BIND_DN=""               # Compte autorisé à lire l’AD (compte@domaine.local)
BIND_PW=$(cat /root/.ldap_pass)                         # Mot de passe du compte 
GROUP_DN=""  # DN complet du groupe
REALM=""                          # Nom du realm configuré dans Proxmox
PROXMOX_GROUP=""                    # Groupe local Proxmox cible

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
