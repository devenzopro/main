# curl -sSL https://raw.githubusercontent.com/devenzopro/main/scripts/bash/default/disk/installation.sh | sudo bash

echo "Installation disk démarage !"
echo " "
echo "[DISK]} Creation des dossier!"
mkdir -p /etc/disk && cd /etc/disk || { echo "Erreur de création ou d'accès au dossier (MAIN) !"; exit 1}
mkdir -p /etc/disk/data || { echo "Erreur de création ou d'accès au dossier (DATA)!"; exit 1}
echo "[DISK]} Creation des dossier Términer."
# 1. télécharger le fichier .sh depuis GitHub
echo " "
echo "[DISK]} Téléchargement des fichier sur github."
wget -q -O initialisation.sh https://raw.githubusercontent.com/devenzopro/main/scripts/bash/default/disk/initialisation.sh
wget -q -O disk.sh          https://raw.githubusercontent.com/devenzopro/main/scripts/bash/default/disk/disk.sh
wget -q -O get-disk.sh      https://raw.githubusercontent.com/devenzopro/main/scripts/bash/default/disk/get-disk.sh
echo "[DISK]} Téléchargement terminer "
# 2. donner les droits d'execution (+x)
echo " "
echo "[DISK]} Definition en cour des droit des script."
chmod +x *.sh
echo "[DISK]} Definition en cour des droit des script Términer."
# 3. Terminer
echo " "
echo "Installation disk terminer !"
