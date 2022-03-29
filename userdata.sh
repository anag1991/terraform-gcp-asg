#!/bin/bash
# Install necessary tools
yum install httpd wget unzip epel-release mysql -y
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php74
yum install php -y
yum install php-mysql -y
# Download latest wordpress
wget https://wordpress.org/latest.tar.gz
tar -xf latest.tar.gz -C /var/www/html/
mv /var/www/html/wordpress/* /var/www/html/
getenforce
sed 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/sysconfig/selinux -i
setenforce 0
chown -R apache:apache /var/www/html/
# Start web server
systemctl restart httpd
systemctl enable httpd