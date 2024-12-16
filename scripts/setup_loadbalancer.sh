#!/bin/bash

#Para mostrar los comandos que se van ejecutando
set -ex

# Importamos el archivo .env
source .env

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
apt upgrade -y

# Instalamos nginx
apt install nginx -y

# Deshabilitamos el enlace simbólico
# unlink /etc/nginx/sites-enabled/default Comentado porque da error despues de ejecutarlo por primera vez

# Copiamos el .conf a /etc/nginx/sites-available
cp ../conf/load_balancer.conf /etc/nginx/sites-available

# Modificamos el archivo copiado en la ruta correcta
sed -i "s/IP_FRONTEND_1/$IP_FRONTEND_1/" /etc/nginx/sites-available/load_balancer.conf
sed -i "s/IP_FRONTEND_2/$IP_FRONTEND_2/" /etc/nginx/sites-available/load_balancer.conf
sed -i "s/LE_DOMAIN/$LE_DOMAIN/" /etc/nginx/sites-available/load_balancer.conf

# Comprobamos que el archivo ya esté activo
if [ ! -f "/etc/nginx/sites-enabled/load_balancer.conf" ]; then
ln -s /etc/nginx/sites-available/load_balancer.conf /etc/nginx/sites-enabled/
fi

# Reiniciamos nginx
systemctl reload nginx