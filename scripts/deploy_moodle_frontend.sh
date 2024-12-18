#!/bin/bash

# Mostramos los comandos que se van ejecutando
set -ex

# Importamos el archivo de variables
source .env

# Instalamos unzip
apt install unzip -y

# Eliminamos descargas previas de Moodle
rm -rf /tmp/v4.3.1.zip
rm -rf /var/www/html/*
rm -rf /var/moodledata/*

# Creo carpeta moodledata (por si acaso)
sudo mkdir -p /var/moodledata

# Configurar parametro max_input_vars
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/apache2/php.ini
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.3/cli/php.ini

# Descargamos Moodle
wget https://github.com/moodle/moodle/archive/refs/tags/v4.3.1.zip -P /tmp

# Descomprimo el zip y lo muevo
unzip /tmp/v4.3.1.zip -d /tmp
mv /tmp/moodle-4.3.1/* $MOODLE_DIRECTORY

# Cambiamos propietario y grupo
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chown -R www-data:www-data /var/moodledata
sudo chmod -R 755 /var/moodledata

# Instalación de Moodle con CLI
sudo -u www-data php /var/www/html/admin/cli/install.php \
    --lang=$MOODLE_LANG \
    --wwwroot=$MOODLE_WWWROOT \
    --dataroot=$MOODLE_DATA_ROOT \
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
sed -i "/\$CFG->admin/a \$CFG->reverseproxy=1;\n\$CFG->sslproxy=1;" /var/www/html/config.php
