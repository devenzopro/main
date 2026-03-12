#!/bin/bash

# --- Couleurs ---
JAUNE='\033[1;33m'; VERT='\033[1;32m'; BLEU='\033[1;34m'; ROUGE='\033[1;31m'; NC='\033[0m'

# --- Titre Principal ---
clear
echo -e "${BLEU}################################################${NC}"
echo -e "${BLEU}#                                              #${NC}"
echo -e "${BLEU}#       INSTALLATION SÉCURISÉE DEV-ENZO        #${NC}"
echo -e "${BLEU}#                                              #${NC}"
echo -e "${BLEU}################################################${NC}"
echo -e "${JAUNE}  Tu peux sauter des étapes en répondant 'n'.  ${NC}"
echo -e "${BLEU}------------------------------------------------${NC}"

# --- Fonction d'exécution à la demande ---
run_step() {
    local NOM_PARTIE=$1
    local URL_PARTIE=$2
    
    echo -e "\n${JAUNE}>>> PARTIE : ${NOM_PARTIE}${NC}"
    echo -e "${BLEU}Source : ${URL_PARTIE}${NC}"
    
    # On force la lecture du clavier avec </dev/tty pour le "y/n"
    read -p "Voulez-vous exécuter cette étape ? (y/n) : " choix </dev/tty
    
    if [[ "$choix" =~ ^[yY]$ ]]; then
        echo -e "${VERT}Exécution de ${NOM_PARTIE}...${NC}"
        curl -sSL "$URL_PARTIE" | sudo bash
        if command -v sudo >/dev/null 2>&1; then
            # Si sudo est installé
            sudo ufw status verbose
        else
            # Si sudo n'est pas installé (on est probablement déjà en root)
            ufw status verbose
        fi
    else
        echo -e "${ROUGE}Étape ${NOM_PARTIE} sautée.${NC}"
    fi
}

# --- ÉTAPE 1 : BANNIÈRE ---
run_step "BANNER & DASHBOARD" "https://raw.githubusercontent.com/devenzopro/main/scripts/bash/default/banner.sh"

# --- ÉTAPE 2 : PARE-FEU UFW ---
run_step "SÉCURITÉ PARE-FEU (UFW)" "https://raw.githubusercontent.com/devenzopro/main/scripts/bash/default/ufw.sh"

# --- Message de Fin ---
echo -e "\n${BLEU}------------------------------------------------${NC}"
echo -e "${VERT}      CONFIGURATION SÉCURISÉE TERMINÉE !        ${NC}"
echo -e "${VERT}             BRAVO DEV-ENZO.                    ${NC}"
echo -e "${BLEU}------------------------------------------------${NC}"
