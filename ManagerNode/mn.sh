#!/bin/bash
#mn / manger node setup / vm2
export http_proxy="http://192.168.56.200:3142/"
export https_proxy="http://192.168.56.200:3142/"
export no_proxy="localhost,127.0.0.1,.devops-afpa.fr"
source /etc/profile.d/proxy.sh

apt update && apt upgrade -y # Met à jour la liste des paquets et installe les mises à jour disponibles
adduser mn_user --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password # Crée un nouvel utilisateur sans mot de passe
echo "mn_user:mn_p@ssword" | chpasswd # Définit le mot de passe pour l'utilisateur mn_user
usermod -aG sudo mn_user # Ajoute l'utilisateur mn_user au groupe sudo pour les privilèges administratifs

# Configuration de l'accès SSH pour mn_user
mkdir -p /home/mn_user/.ssh
chown mn_user:mn_user /home/mn_user/.ssh
chmod 700 /home/mn_user/.ssh

ssh-keygen -t RSA -b 4096 -C "mn_user@localhost" -f /home/mn_user/.ssh/id_mn -N ""

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