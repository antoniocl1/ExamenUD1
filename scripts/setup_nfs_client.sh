#!/bin/bash
# Mostramos los comandos que se van ejecutando
set -ex

# Importamos el archivo .env
source .env

# Actualizamos los repositorios
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos el cliente NFS
apt install nfs-common -y

# Montamos el directorio
sudo mount $SERVER_IP:$MOODLE_DIRECTORY $MOODLE_DIRECTORY
sudo mount $SERVER_IP:$MOODLE_DATA_DIRECTORY $MOODLE_DATA_DIRECTORY

# Cambiamos la variable de /etc/fstab
echo "$SERVER_IP:$MOODLE_DIRECTORY $MOODLE_DIRECTORY nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
echo "$SERVER_IP:$MOODLE_DATA_DIRECTORY $MOODLE_DATA_DIRECTORY nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab