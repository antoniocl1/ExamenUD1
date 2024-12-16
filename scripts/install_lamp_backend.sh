#!/bin/bash
# Para mostrar los comandos que se van ejecutando
set -ex

# Actualizamos los repositorios
apt update

# Importamos el archivo .env
source .env

# Actualizamos los paquetes
apt upgrade -y



# Instalamos mysql server
apt install mysql-server -y

# Configuramos el archivo /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s/127.0.0.1/$BACKEND_PRIVATE_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de mysql
systemctl restart mysql