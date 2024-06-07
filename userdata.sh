#!/bin/bash

# Update the system
sudo apt update -y
sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Install PHP and its extensions
sudo apt install -y php php-mysql php-bcmath php-ctype php-fileinfo php-json php-openssl php-gd php-tokenizer

# Install Git
sudo apt install git -y

# Change to Home Directory
cd ~

# Clone the repository
git clone https://github.com/sandeshlama7/LAMP-EmployeeApp.git

# Update the DB_SERVER placeholder with the RDS endpoint
sed -i "s/DB_SERVER/'${RDS_ENDPOINT}'/g" LAMP-EmployeeApp/index.php

# Move the application files to the web root
sudo mv LAMP-EmployeeApp/* /var/www/html/

# Install MySQL Client
sudo apt install -y mysql-client

# Restart Apache
sudo systemctl restart apache2
