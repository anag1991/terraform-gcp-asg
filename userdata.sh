#!/bin/bash
# Install necessary tools
sudo yum install httpd wget unzip epel-release mysql -y
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php74
sudo yum install php -y
sudo yum install php-mysql -y
# Download latest wordpress
wget https://wordpress.org/latest.tar.gz
tar -xf latest.tar.gz -C /var/www/html/
mv /var/www/html/wordpress/* /var/www/html/
getenforce
sed 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/sysconfig/selinux -i
setenforce 0
sudo chown -R apache:apache /var/www/html/
# Start web server
sudo systemctl restart httpd
sudo systemctl enable httpd