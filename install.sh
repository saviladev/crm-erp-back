#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install apache2 php libapache2-mod-php php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip composer -y

sudo composer install

cp .env.example .env
php artisan key:generate
php artisan jwt:secret

sudo chmod -R 775 /var/www/web-back /var/www/
sudo chown -R www-data:www-data /var/www/web-back

sudo cp install/dir.conf /etc/apache2/mods-enabled/
sudo cp install/laravel.conf /etc/apache2/sites-available/

sudo a2ensite laravel
sudo a2enmod rewrite
sudo systemctl restart apache2