#!/bin/bash

# Define variables
WEB_ROOT="/var/www/html"
DB_NAME="demo_db"
DB_USER="demo_user"
DB_PASS="Root@123"

# Update and install dependencies
echo "Updating system and installing required packages..."
sudo apt-get update
sudo apt install apache2 php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip wget unzip

# Enable Apache and restart it
sudo systemctl enable apache2
sudo systemctl status apache2
sudo systemctl restart apache2
exit

# Install Mysql server
sudo apt install mysql-server
sudo mysql_secure_installation
sudo systemctl enable mysql
sudo systemctl status mysql
exit
# Install WordPress
cd /var/www/html
sudo wget -c http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo chown -R www-data:www-data /var/www/html/wordpress

#Create a Database for WordPress
sudo mysql -u root
CREATE DATABASE demo_db;
CREATE USER demo_user@localhost IDENTIFIED BY 'Root@123';
GRANT ALL PRIVILEGES ON demo_db. * TO demo_user@localhost;
FLUSH PRIVILEGES;
exit;

sudo mysql -u root -p"Root@123" -e "
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;"
# Configure WordPress
echo "Configuring WordPress..."
sudo chmod -R 777 wordpress/
cd wordpress/
mv wp-config-sample.php wp-config.php

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart apache2




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

-------------------------NEW ------------------------------------------------
#!/bin/bash

# Define variables
WEB_ROOT="/var/www/html"
DB_NAME="demo_db"
DB_USER="demo_user"
DB_PASS="Root@123"

# Update and install dependencies
echo "Updating system and installing required packages..."
sudo apt-get update
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip wget unzip mysql-server

# Enable and start Apache
echo "Starting and enabling Apache..."
sudo systemctl enable --now apache2

# Secure MySQL installation (Non-interactive)
echo "Securing MySQL..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASS'; FLUSH PRIVILEGES;"

# Create MySQL database and user
echo "Creating MySQL database and user for WordPress..."
sudo mysql -u root -e "
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;"


# Download and configure WordPress
echo "Downloading WordPress..."
cd $WEB_ROOT
sudo wget -q https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo rm latest.tar.gz
sudo chown -R www-data:www-data $WEB_ROOT/wordpress
sudo chmod -R 755 $WEB_ROOT/wordpress

# Configure wp-config.php
echo "Configuring WordPress..."
sudo cp $WEB_ROOT/wordpress/wp-config-sample.php $WEB_ROOT/wordpress/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WEB_ROOT/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WEB_ROOT/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WEB_ROOT/wordpress/wp-config.php

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart apache2

# Display completion message
echo "✅ WordPress installation completed! Visit your server's public IP to finish the setup."

