#!/bin/bash
#mn / manger node setup / vm2
set -e
apt update && apt upgrade -y # Met à jour la liste des paquets et installe les mises à jour disponibles
# Crée un utilisateur avec la possibilité de connexion par mot de passe
adduser mn_user --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
# Débloquer le mot de passe (pour permettre connexion)
passwd -d mn_user

# Définir le mot de passe
echo "mn_user:mn_p@ssword" | chpasswd

# Ajouter l'utilisateur au groupe sudo
usermod -aG sudo mn_user

# Assurer que le shell est valide (bash)
usermod -s /bin/bash mn_user

# Création dossier SSH et réglage permissions
mkdir -p /home/mn_user/.ssh
chown mn_user:mn_user /home/mn_user/.ssh
chmod 700 /home/mn_user/.ssh


sudo -u mn_user ssh-keygen -t rsa -b 4096 -C "mn_user@localhost" -f /home/mn_user/.ssh/id_mn -N ""

# Soit copier localement pour éviter doublons
cp /home/mn_user/.ssh/id_mn.pub /home/mn_user/.ssh/authorized_keys
chown mn_user:mn_user /home/mn_user/.ssh/authorized_keys
chmod 600 /home/mn_user/.ssh/authorized_keys

# Puis modifier sshd_config proprement
grep -qxF 'PermitRootLogin no' /etc/ssh/sshd_config || echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
grep -qxF 'PasswordAuthentication no' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

systemctl restart sshd

# copier la clé vers le nœud de gestion (doit être accessible)
ssh-copy-id -i /home/mn_user/.ssh/id_mn.pub cn_user@192.168.56.111

# verification python3 installation
if ! command -v python3 &> /dev/null
then
    apt install python3 -y # Installe Python3 si ce n'est pas déjà fait
fi
# Nettoie les paquets inutiles
apt autoremove -y