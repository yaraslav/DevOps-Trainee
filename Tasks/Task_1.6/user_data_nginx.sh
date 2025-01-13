#!/bin/bash
sudo apt-get update -y

sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo rm -r /var/www/html/index.nginx-debian.html

TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 --header "X-aws-ec2-metadata-token: $TOKEN") 

echo "This is My private IP is $LOCAL_IP" | sudo tee /var/www/html/index.nginx-debian.html

if sudo nginx -t; then
    echo "Nginx configuration is valid. Reloading Nginx..."
    sudo systemctl reload nginx
    echo "Nginx reloaded successfully."
else
    echo "Nginx configuration is invalid. Please fix the issues and try again."
fi
