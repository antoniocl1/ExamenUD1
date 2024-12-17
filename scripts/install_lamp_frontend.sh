#!/bin/bash

# Para mostrar los comandos que se van ejecutando
set -ex

# Actualizamos los repositorios
apt update

# Actualizamos los paquetes
apt upgrade -y

# Instalamos el servidor web Apache
apt install apache2 -y

# Habilitamos módulo rewrite
a2enmod rewrite

# Copiamos el archivo de configuración de Apache
cp ../conf/000-default.conf /etc/apache2/sites-available

# Instalamos PHP y algunos módulos de PHP para Apache y MySQL requeridos para el examen
sudo apt install php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl php-soap -y

# Reiniciamos el servicio de apache
systemctl restart apache2

# Copiamos el script de Prueba de PHP en /var/www/html
cp ../php/index.php /var/www/html

# Modificamos el propietario y el grupo del directorio donde se encuentra el index.php
chown -R www-data:www-data /var/www/html 

# Creamos el directorio de datos de moodle
mkdir -p /var/moodledata

# Modificamos el propietario de moodledata
chown -R www-data:www-data /var/moodledata