#!/bin/bash
#cn / controller node setup / vm1
apt update && apt upgrade -y # Met à jour la liste des paquets et installe les mises à jour disponibles
adduser cn_user --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password # Crée un nouvel utilisateur sans mot de passe
echo "cn_user:cn_p@ssword" | chpasswd # Définit le mot de passe pour l'utilisateur cn_user
usermod -aG sudo cn_user # Ajoute l'utilisateur cn_user au groupe sudo pour les privilèges administratifs

# Configuration de l'accès SSH pour cn_user
mkdir -p /home/cn_user/.ssh
chown cn_user:cn_user /home/cn_user/.ssh
chmod 700 /home/cn_user/.ssh

ssh-keygen -t RSA -b 4096 -C "cn_user@localhost" -f /home/cn_user/.ssh/id_cn -N ""

# Soit copier localement pour éviter doublons
cp /home/cn_user/.ssh/id_cn.pub /home/cn_user/.ssh/authorized_keys
chown cn_user:cn_user /home/cn_user/.ssh/authorized_keys
chmod 600 /home/cn_user/.ssh/authorized_keys

# Puis modifier sshd_config proprement
grep -qxF 'PermitRootLogin no' /etc/ssh/sshd_config || echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
grep -qxF 'PasswordAuthentication no' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

systemctl restart sshd

# copier la clé vers le nœud de gestion (doit être accessible)
ssh-copy-id -i /home/cn_user/.ssh/id_cn.pub mn_user@192.168.56.112

# verification python3 installation
if ! command -v python3 &> /dev/null
then
    apt install python3 -y # Installe Python3 si ce n'est pas déjà fait
fi
# Nettoie les paquets inutiles
apt autoremove -y
# Met à jour les paquets et installe les dépendances nécessaires
# a installer sur host : vagrant plugin install vagrant-vbguest

apt install -y build-essential dkms linux-headers-$(uname -r) linux-image-$(uname -r)

# Monte automatiquement l'image CD des Additions Invité si elle est insérée
if [ -e /dev/cdrom ]; then
    mkdir -p /mnt/cdrom
    mount /dev/cdrom /mnt/cdrom
    /mnt/cdrom/VBoxLinuxAdditions.run || true
    umount /mnt/cdrom
fi