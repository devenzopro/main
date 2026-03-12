#!/bin/bash

# --- Vérification des droits root ---
if [ "$EUID" -ne 0 ]; then 
  echo "S'il te plaît, lance ce script avec sudo."
  exit
fi

# --- Couleurs ---
JAUNE='\033[1;33m'; VERT='\033[1;32m'; BLEU='\033[1;34m'; ROUGE='\033[1;31m'; NC='\033[0m'

# Installation si manquant
apt update && apt install ufw -y

# Reset et blocage par défaut
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Questions pour les autres services
ask_port() {
    read -p "Autoriser $1 ($2) ? (y/N) : " res
    if [[ "$res" =~ ^[yY]$ ]]; then
        ufw allow "$1"
        echo -e "${VERT}Port $1 autorisé.${NC}"
    else
        echo -e "${ROUGE}Port $1 refusé.${NC}"
    fi
}

ask_port "22" "SSH"
ask_port "80" "HTTP - Web"
ask_port "443" "HTTPS - Web Sécurisé"
ask_port "53" "DNS"

# Activation du pare-feu
ufw --force enable
echo -e "${VERT}Pare-feu UFW activé !${NC}"

# --- Message de fin corrigé ---
echo -e "${BLEU}------------------------------------------------${NC}"
echo -e "${VERT}  Configuration terminée avec succès !          ${NC}"
echo -e "${VERT}                UFW OK.                         ${NC}"
echo -e "${BLEU}------------------------------------------------${NC}"
