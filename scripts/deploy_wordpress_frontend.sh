#!/bin/bash

#
set -ex

# Importamos el archivo de variables
source .env

# Eliminamos descargas previas de WP-CLI
rm -rf /tmp/wp-cli.phar*

# Descargamos WP-CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Damos permisos de ejecucióna WP-CLI
chmod +x /tmp/wp-cli.phar

# Movemos el script WP-CLI al directorio /usr/local/bin
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos isntalaciones previas en /var/www/html
rm -rf $WORDPRESS_DIRECTORY/*

# Descargamos el código fuente de wordpress
wp core download \
  --locale=es_ES \
  --path=/var/www/html \
  --allow-root
# Creamos el archivo de configuración
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$WORDPRESS_DB_HOST \
  --path=$WORDPRESS_DIRECTORY \
  --allow-root

# Instalamos Wordpress
wp core install \
  --url=$LE_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=$WORDPRESS_DIRECTORY \
  --allow-root  

# Instalamos y activamos el tema de mindscape
wp theme install mindscape --activate --path=$WORDPRESS_DIRECTORY --allow-root

# Instalamos un plugin
wp plugin install wps-hide-login --activate --path=$WORDPRESS_DIRECTORY --allow-root

# Configuramos el plugin whl
wp option update whl_page "$WORDPRESS_HIDE_LOGIN_URL" --path=$WORDPRESS_DIRECTORY --allow-root

# Configuramos los enlaces permanentes
wp rewrite structure '/%postname%/' \
  --path=$WORDPRESS_DIRECTORY \
  --allow-root

# Copiamos el archivo .htaccess
cp ../htaccess/.htaccess $WORDPRESS_DIRECTORY

# Modificamos el propietario
chown -R www-data:www-data $WORDPRESS_DIRECTORY