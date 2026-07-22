#!/bin/bash
# GET-DISK - Consultation de l'historique Dev-Enzo

DOSSIER_DATA="/etc/disk/data"

echo "=== Historique de l'espace disque ==="
echo ""

# 1. Vérification si le dossier data existe et contient des fichiers .txt
if [ ! -d "$DOSSIER_DATA" ] || [ -z "$(ls -A "$DOSSIER_DATA/*.txt" 2>/dev/null)" ]; then
    echo "Aucun fichier de suivi trouvé dans $DOSSIER_DATA."
    echo "Exécute d'abord l'initialisation d'un disque !"
    exit 1
fi

# 2. Récupérer la liste des disques ayant un fichier .txt
FICHIERS=("$DOSSIER_DATA"/*.txt)
LISTE_DISQUES=()

for f in "${FICHIERS[@]}"; do
    # Extraire juste le nom sans le chemin ni l'extension (ex: /etc/disk/data/sda.txt -> sda)
    NOM=$(basename "$f" .txt)
    LISTE_DISQUES+=("$NOM")
done

# 3. Demander à l'utilisateur de choisir un disque
echo "Sélectionne le disque dont tu veux voir l'historique :"
select DISQUE in "${LISTE_DISQUES[@]}"; do
    if [ -n "$DISQUE" ]; then
        FICHIER_CIBLE="${DOSSIER_DATA}/${DISQUE}.txt"
        break
    else
        echo "Option invalide, réessaie."
    fi
done

echo ""
echo "=== Historique pour /dev/$DISQUE ==="
printf "%-12s | %-10s | %-15s\n" "Date" "Disque" "Espace Libre"
echo "-----------------------------------------"

# 4. Lecture du fichier ligne par ligne (1 à 30)
COMPTEUR=0
while IFS=',' read -r DATE_RELEVE NOM_D TAILLE_D; do
    # On ignore les lignes sans valeur ou qui ont la date par défaut 0/0/0000
    if [ -z "$DATE_RELEVE" ] || [ "$DATE_RELEVE" == "0/0/0000" ]; then
        continue
    fi

    # Affichage propre sous forme de tableau aligné
    printf "%-12s | %-10s | %-15s\n" "$DATE_RELEVE" "$NOM_D" "$TAILLE_D"
    ((COMPTEUR++))

done < "$FICHIER_CIBLE"

# Message si aucun historique réel n'a encore été enregistré
if [ $COMPTEUR -eq 0 ]; then
    echo "Aucun relevé disponible pour le moment (toutes les dates sont à 0/0/0000)."
fi

echo "-----------------------------------------"
