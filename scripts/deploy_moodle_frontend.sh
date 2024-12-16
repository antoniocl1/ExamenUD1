#!/bin/bash

# Mostramos los comandos que se van ejecutando
set -ex

# Importamos el archivo de variables
source .env

# Eliminamos descargas previas de Moodle
rm -rf /tmp/moodle-4.3.1.zip*

# Descargamos WP-CLI
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /tmp

# Damos permisos de ejecucióna WP-CLI
chmod +x /tmp/moodle-4.3.1.zip

# Eliminamos instalaciones previas de Moodle en /var/www/html
rm -rf $MOODLE_DIRECTORY/*

# Instalamos unzip
apt install unzip -y

# Descomprimimos el zip a /var/www/html
unzip /tmp/moodle-4.3.1.zip -d $MOODLE_DIRECTORY

# Eliminamos el zip porque ya lo hemos descomprimido
rm -rf /$MOODLE_DIRECTORY/v4.3.1.zip 

# Damos permisos al directorio donde instalaremos Moodle
chown -R root $MOODLE_DIRECTORY
chmod -R 0755 $MOODLE_DIRECTORY

# Creamos el directorio donde guardaremos el Moodle Data
mkdir $MOODLE_DATA_DIRECTORY
chmod 0777 $MOODLE_DATA_DIRECTORY

# Instalación de Moodle con CLI
sudo -u www-data php $MOODLE_DIRECTORY/admin/cli/install.php \
  --lang=MOODLE_LANG \
  --wwwroot=$MOODLE_WWWROOT \
  --dataroot=$MOODLE_DATAROOT \
  --dbtype=$MOODLE_DB_TYPE \
  --dbhost=$MOODLE_DB_HOST \
  --dbname=$MOODLE_DB_NAME \
  --dbuser=$MOODLE_DB_USER \
  --dbpass=$MOODLE_DB_PASS \
  --fullname=$MOODLE_FULLNAME \
  --shortname=$MOODLE_SHORTNAME \
  --summary=$MOODLE_SUMMARY \
  --admin-user=$MOODLE_ADMIN_USER \
  --admin-pass=$MOODLE_ADMIN_PASS \
  --adminemail=$MOODLE_ADMIN_EMAIL \
  --non-interactive \
  --agree-license

# Configuramos proxy inverso con sed
set -i "/\$CFG->admin/a \$CFG->reverseproxy=1;\n\$CFG->sslproxy=1;" /var/www/html/config.php

# Modificamos el propietario
chown -R www-data:www-data $MOODLE_DIRECTORY