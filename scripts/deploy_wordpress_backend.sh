#!/bin/bash
# Mostramos los comandos que se van ejecutando
set -ex
# Importamos el archivo de variables
source .env
# Realizamos la creación de una base de datos que utilizaremos de prueba
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
# Creamos el usuario que será capaz de acceder a la base de datos con todos los permisos
mysql -u root -e "DROP USER IF EXISTS '$WORDPRESS_DB_USER'@'$FRONTEND_PRIVATE_IP';"
mysql -u root -e "CREATE USER '$WORDPRESS_DB_USER'@'$FRONTEND_PRIVATE_IP' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'$FRONTEND_PRIVATE_IP';"