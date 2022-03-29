#!/bin/bash
sudo apt-get install apache2 php php-mysql -y 
sudo apt-get install wget
sudo wget https://wordpress.org/latest.tar.gz 
sudo tar -xf latest.tar.gz -C /var/www/html/ 
sudo mv /var/www/html/index.html  /tmp/
sudo mv /var/www/html/wordpress/* /var/www/html/ 
sudo systemctl restart apache2 
sudo systemctl enable apache2
