#!/bin/bash
# Mostramos los comandos que se van ejecutando
set -ex

# Importamos el archivo de variables
source .env

# Actualizamos los repositorios
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos el servidor NFS
apt install nfs-kernel-server -y

# Creamos el directorio
mkdir -p $MOODLE_DIRECTORY
mkdir -p $MOODLE_DATA_DIRECTORY
# Le quitamos el dueño al dirextorio
sudo chown nobody:nogroup $MOODLE_DIRECTORY
sudo chown nobody:nogroup $MOODLE_DATA_DIRECTORY

# Copiamos nuestro exports personalizado a /etc/exports
cp ../exports/exports /etc/exports

# Reemplazamos el valor de la plantilla de /etc/exports
sed -i "s#FRONTEND_IP_RANGE#$FRONTEND_IP_RANGE#g" /etc/exports
sed -i "s#MOODLE_DIRECTORY#$MOODLE_DIRECTORY#" /etc/exports
sed -i "s#MOODLE_DATA_DIRECTORY#$MOODLE_DATA_DIRECTORY#" /etc/exports

# Reiniciamos el servicio de NFS
systemctl restart nfs-kernel-server