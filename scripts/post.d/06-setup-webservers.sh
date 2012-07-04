#!/bin/bash

## Configure apache

a2dissite default
a2ensite bootstrap-wordpress

a2enmod rewrite

/etc/init.d/apache2 restart

## configure nginx

rm /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/bootstrap-wordpress /etc/nginx/sites-enabled/

mkdir -p /mnt/www/cache
mkdir -p /mnt/www/logs
chown -Rf www-data.www-data /mnt/www

/etc/init.d/nginx restart
