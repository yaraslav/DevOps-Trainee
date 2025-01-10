#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apache2 php php-fpm
sudo apt-get install libapache2-mod-php -y
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.3-fpm
sudo systemctl start apache2
sudo systemctl enable apache2

echo "<?php phpinfo(); ?>" > /var/www/html/info.php
