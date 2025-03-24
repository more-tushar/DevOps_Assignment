#!/bin/bash

# Define variables
DB_NAME="wordpress_db"
DB_USER="wordpress_user"
DB_PASS="Wp@12345"
WP_DIR="/var/www/html/wordpress"

# Update and install dependencies
echo "Updating system and installing required packages..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y apache2 mysql-server php  php-curl php-gd php-mbstring php-xml php-xmlrpc wget unzip

# Enable Apache and restart it
sudo systemctl enable apache2
sudo systemctl start apache2

# Secure MySQL (auto-approve insecure configurations)
echo "Securing MySQL..."
sudo mysql -u root <<MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Root@123';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Create MySQL database and user
echo "Creating MySQL database and user..."
sudo mysql -u root -pRoot@123 <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'Wp@12345';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost';
# Install WordPress
echo "Downloading and setting up WordPress..."
sudo wget -q https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
sudo tar -xzf /tmp/wordpress.tar.gz -C /var/www/html/
sudo chown -R www-data:www-data $WP_DIR
sudo chmod -R 755 $WP_DIR

# Configure WordPress
echo "Configuring WordPress..."
sudo cp $WP_DIR/wp-config-sample.php $WP_DIR/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_DIR/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WP_DIR/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WP_DIR/wp-config.php

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart apache2

# Output connection string
echo "WordPress installation completed!"
echo "Use the following MySQL connection details:"
echo "mysql -u $DB_USER -p$DB_PASS -D $DB_NAME"

