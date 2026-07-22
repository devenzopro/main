#!/bin/bash
# DISK MONITORING - Dev-Enzo

DISQUE_ARG="$1"

# 1. Vérification qu'un argument a bien été transmis
if [ -z "$DISQUE_ARG" ]; then
    echo "Erreur : Aucun disque spécifié en argument !"
    exit 1
fi

# 2. Vérification que le disque/périphérique existe toujours sur le système
if [ ! -b "$DISQUE_ARG" ]; then
    echo "Erreur : Le disque $DISQUE_ARG n'est plus présent ou non détecté !"
    exit 1
fi

# 3. Extraction du nom simple (ex: sda) et définition des chemins
NOM_DISQUE=$(basename "$DISQUE_ARG")
DOSSIER_DATA="/etc/disk/data"
PATH_FICHIER="${DOSSIER_DATA}/${NOM_DISQUE}.txt"

# 4. Vérification de l'existence du fichier de suivi
if [ ! -f "$PATH_FICHIER" ]; then
    echo "Erreur : Le fichier $PATH_FICHIER n'existe pas. Lance d'abord get-disk.sh !"
    exit 1
fi

# 5. Récupération de la date du jour et de l'espace LIBRE (disponible)
DATE_JOUR=$(date +"%d/%m/%Y")

# Récupération de l'espace disponible (ex: 120G). Si non monté, on bascule sur la taille globale du disque
ESPACE_LIBRE=$(df -h "$DISQUE_ARG" 2>/dev/null | awk 'NR==2 {print $4}')

if [ -z "$ESPACE_LIBRE" ]; then
    # Fallback si la partition/disque n'est pas directement montée avec un système de fichier
    ESPACE_LIBRE=$(lsblk -d -n -o SIZE "$DISQUE_ARG" | tr -d ' ')
fi

# 6. Ajout de la nouvelle ligne du jour à la fin du fichier
NOUVELLE_LIGNE="${DATE_JOUR},${NOM_DISQUE},${ESPACE_LIBRE}"
echo "$NOUVELLE_LIGNE" >> "$PATH_FICHIER"

# 7. Suppression de la première ligne (pour conserver exactement 30 lignes / 30 jours)
# sed -i '1d' supprime la première ligne directement dans le fichier
sed -i '1d' "$PATH_FICHIER"

echo "Mise à jour effectuée pour $NOM_DISQUE : $NOUVELLE_LIGNE"
