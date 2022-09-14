#!/bin/bash

# Install apache2 package
sudo apt update
sudo apt install apache2

# Enable apache2 service
sudo systemctl start apache2
sudo systemctl enable apache2

# Download web template
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
unzip -o 2117_infinite_loop.zip
cp -r 2117_infinite_loop/* /var/www/html

# Restart apache2 service
sudo systemctl restart apache2