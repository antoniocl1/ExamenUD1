#!/bin/bash

# Mostramos los comandos que se van ejecutando
set -ex

# Importamos el archivo de variables
source .env

# modulo para reescribir
a2enmod rewrite

# Configurar parametro max_input_vars
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/cli/php.ini

# Eliminamos descargas previas de Moodle
rm -rf /tmp/v4.3.1.zip*
rm -rf $MOODLE_DIRECTORY/*
rm -rf $MOODLE_DATA_DIRECTORY*

# Cambiamos el propietario y el grupo al directorio /var/www/html/ y moodledata
chown -R www-data:www-data $MOODLE_DIRECTORY
chown -R 755 $MOODLE_DATA_DIRECTORY
chown -R www-data:www-data $MOODLE_DATA_DIRECTORY

# Descargamos WP-CLI
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /tmp

# Instalamos unzip
apt install unzip -y

# Descomprimimos el zip y lo movemos a /var/www/html
unzip /tmp/v4.3.1.zip -d /tmp
mv /tmp/moodle-4.3.1/* $MOODLE_DIRECTORY

# Eliminamos el zip porque ya lo hemos descomprimido
rm -rf $MOODLE_DIRECTORY/v4.3.1.zip 

# Creamos el directorio donde guardaremos el Moodle Data
mkdir -p $MOODLE_DATA_DIRECTORY

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
  --fullname="$MOODLE_FULLNAME" \
  --shortname="$MOODLE_SHORTNAME" \
  --summary="$MOODLE_SUMMARY" \
  --adminuser=$MOODLE_ADMIN_USER \
  --adminpass=$MOODLE_ADMIN_PASS \
  --adminemail=$MOODLE_ADMIN_EMAIL \
  --non-interactive \
  --agree-license

# Configuramos proxy inverso con sed
set -i "/\$CFG->admin/a \$CFG->reverseproxy=1;\n\$CFG->sslproxy=1;" /var/www/html/config.php

# Modificamos el propietario
chown -R www-data:www-data $MOODLE_DIRECTORY