#!/bin/bash

# 1. Vérification des droits root
if [ "$EUID" -ne 0 ]; then 
  echo "Erreur : Relance ce script avec sudo."
  exit 1
fi

echo "--- Déploiement du Système Rickroll (Version Fixée) ---"

# 2. Installation de curl si manquant
if ! command -v curl &> /dev/null; then
    echo "[*] Installation de curl..."
    apt-get update && apt-get install -y curl
fi

# 3. Création du script de punition blindé
PAYLOAD_PATH="/usr/local/bin/rickroll-fail.sh"
echo "[*] Création du payload dans $PAYLOAD_PATH"

cat << 'EOF' > "$PAYLOAD_PATH"
#!/bin/bash
# On force la sortie vers le terminal pour SSH et TTY
# Le "|| true" évite que le script plante si le terminal est fermé
exec > /dev/tty 2>&1 || exec > /dev/console 2>&1

clear
echo "MOT DE PASSE INCORRECT"
echo "Initialisation du protocole de sécurité..."
sleep 1

# Lance le Rickroll. Si curl échoue, le script ne doit pas crash.
# On met un timeout de connexion pour éviter de bloquer si pas d'internet.
timeout 5s curl -s -L --connect-timeout 2 ASCII.live/can-you-hear-me || echo "[Serveur Rickroll injoignable]"

clear
# FORCE LE CODE DE SORTIE A 0 (C'est ce qui règle ton erreur exit code 1)
exit 0
EOF

chmod +x "$PAYLOAD_PATH"

# 4. Configuration SSH pour autoriser les messages interactifs
echo "[*] Mise à jour de la configuration SSH..."
SSHD_CONFIG="/etc/ssh/sshd_config"
[ -f "$SSHD_CONFIG" ] && {
    sed -i 's/^#UsePAM yes/UsePAM yes/' "$SSHD_CONFIG"
    sed -i 's/^KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' "$SSHD_CONFIG"
    sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' "$SSHD_CONFIG"
    systemctl restart ssh
}

# 5. Injection dans PAM (Le cœur du système)
PAM_FILE="/etc/pam.d/common-auth"
if ! grep -q "rickroll-fail.sh" "$PAM_FILE"; then
    echo "[*] Injection de la règle dans PAM..."
    # On l'insère juste après la vérification pam_unix.so
    sed -i '/pam_unix.so/a auth [default=die] pam_exec.so /usr/local/bin/rickroll-fail.sh' "$PAM_FILE"
fi

echo "----------------------------------------------------"
echo "DEPLOIEMENT TERMINE !"
echo "Si le mot de passe est faux, le Rickroll durera 5s."
echo "----------------------------------------------------"
