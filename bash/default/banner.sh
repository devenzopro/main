#!/bin/bash

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then 
  echo "S'il te plaît, lance ce script avec sudo."
  exit
fi

# --- Définition du contenu de la bannière ---
BANNER_PATH="/etc/ssh/banner_devenzo"
ISSUE_PATH="/etc/issue"

cat << "EOF" > $BANNER_PATH
################################################
#                                              #
#    ____             _____                    #
#   |  _ \  _____   _| ____|_ __  _______      #
#   | | | |/ _ \ \ / /  _| | '_ \|_  / _ \     #"
#   | |_| |  __/\ V /| |___| | | |/ / (_) |    #
#   |____/ \___| \_/ |_____|_| |_/___\___/     #
#                                              #
################################################
            BIENVENUE, DEV-ENZO                 
------------------------------------------------
 Ce systeme est prive et strictement surveille.
 Toute tentative d'acces non autorisee sera    
 enregistree et poursuivie.                    
------------------------------------------------
EOF

# Copier la bannière pour l'accès local (avant login TTY)
cp $BANNER_PATH $ISSUE_PATH

# --- Configuration de SSH ---
echo "Configuration du fichier sshd_config..."

# Vérifie si la ligne Banner existe déjà et la modifie, sinon l'ajoute
if grep -q "^#Banner" /etc/ssh/sshd_config; then
    sed -i "s|^#Banner.*|Banner $BANNER_PATH|" /etc/ssh/sshd_config
elif grep -q "^Banner" /etc/ssh/sshd_config; then
    sed -i "s|^Banner.*|Banner $BANNER_PATH|" /etc/ssh/sshd_config
else
    echo "Banner $BANNER_PATH" >> /etc/ssh/sshd_config
fi

# --- Redémarrage du service SSH ---
echo "Redémarrage de SSH pour appliquer les changements..."
systemctl restart ssh

echo "------------------------------------------------"
echo "  Configuration terminée avec succès !          "
echo "  Ta bannière Dev-Enzo est maintenant active.   "
echo "------------------------------------------------"
