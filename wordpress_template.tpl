#!/bin/bash
DB_HOST="${DB_HOST}"

sudo apt update
sudo apt install apache2 -y
sudo service apache2 start
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip libapache2-mod-php php-mysqli -y
sudo systemctl restart apache2
sudo systemctl enable apache2
cd /etc/apache2/sites-available/000-default.conf
sudo sed -i 's/html/wordpress/' /etc/apache2/sites-available/000-default.conf
sudo echo "<Directory /var/www/wordpress/> AllowOverride All </Directory>" > /etc/apache2/sites-available/wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
echo "<?php" > /tmp/wordpress/wp-config.php
echo "define( 'DB_NAME', 'wordpress' );" >> /tmp/wordpress/wp-config.php
echo "define( 'DB_USER', 'wordpressuser' );" >> /tmp/wordpress/wp-config.php
echo "define( 'DB_PASSWORD', 'qwerty' );" >> /tmp/wordpress/wp-config.php
echo "define( 'DB_HOST', '"$DB_HOST"' );" >> /tmp/wordpress/wp-config.php
echo "define( 'DB_CHARSET', 'utf8' );" >> /tmp/wordpress/wp-config.php
echo "define( 'DB_COLLATE', '' );" >> /tmp/wordpress/wp-config.php
echo "define('FS_METHOD', 'direct');" >> /tmp/wordpress/wp-config.php
echo "/**#@+" >> /tmp/wordpress/wp-config.php
echo " */" >> /tmp/wordpress/wp-config.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /tmp/wordpress/wp-config.php
echo "/**#@-*/" >> /tmp/wordpress/wp-config.php
echo "\$table_prefix = 'wp_';" >> /tmp/wordpress/wp-config.php
echo "define( 'WP_DEBUG', true );" >> /tmp/wordpress/wp-config.php
echo "define( 'WP_DEBUG_LOG', true );" >> /tmp/wordpress/wp-config.php
echo "define( 'SAVEQUERIES', true );" >> /tmp/wordpress/wp-config.php
echo "if ( ! defined( 'ABSPATH' ) ) {" >> /tmp/wordpress/wp-config.php
echo "    define( 'ABSPATH', __DIR__ . '/' );" >> /tmp/wordpress/wp-config.php
echo "}" >> /tmp/wordpress/wp-config.php
echo "require_once ABSPATH . 'wp-settings.php';" >> /tmp/wordpress/wp-config.php
sudo cp -a /tmp/wordpress/. /var/www/wordpress/
sudo find /var/www/wordpress/ -type d -exec chmod 750 {} \;
sudo find /var/www/wordpress/ -type f -exec chmod 640 {} \;
sudo systemctl restart apache2
cd /var
sudo mkdir wwwobent
cp -R /var/www/* /var/wwwobent/
sudo rm -rf /var/www/*
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse  -y
gcsfuse -o allow_other --uid=33 --gid=33 mytestbucket_obent12 /var/www
sudo sed -i 's/www-data:x:33:33:www-data:\/var\/www:\/usr\/sbin\/nologin/www-data:x:33:33:www-data:\/var\/www:\/bin\/bash/' /etc/passwd
sudo chown -R www-data:www-data /var/wwwobent/wordpress
if [ $(ls -al /var/www/ | wc -l) -gt 3 ]
then
  echo "not empty"
else
 sudo cp -R /var/wwwobent/* /var/www/
fi
