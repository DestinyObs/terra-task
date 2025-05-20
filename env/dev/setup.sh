#!/bin/bash

# Update and install NGINX
sudo apt-get update -y
sudo apt-get install nginx -y

# Create a simple webpage
echo "<h1>Hello from Dev Environment - Powered by Terraform & NGINX</h1>" | sudo tee /var/www/html/index.html

# Start NGINX
sudo systemctl enable nginx
sudo systemctl start nginx
