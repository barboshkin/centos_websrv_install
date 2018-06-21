#!/bin/bash
# 
clear
echo ""
echo "Обновление системы и установка нужных пакетов"
echo ""
echo ""
read -e -p "Установить PHP 7 версии? [y/N] : " PHP7
echo ""
echo ""
sleep 3

clear
sudo yum -y install epel-release
sudo yum -y update
sudo yum -y upgrade
sudo yum -y groupinstall "Development Tools" 
sudo yum -y install gmp-devel curl-devel libidn-devel libssh2-devel python-devel openldap-devel vim git net-tools bind-utils gcc make wget memcached libmemcached-devel
echo ""
echo "Использование FIREWALL :"
echo ""
sudo systemctl stop firewalld
sudo systemctl disabled firewalld
echo ""
sudo systemctl status firewalld
echo ""
echo "Проверка SeLinux :"
echo ""
sudo sed -i 's/enforcing/disabled/' /etc/selinux/config
sudo sed -i 's/permissive/disabled/' /etc/selinux/config
echo ""
sudo sestatus
echo ""
sleep 5
clear

# Установка WEBSERV
echo ""
echo "Установка Apache :"
echo ""
sleep 3
sudo yum -y install httpd
echo ""
sudo systemctl start httpd
sudo systemctl enable httpd
echo ""
echo "Проверка Apache :"
echo ""
sudo systemctl status httpd
echo ""
echo ""
sleep 5
clear

# Установка DB (MariaDB)
echo ""
echo "Установка MariaDB :"
echo ""
sleep 3
sudo yum -y install mariadb-server mariadb mariadb-devel
sudo systemctl start mariadb 
sudo systemctl enable mariadb
echo ""
echo "Начало работы с БД :"
sudo mysql_secure_installation
echo ""
echo "Проверка установки БД :"
echo ""
sudo systemctl status mariadb
echo ""
sleep 5
clear

# Установка PHP
echo ""
echo "Установка PHP :"
echo ""
sleep 3
if [[ ("$PHP7" == "y" || "$PHP7" == "Y") ]]; then
		sudo yum -y install wget
		sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
		sudo yum -y install php70w php70w-opcache php70w-devel php70w-mysqlnd php70w-common php70w-gd php70w-ldap php70w-odbc php70w-pear php70w-xml php70w-xmlrpc php70w-mbstring php70w-snmp php70w-soap php70w-mcrypt php70w-imap php70w-cli php70w-intl php70w-pspell php70w-tidy php70w-pecl-imagick ImageMagick  ruby-libs php70w-bcmath
		sudo systemctl start memcached
		sudo systemctl enable memcached
else		
		sudo yum -y install php php-devel php-mysql php-common php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap php-mcrypt curl curl-devel php-imap php-cli ImageMagick ruby-libs php-intl php-pspell php-recode php-tidy php-pecl-imagick
		sudo systemctl start memcached
		sudo systemctl enable memcached	
fi

git clone https://github.com/websupport-sk/pecl-memcache.git
cd pecl-memcache 
sudo phpize 
sudo ./configure --disable-memcache-sasl 
sudo make 
sudo make install
sudo cd ..
echo ""
echo "Проверка установки Memcached :"
echo ""
sudo systemctl status memcached
echo ""
echo ""
sleep 5
clear

# Установка phpMyAdmin
echo ""
echo "Установка phpMyAdmin :"
echo ""
sleep 3
sudo yum -y install phpMyAdmin
sudo touch /var/www/html/info.php
sudo echo "<?php phpinfo(); ?>" |sudo tee  /var/www/html/info.php
sudo touch /var/www/html/index.html
sudo echo "TEST OK" |sudo tee  /var/www/html/index.html
echo ""
echo ""
sleep 5
clear

# Проверка config
echo ""
echo "перезапуск Apache :"
echo ""
sleep 3
sudo systemctl restart httpd
echo ""
echo ""
echo ""
echo ""
echo ""
sudo systemctl status httpd
echo ""
echo ""
echo ""
echo ""
echo ""
sudo systemctl status memcached
echo ""
echo ""
echo "установка ЗАВЕРШЕНА :)"
