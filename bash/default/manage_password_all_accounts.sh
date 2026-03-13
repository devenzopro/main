#!/bin/bash

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then 
  echo "S'il te plaît, lance ce script avec sudo."
  exit
fi

# Fonction pour générer et appliquer un mot de passe
change_password() {
    local user=$1
    local description=$2

    echo -e "\n------------------------------------------"
    echo "Action : $description ($user)"
    
    # Vérification si l'utilisateur existe
    if id "$user" &>/dev/null; then
        # Génération du mot de passe (16 caractères)
        local new_pass=$(openssl rand -base64 12)
        
        # Application via chpasswd (nécessite sudo)
        echo "$user:$new_pass" | sudo chpasswd
        
        if [ $? -eq 0 ]; then
            echo "✅ SUCCÈS : Le mot de passe de '$user' a été mis à jour."
            echo "🔑 NOUVEAU MOT DE PASSE : $new_pass"
        else
            echo "❌ ERREUR : Impossible de modifier le mot de passe de $user."
        fi
    else
        echo "⚠️ ERREUR : L'utilisateur '$user' n'existe pas."
    fi
    echo "------------------------------------------"
}

# --- DEBUT DU SCRIPT ---
echo "=== DASHBOARD DEV-ENZO : GESTION DES COMPTES ==="

# 1. Traitement prioritaire du compte ROOT
read -p "Voulez-vous régénérer le mot de passe du compte ROOT ? (o/n) : " confirm_root
if [[ "$confirm_root" =~ ^[oO](ui)?$ ]]; then
    change_password "root" "Changer de compte root"
fi

# 2. Boucle pour les autres comptes
while true; do
    read -p "Y a-t-il un autre compte à gérer ? (o/n) : " encore
    
    if [[ "$encore" =~ ^[oO](ui)?$ ]]; then
        read -p "Nom de l'utilisateur : " username
        read -p "Voulez-vous vraiment régénérer son mot de passe ? (o/n) : " confirm_user
        
        if [[ "$confirm_user" =~ ^[oO](ui)?$ ]]; then
            change_password "$username" "Régénération manuelle"
        else
            echo "Opération annulée pour $username."
        fi
    else
        echo "------------------------------------------------"
        echo "  Configuration terminée avec succès !          "
        echo "  Gestion Password compte local.     "
        echo "------------------------------------------------"
        break
    fi
done
