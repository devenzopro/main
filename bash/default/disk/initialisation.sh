#!/bin/bash
# DISK - Dev-Enzo

echo "=== Sélection du disque ==="
echo ""

# 1. Récupérer uniquement les noms des disques physiques (ex: sda sdb nvme0n1)
mapfile -t DISQUES < <(lsblk -d -n -o NAME,TYPE | awk '$2=="disk" {print $1}')

# Vérifier si au moins un disque est présent
if [ ${#DISQUES[@]} -eq 0 ]; then
    echo "Aucun disque détecté !"
    exit 1
fi

# 2. Demander à l'utilisateur de choisir dans la liste
echo "Veuillez choisir un disque :"
select CHOIX in "${DISQUES[@]}"; do
    if [ -n "$CHOIX" ]; then
        DISQUE_SELECTIONNE="/dev/$CHOIX"
        break
    else
        echo "Option invalide, réessaie."
    fi
done

echo ""
echo "Disque sélectionné : $DISQUE_SELECTIONNE"

# ---------------
# GESTION CRONTAB
# ---------------

# 1. Fréquence : Tous les jours à 07h00 du matin
CRON_SCHEDULE="0 7 * * *"

# 2. Commande exacte à exécuter
CRON_CMD="/etc/disk/disk.sh $DISQUE_SELECTIONNE"
CRON_JOB="$CRON_SCHEDULE $CRON_CMD"

# 3. Vérification pour éviter les doublons dans la crontab
if crontab -l 2>/dev/null | grep -Fq "$CRON_CMD"; then
    echo "Info : La tâche cron pour $DISQUE_SELECTIONNE existe déjà."
else
    echo "Ajout de la tâche dans la crontab (tous les jours à 07h00)..."
    
    # Ajout propre à la crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    
    echo "Tâche ajoutée avec succès !"
fi

# ---------------
# CREATION FICHIER DATA
# ---------------

# 1. Récupération des informations du disque
NOM_DISQUE=$(basename "$DISQUE_SELECTIONNE")
TAILLE_DISQUE=$(lsblk -d -n -o SIZE "$DISQUE_SELECTIONNE" | tr -d ' ')

# 2. Utilisation d'un chemin ABSOLU et création du dossier data
DOSSIER_DATA="/etc/disk/data"
mkdir -p "$DOSSIER_DATA"

PATH_FICHIER="${DOSSIER_DATA}/${NOM_DISQUE}.txt"

# 3. Création du fichier avec les 30 lignes par défaut
if [ ! -f "$PATH_FICHIER" ]; then
    echo "Création du fichier de suivi : $PATH_FICHIER"
    
    for i in {1..30}; do
        echo "0/0/0000,${NOM_DISQUE},${TAILLE_DISQUE}" >> "$PATH_FICHIER"
    done
    
    echo "30 lignes par défaut ajoutées dans $PATH_FICHIER !"
else
    echo "Le fichier $PATH_FICHIER existe déjà."
fi

# ---------------
# PREMIERE EXECUTION
# ---------------

echo ""
echo "Lancement de l'exécution initiale..."
/etc/disk/disk.sh "$DISQUE_SELECTIONNE"
