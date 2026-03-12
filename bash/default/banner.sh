#!/bin/bash

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then 
  echo "S'il te plaît, lance ce script avec sudo."
  exit
fi

# --- Variables de chemins ---
BANNER_PATH="/etc/ssh/banner_devenzo"
ISSUE_PATH="/etc/issue"
MOTD_PATH="/etc/motd"

echo "Installation de la sécurité Dev-Enzo..."

# --- 1. CRÉATION DE LA BANNIÈRE AVANT CONNEXION ---
cat << "EOF" > $BANNER_PATH
################################################
#                                              #
#    ____             _____                    #
#   |  _ \  _____   _| ____|_ __  _______      #
#   | | | |/ _ \ \ / /  _| | '_ \|_  / _ \     #
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

# Application pour le login local
cp $BANNER_PATH $ISSUE_PATH

# --- 2. CONFIGURATION DU DASHBOARD APRÈS CONNEXION ---
# On vide le MOTD par défaut pour éviter les doublons
echo "" > $MOTD_PATH

# On ajoute le Dashboard dans le .bashrc pour qu'il s'affiche à chaque login
# On utilise une fonction pour que les couleurs et commandes soient propres
# Le contenu du dashboard
DASHBOARD_CONTENT=$(cat << 'EOF'

# --- DASHBOARD DEV-ENZO ---
JAUNE='\033[1;33m'; VERT='\033[1;32m'; BLEU='\033[1;34m'; ROUGE='\033[1;31m'; NC='\033[0m'
echo -e "${BLEU}================================================${NC}"
echo -e "${JAUNE}[ ÉTAT DU SYSTÈME - DEV-ENZO ]${NC}"
echo -e "${BLEU}================================================${NC}"
echo -e "Utilisateur : ${VERT}$(whoami)${NC} @ ${VERT}$(hostname)${NC}"
echo -e "Uptime      : $(uptime -p)"
echo -e "Processeur  : $(lscpu | grep -E 'Model name|Nom de modèle' | cut -d: -f2 | sed 's/^[ \t]*//')"
echo -e "Mémoire RAM : ${JAUNE}$(free -h | awk '/Mem:/ {print $3 "/" $2}') utilisé${NC}"
echo -e "Disque Dur  : ${ROUGE}$(df -h / | awk '/\// {print $5 " de " $2}') utilisé${NC}"
echo -e "IP Locale   : $(hostname -I | awk '{print $1}')"
echo -e "IP Publique : $(curl -s https://ifconfig.me || echo 'Hors ligne')"
echo -e "${BLEU}================================================${NC}"
EOF
)

# 1. Appliquer aux futurs utilisateurs (le dossier /etc/skel)
# Tout ce qui est ici est copié automatiquement dans le home des nouveaux comptes.
echo "$DASHBOARD_CONTENT" >> /etc/skel/.bashrc
echo "[*] Configuré pour les futurs utilisateurs (/etc/skel)"

# 2. Appliquer à l'utilisateur root
echo "$DASHBOARD_CONTENT" >> /root/.bashrc
echo "[*] Configuré pour l'utilisateur root"

# 3. Appliquer aux utilisateurs existants (dans /home)
for user_home in /home/*; do
    # Vérifie que c'est bien un répertoire et pas un fichier
    if [ -d "$user_home" ]; then
        user_name=$(basename "$user_home")
        user_bashrc="$user_home/.bashrc"

        # Vérifie si le fichier .bashrc existe avant d'écrire
        if [ -f "$user_bashrc" ]; then
            # On vérifie si le dashboard est déjà présent
            if ! grep -q "DASHBOARD DEV-ENZO" "$user_bashrc"; then
                echo -e "\n$DASHBOARD_CONTENT" >> "$user_bashrc"
                
                # Correction cruciale : Réattribuer la propriété à l'utilisateur
                # On utilise l'ID de l'utilisateur pour éviter les erreurs de groupe
                chown "$user_name":"$user_name" "$user_bashrc" 2>/dev/null || chown "$user_name" "$user_bashrc"
                
                echo "[OK] Dashboard ajouté pour : $user_name"
            else
                echo "[SKIP] Déjà présent pour : $user_name"
            fi
        fi
    fi
done


# --- 3. CONFIGURATION SSH ---
echo "Configuration du service SSH..."
if grep -q "^#Banner" /etc/ssh/sshd_config; then
    sed -i "s|^#Banner.*|Banner $BANNER_PATH|" /etc/ssh/sshd_config
elif grep -q "^Banner" /etc/ssh/sshd_config; then
    sed -i "s|^Banner.*|Banner $BANNER_PATH|" /etc/ssh/sshd_config
else
    echo "Banner $BANNER_PATH" >> /etc/ssh/sshd_config
fi

# Redémarrage de SSH
systemctl restart ssh

echo "------------------------------------------------"
echo "  Configuration terminée avec succès !          "
echo "  Bannière (Avant) et Dashboard (Après) OK.     "
echo "------------------------------------------------"
