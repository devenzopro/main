# === CONFIGURATION GÉNÉRALE ===
AD_SERVER="192.168.1.10"
BIND_DN="CN=LDAP_User,OU=ServiceAccounts,DC=internet,DC=ch"
BIND_PW_FILE="/root/sync-ad-admin/.pw_ad"
REALM="pam" # ou ad, selon ta config Proxmox

# === MAPPING DES GROUPES ===
# Syntaxe : ["GROUPE_AD_DN"]="GROUPE_PROXMOX"
declare -A GROUP_MAPPING
GROUP_MAPPING=(
  ["CN=Admins_IT,OU=Groups,DC=internet,DC=ch"]="admin"
  ["CN=Dev_Team,OU=Groups,DC=internet,DC=ch"]="developpeurs"
  ["CN=Support,OU=Groups,DC=internet,DC=ch"]="support_tech"
)
